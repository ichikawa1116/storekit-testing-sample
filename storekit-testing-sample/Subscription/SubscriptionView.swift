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
                
                Button(action: {
                    
                }) {
                    Text("購入")
                        
                        .padding(.all, 5.0)
                        .foregroundColor(.green)
                        .background(Color.red)
                }
            }.padding()
            
        }
        .onWillAppear {
            viewModel.fetchProducts()
        }
    }
    
}
