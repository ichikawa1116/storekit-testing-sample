//
//  SubscriptionViewModel.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import Foundation
import Combine

protocol SubscriptionViewModelType: ObservableObject {
    func fetchItems()
    func purchase()
}


final class SubscriptionViewModel: SubscriptionViewModelType {
    
    func fetchItems() {
    }
    
    func purchase() {
    }
}
