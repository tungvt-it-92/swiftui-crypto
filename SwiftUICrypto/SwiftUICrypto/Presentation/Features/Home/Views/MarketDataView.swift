//
//  MarketDataView.swift
//  SwiftUICrypto
//
import SwiftUI

struct MarketDataView: View {
    let marketData: MarketData
    
    var body: some View {
        HStack(alignment: .top) {
            marketCapColumn
            
            Spacer()
            
            volume24hColumn
            
            Spacer()
            
            btcDominanceColumn
            
            
        }
    }
}

extension MarketDataView {
    var marketCapColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Market Cap")
                .foregroundStyle(Color.theme.secondaryTextColor)
                .font(.caption)
            
            Text("\(marketData.totalMarketCapInUsd.formattedWithAbbreviations())")
                .foregroundStyle(Color.theme.accentColor)
                .bold()
            
            HStack {
                Image(systemName: "triangle.fill")
                    .rotationEffect(
                        marketData.marketCapChangePercentage24hUsd.valueOrZero() < 0 ?
                        Angle(degrees: 180) : Angle(degrees: 0)
                    )
                Text(marketData.marketCapChangePercentage24hUsd.valueOrZero().asPercentageString())
            } .foregroundStyle(
                marketData.marketCapChangePercentage24hUsd.valueOrZero() < 0 ?
                Color.red : Color.green
            )
            
        }
    }
    
    var volume24hColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("24h Volume")
                .foregroundStyle(Color.theme.secondaryTextColor)
                .font(.caption)
            
            Text("\(marketData.totalVolumeInUsd.formattedWithAbbreviations())")
                .foregroundStyle(Color.theme.accentColor)
                .bold()
        }
    }
    
    var btcDominanceColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("BTC Dominance")
                .foregroundStyle(Color.theme.secondaryTextColor)
                .font(.caption)
            
            Text("\(marketData.btcDominance)")
                .foregroundStyle(Color.theme.accentColor)
                .bold()
        }
    }
}

#if DEBUG

#Preview(traits: .sizeThatFitsLayout) {
    MarketDataView(marketData: previewMarketData)
}

#endif
