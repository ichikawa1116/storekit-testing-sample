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
    private let _purchase = PassthroughSubject<Void, Never>()
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
            .flatMap { paymentService.purchase() }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                print("成功")
            })
            .store(in: &disposables)
    }
    
    func fetchProducts() {
        _fetchProducts.send(())
    }
    
    func purchase() {
        _purchase.send(())
    }
}
