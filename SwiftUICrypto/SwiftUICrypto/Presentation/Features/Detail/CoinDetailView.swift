//
//  CoinDetailView.swift
//  SwiftUICrypto
//

import SwiftUI

struct CoinDetailView: View {
    var coin: CoinModel
    @StateObject private var coinDetailViewModel: CoinDetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    init(coin: CoinModel) {
        self.coin = coin
        _coinDetailViewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            overviewViews
            
            additionalViews
        }
        .navigationTitle(coinDetailViewModel.coin.name)
        .onAppear {
            coinDetailViewModel.fetchCoinDetail()
        }
    }
}

extension CoinDetailView {
    private var overviewViews: some View {
        Group {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundStyle(Color.theme.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: 30,
                content: {
                    ForEach(coinDetailViewModel.overviewStatistics, id: \.self) { statisticsModel in
                        StatisticColumn(statisticsModel: statisticsModel)
                    }
                }
            )
        }
    }
    
    private var additionalViews: some View {
        Group {
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundStyle(Color.theme.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: 30,
                content: {
                    ForEach(coinDetailViewModel.additionalStatistics, id: \.self) { statisticsModel in
                        StatisticColumn(statisticsModel: statisticsModel)
                    }
                }
            )
        }
    }
}


#if DEBUG

#Preview {
    NavigationStack {
        CoinDetailView(coin: previewCoin)
    }
    
}

#endif
