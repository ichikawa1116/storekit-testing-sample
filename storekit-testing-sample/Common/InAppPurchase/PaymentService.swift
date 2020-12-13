//
//  PaymentService.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import Foundation
import Combine
import StoreKit

protocol PaymentManagerType {
    func fetchProducts() -> AnyPublisher<[SubscriptionProduct], Never>
    //func purchase(productId: SubscriptionProduct.Id)
}

class PaymentManager: NSObject, PaymentManagerType {
    
    static let shared = PaymentManager()
    
    let productIdentifiers: Set<String> = [
        "com.nonchalant.consumable1",
        "com.nonchalant.consumable2"
    ]
    
    private let products = CurrentValueSubject<[SubscriptionProduct], Never>([])
    private var paymentState = PassthroughSubject<PaymentState, Never>()
    
    func fetchProducts() -> AnyPublisher<[SubscriptionProduct], Never> {
        
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        
        return products.eraseToAnyPublisher()
    }

}

extension PaymentManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        products.value = response.products
            .map { SubscriptionProduct(product: $0) }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}

extension PaymentManager: SKRequestDelegate {
    
}



struct SubscriptionProduct {
    let id: Id
    let price: String
    
    struct Id {
        let id: String
    }
}

extension SubscriptionProduct {
    
    init(product: SKProduct) {
        id = Id(id: product.productIdentifier)

        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        price = formatter.string(from: product.price) ?? ""
    }
}

enum PaymentState {
    
}
