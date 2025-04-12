//
//  CoinRowView.swift
//  SwiftUICrypto
//

import SwiftUI

struct CoinItemView: View {
    let coin: CoinModel
    let showHoldingColumn: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("#\(coin.marketCapRank)")
                .bold()
                .foregroundStyle(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            
            Circle()
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 10)
                .foregroundStyle(Color.theme.accentColor)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if showHoldingColumn {
                    Text("\((coin.currentHoldingValue ?? 0).asCurrency())")
                    Text("\(coin.currentHolding ?? 0)")
                } else {
                    Text("\(coin.high24h.asCurrency())")
                    Text("\(coin.low24h.asCurrency())")
                }
            }
            .minimumScaleFactor(0.1)
            .foregroundStyle(Color.theme.accentColor)
            .font(.caption)
            
            VStack(alignment: .trailing) {
                Text("\(coin.currentPrice.asCurrency())")
                    .bold()
                    .foregroundStyle(Color.theme.accentColor)
                
                Text("\(coin.priceChangePercentage24h.asPercentageString())")
                    .foregroundStyle(
                        coin.priceChangePercentage24h > 0 ? Color.theme.greenColor : Color.theme.redColor
                    )
            }
            .minimumScaleFactor(0.1)
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
            
            Image(systemName: coin.favorite ? "star.fill" : "star")
                .foregroundStyle(Color.theme.accentColor)
                .frame(width: 30, height: 30)
        }
    }
}

#if DEBUG

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CoinItemView(coin: previewCoin, showHoldingColumn: false)
        CoinItemView(coin: previewCoin, showHoldingColumn: true)
    }    
}

#endif
