//
//  SubscriptionViewModel.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import Foundation
import Combine

final class SubscriptionViewModel: ObservableObject {
    
    @Published private(set) var product: [SubscriptionProduct] = []
    
    private let paymentService: PaymentServiceType
    private let _fetchProducts = PassthroughSubject<Void, Never>()
    
    init(paymentService: PaymentServiceType) {
        
        self.paymentService = paymentService
    }
    
    func fetchProducts() {
        paymentService.fetchProducts().sink { products in
            self.product = products
        }
    }
    
    func purchase() {
    }
}
