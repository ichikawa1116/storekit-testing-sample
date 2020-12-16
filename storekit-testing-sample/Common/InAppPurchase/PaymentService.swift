//
//  PaymentService.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import Foundation
import Combine
import StoreKit

protocol PaymentServiceType {
    func fetchProducts() -> AnyPublisher<[SubscriptionProduct], Never>
    func purchase(productId: SubscriptionProduct.Id) -> AnyPublisher<PaymentState, Never>
}

enum PaymentState {
    case purchasing
    case purchased
    case failed(Error)
    case restored
    case deferred
}

final class PaymentService: NSObject, PaymentServiceType {
    
    static let shared = PaymentService()
    
    let productIdentifiers: Set<String> = [
        "test_subsctiontion_1",
        "test_subsctiontion_2"
    ]
    
    private let products = CurrentValueSubject<[SKProduct], Never>([])
    private var _paymentState = PassthroughSubject<PaymentState, Never>()
    private var _updatedTransactions = PassthroughSubject<[SKPaymentTransaction], Never>()
    private let _purchase = PassthroughSubject<SubscriptionProduct.Id, Never>()
    
    override init() {
        super.init()
        
        addPaymentQueue()
        
        _updatedTransactions
            .combineLatest(_purchase.eraseToAnyPublisher())
            .receive(subscriber: Subscribers.Sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] (transactions, id) in
                    guard let self = self else {
                        fatalError()
                    }
                    guard let transaction = transactions.filter({ $0.payment.productIdentifier == id.id }).first else {
                        self._paymentState.send(.failed(PaymentError.notFound))
                        return
                    }

                    switch transaction.transactionState {
                    
                    case .purchasing:
                        self._paymentState.send(.purchasing)
                    case .purchased:
                        self._paymentState.send(.purchased)
                    case .failed:
                        self.finish(transaction: transaction)
                        self._paymentState.send(
                            .failed(transaction.error ?? PaymentError.unknown)
                        )
                    case .restored:
                        self._paymentState.send(.restored)
                    case .deferred:
                        self._paymentState.send(.deferred)
                    @unknown default:
                        break
                    }
                }
            ))

        _purchase
            .tryMap { [weak self] id -> Result<SKPayment, PaymentError> in
                guard let product = self?.products.value.filter({ $0.productIdentifier == id.id }).first else {
                    return .failure(PaymentError.notFound)
                }
                
                var payment = SKMutablePayment(product: product)
                
                payment.simulatesAskToBuyInSandbox = true

                return .success(SKMutablePayment(product: product))
            }
            .receive(subscriber: Subscribers.Sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] result in
                    switch result {
                    case let .success(payment):
                        print(payment.simulatesAskToBuyInSandbox)
                        self?.add(payment: payment)
                    case let .failure(error):
                        self?._paymentState.send(.failed(error))
                    }
                }
            ))
    }
    
    deinit {
        removePaymentQueue()
    }
    
    func fetchProducts() -> AnyPublisher<[SubscriptionProduct], Never> {
        
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        
        return products
            .map { $0.map(SubscriptionProduct.init(product:)) }
            .eraseToAnyPublisher()
    }
    
    func purchase(productId: SubscriptionProduct.Id) -> AnyPublisher<PaymentState, Never> {
        
        print(productId)
        _purchase.send(productId)
        return _paymentState.eraseToAnyPublisher()
    }
    
    private func sendReceipt(transaction: SKPaymentTransaction) {
        // 本来はここでレシート送信をするが、そこは省略。
        _paymentState.send(.purchased)
    }

}

extension PaymentService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products.value = response.products
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        _paymentState.send(.failed(PaymentError.failedPurchase))
    }
}

extension PaymentService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        _updatedTransactions.send(transactions)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        _paymentState.send(.failed(PaymentError.failedRestore))
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        _paymentState.send(.restored)
    }
}

extension PaymentService: SKRequestDelegate {
    
    func addPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    func removePaymentQueue() {
        SKPaymentQueue.default().remove(self)
    }
    
    func finish(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func add(payment: SKPayment) {
        SKPaymentQueue.default().add(payment)
    }
    
}
