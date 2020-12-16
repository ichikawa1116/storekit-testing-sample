//
//  SubscriptionProduct.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/14.
//

import Foundation
import StoreKit

struct SubscriptionProduct {
    let id: Id
    let price: String
    
    struct Id: Hashable {
        let id: String
    }
}

extension SubscriptionProduct {
    
    init(product: SKProduct) {
        print(product.productIdentifier)
        id = Id(id: product.productIdentifier)
        price = product.localizedPrice()
    }
}
