//
//  SubscriptionViewModel.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import Foundation
import Combine

final class SubscriptionViewModel: ObservableObject {
    
    @Published private(set) var products: [SubscriptionProduct] = []
    @Published private(set) var price: String = ""
    
    private let _fetchProducts = PassthroughSubject<Void, Never>()
    private let _purchase = PassthroughSubject<SubscriptionProduct.Id, Never>()
    private let paymentService: PaymentServiceType
    private var disposables = Set<AnyCancellable>()
    
    init(paymentService: PaymentServiceType) {
        
        self.paymentService = paymentService
        
        _fetchProducts
            .flatMap { paymentService.fetchProducts() }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.products = $0
                self?.price = $0.first?.price ?? ""
            })
            .store(in: &disposables)
        
        _purchase
            .flatMap { paymentService.purchase(productId: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                
            })
            .store(in: &disposables)
    }
    
    func fetchProducts() {
        _fetchProducts.send(())
    }
    
    func purchase(productId: SubscriptionProduct.Id) {
        _purchase.send(productId)
    }
}
