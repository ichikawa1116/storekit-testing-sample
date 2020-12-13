//
//  SKProduct+Extension.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/14.
//

import Foundation
import StoreKit

extension SKProduct {

    func localizedPrice() -> String {
        let currencySymbol = priceLocale.currencySymbol ?? ""
        let price = currencySymbol + String(describing: self.price)
        return price
    }
}
