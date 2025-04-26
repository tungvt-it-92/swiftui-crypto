//
//  CoinDetailView.swift
//  SwiftUICrypto
//

import SwiftUI

struct CoinDetailView: View {
    var coin: CoinModel
    @StateObject private var coinDetailViewModel: CoinDetailViewModel
    @State private var readMoreDescription: Bool = true
    
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
                    linksView
                }
                .padding(.horizontal, 10)
            }
            .padding(.top, 50)
        }
        .toolbar {
            navigationTrailingItem
        }
        .navigationTitle(coinDetailViewModel.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .animation(.easeInOut(duration: 0.3), value: readMoreDescription)
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
                
                descriptionView
                
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
    
    @ViewBuilder private var descriptionView: some View {
        if let coinDescription = coinDetailViewModel.coinDescription,
           !coinDescription.isEmpty {
            VStack(alignment: .leading) {
                Text(coinDescription)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryTextColor)
                    .lineLimit(readMoreDescription ? 3 : nil)
                Button {
                    readMoreDescription.toggle()
                } label: {
                    Text(readMoreDescription ? "Read more..." : "Read less")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            EmptyView()
        }
    }
    
    private var linksView: some View {
        VStack(alignment: .leading) {
            if let homepageUrlString = coinDetailViewModel.homepageUrl,
               let homepageUrl = URL(string: homepageUrlString) {
                SwiftUI.Link("Webstite", destination: homepageUrl)
            }
            
            if let redditUrlString = coinDetailViewModel.redditUrl,
               let redditUrl = URL(string: redditUrlString) {
                SwiftUI.Link("Reddit", destination: redditUrl)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.subheadline)
    }
}


#if DEBUG

#Preview {
    NavigationStack {
        CoinDetailView(coin: previewCoin)
    }
}

#endif
