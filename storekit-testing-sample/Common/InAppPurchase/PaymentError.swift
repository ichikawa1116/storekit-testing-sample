//
//  PaymentError.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/14.
//

import Foundation

enum PaymentError: String, Error {
    case notFound
    case failedPurchase
    case failedRestore
    case unknown

    var description: String {
        return "PaymentError(\(self.rawValue))"
    }
}
