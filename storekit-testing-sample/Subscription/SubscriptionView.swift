//
//  ContentView.swift
//  storekit-testing-sample
//
//  Created by Manami Ichikawa on 2020/12/13.
//

import SwiftUI

struct SubscriptionView: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    
    var body: some View {
        ZStack() {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text(viewModel.price)
                ForEach(viewModel.products, id: \.id) { product in
                    // TODO: ボタンデザイン
                    Button("(\(product.price)) 購入") {
                        viewModel.purchase(productId: product.id)
                    }
                }
//                Button( action: { viewModel.purchase(productId: <#SubscriptionProduct.Id#>) }) {
//                    Text("購入")
//                        .padding(.all, 5.0)
//                        .foregroundColor(.green)
//                        .background(Color.red)
//                }
            }.padding()
            
        }
        .onWillAppear {
            viewModel.fetchProducts()
        }
    }
    
}
