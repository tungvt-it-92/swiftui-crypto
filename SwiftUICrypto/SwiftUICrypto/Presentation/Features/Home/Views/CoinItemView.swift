//
//  CoinRowView.swift
//  SwiftUICrypto
//

import SwiftUI
import WidgetKit

struct CoinItemView: View {
    let coin: CoinModel
    let showHoldingColumn: Bool
    let parentWidth: CGFloat?
    let onTapGestureAction: (() -> Void)?
    @EnvironmentObject private var homeVM: HomeViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(coin.marketCapRank != nil ? "#\(coin.marketCapRank!)" : "N/A")
                .bold()
                .foregroundStyle(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
                .padding(.horizontal, 5)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 5)
                .foregroundStyle(Color.theme.accentColor)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if showHoldingColumn {
                    Text("\(coin.currentHoldingValue.valueOrZero().asCurrency())")
                    Text(coin.currentHolding.valueOrZero().asNumberString())
                } else {
                    Text("\(coin.high24h.valueOrZero().asCurrency())")
                    Text("\(coin.low24h.valueOrZero().asCurrency())")
                }
            }
            .minimumScaleFactor(0.1)
            .foregroundStyle(Color.theme.accentColor)
            .font(.caption)
            
            VStack(alignment: .trailing) {
                Text("\(coin.currentPrice.valueOrZero().asCurrency())")
                    .bold()
                    .foregroundStyle(Color.theme.accentColor)
                
                Text("\(coin.priceChangePercentage24h.valueOrZero().asPercentageString())")
                    .foregroundStyle(
                        coin.priceChangePercentage24h.valueOrZero() > 0 ? Color.theme.greenColor : Color.theme.redColor
                    )
            }
            .minimumScaleFactor(0.1)
            .frame(width: (parentWidth ?? UIScreen.main.bounds.width) / 3, alignment: .trailing)
            
            FavoriteToggleButton(initialValue: coin.favorite ?? false) {
                homeVM.toggleFavorite(coin: coin)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTapGestureAction?()
        }
    }
}

#if DEBUG

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CoinItemView(coin: previewCoin, showHoldingColumn: false, parentWidth: nil) {}
        CoinItemView(coin: previewCoin, showHoldingColumn: true, parentWidth: nil) {}
    }
    .environmentObject(PreviewDataProvider.shared.previewHomeVM)
}

#endif
