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
            VStack {
                ChartView(coin: coinDetailViewModel.coin)
                    .frame(height: 250)
                    
                Group {
                    overviewViews
                    additionalViews
                }
                .padding(.horizontal, 10)
            }
            .padding(.top, 50)
        }
        .navigationTitle(coinDetailViewModel.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            navigationTrailingItem
        }
        .onAppear {
            coinDetailViewModel.fetchCoinDetail()
        }
        .alert(isPresented: $coinDetailViewModel.isShowError, error: coinDetailViewModel.error) {}
    }
}

extension CoinDetailView {
    @ViewBuilder private var overviewViews: some View {
        if coinDetailViewModel.overviewStatistics.isEmpty {
            EmptyView()
        } else {
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
    }
    
    @ViewBuilder private var additionalViews: some View {
        if coinDetailViewModel.additionalStatistics.isEmpty {
            EmptyView()
        } else {
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
    
    private var navigationTrailingItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Text(coinDetailViewModel.coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundStyle(Color.theme.secondaryTextColor)
                
                CoinImageView(coin: coinDetailViewModel.coin)
                    .frame(width: 25, height: 25)
            }
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
