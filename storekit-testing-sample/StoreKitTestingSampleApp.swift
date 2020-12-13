//
//  storekit_testing_sampleApp.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import SwiftUI

@main
struct StoreKitTestingSampleApp: App {
    var body: some Scene {
        WindowGroup {
            SubscriptionView(viewModel: SubscriptionViewModel(paymentService: PaymentService()))
        }
    }
}
