//
//  SwiftUICryptoWidget.swift
//  SwiftUICryptoWidget
//

import WidgetKit
import SwiftUI

struct SwiftUICryptoWidgetEntryView : View {
    var entry: CoinWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        HStack {
            Text("Last update: \(entry.date.timeString)")
                .font(.headline)
            Button(intent: RefreshCoinMarketIntent()) {
                Image(systemName: "goforward")
            }
            .buttonStyle(.plain)
        }
        
        VStack {
            ForEach(entry.coins, id: \.self) { coin in
                CoinWidgetView(coin: coin, coinImage: entry.coinImageById[coin.id])
            }
        }
    }
}

struct CoinWidgetView: View {
    let coin: CoinModel
    let coinImage: UIImage?
    
    var body: some View {
        HStack {
            Text(coin.marketCapRank != nil ? "#\(coin.marketCapRank!)" : "N/A")
                .foregroundStyle(Color.theme.secondaryTextColor)
                .bold()
                .frame(minWidth: 30)
            
            Image(uiImage: (coinImage ?? UIImage(named: "ic_logo")!))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.horizontal, 5)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 5)
                .foregroundStyle(Color.theme.accentColor)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(coin.currentPrice.valueOrZero().asCurrency())")
                    .foregroundStyle(Color.theme.accentColor)
                
                Text("\(coin.priceChangePercentage24h.valueOrZero().asPercentageString())")
                    .foregroundStyle(
                        coin.priceChangePercentage24h.valueOrZero() > 0 ? Color.theme.greenColor : Color.theme.redColor
                    )
            }
            .minimumScaleFactor(0.1)
        }
    }
}

struct SwiftUICryptoWidget: Widget {
    let kind: String = "SwiftUICryptoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CoinMarketProvider()) { entry in
            if #available(iOS 17.0, *) {
                SwiftUICryptoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SwiftUICryptoWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("YouCrypto")
        .description("This is YouCrypto's widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SwiftUICryptoWidget()
} timeline: {
    CoinWidgetEntry(date: Date(), coins: [previewCoin, previewCoin], coinImageById: [:])
}
