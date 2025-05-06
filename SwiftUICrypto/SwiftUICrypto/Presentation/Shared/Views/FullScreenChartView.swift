//
//  ChartFullscreenView.swift
//  SwiftUICrypto
//

import SwiftUI

struct FullScreenChartView: View {
    @Binding var isPresented: Bool
    var coin: CoinModel
    var disableDismissAnimations: Bool
    
    init(
        isPresented: Binding<Bool>,
        coin: CoinModel,
        disableDismissAnimations: Bool = true
    ) {
        self._isPresented = isPresented
        self.coin = coin
        self.disableDismissAnimations = disableDismissAnimations
    }
    
    var body: some View {
        VStack {
            ChartView(coin: coin)
                .padding(.top, 35)
                .overlay(alignment: .topTrailing) {
                    dismissButton
                }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
    }
}

extension FullScreenChartView {
    var dismissButton: some View {
        Button(action: {
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = disableDismissAnimations
            withTransaction(transaction) {
                isPresented.toggle()
            }
        }) {
            Image(systemName: "arrow.up.right.and.arrow.down.left.rectangle")
                .font(.title3)
                .padding()
                .foregroundStyle(Color.theme.secondaryTextColor)
        }
    }
}

#Preview {
    FullScreenChartView(isPresented: .constant(true), coin: previewCoin)
        .frame(height: 200)
}
