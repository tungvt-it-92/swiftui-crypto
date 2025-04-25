//
//  HomeView.swift
//  SwiftUICrypto
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
    @State private var showEditPortfolio: Bool = false
    @State private var presentedDetailCoin: CoinModel?
    @EnvironmentObject private var homeVM: HomeViewModel
    
    var body: some View {
        
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                StatisticView(
                    statisticModels: homeVM.statistics,
                    showPortfolioColumn: showPortfolio
                )
                
                searchView
                
                tableHeaderView
                
                if !showPortfolio {
                    allCoinList
                }
                
                if showPortfolio {
                    portfolioCoinList
                }
                
                Spacer(minLength: 0)
            }
            .animation(.easeInOut(duration: 0.3), value: showPortfolio)
            .padding(.horizontal)
        }
        .onAppear {
            homeVM.fetchCoins()
            homeVM.fetchMarketData()
        }
        .sheet(isPresented: $showEditPortfolio) {
            EditPortfolioView()
        }
        .navigationDestination(item: $presentedDetailCoin, destination: { coin in
            return CoinDetailView(coin: coin)
        })
        .alert(isPresented: $homeVM.isShowError, error: homeVM.error) {}
    }
}


extension HomeView {
    private var headerView: some View {
        HStack {
            CircleButton(iconName: showPortfolio ? "plus" : "info") {
                if showPortfolio {
                    showEditPortfolio.toggle()
                }
            }
            .background {
                AnimatedCircleView(isAnimating: showPortfolio)
            }
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accentColor)
            
            Spacer()
            
            CircleButton(iconName: "chevron.right") {
                showPortfolio.toggle()
            }
            .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        }
    }
    
    private var allCoinList: some View {
        List(homeVM.filteredCoins, id: \.id) { coin in
            CoinItemView(coin: coin, showHoldingColumn: false) {
                presentedDetailCoin = coin
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listRowSpacing(5)
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    private var portfolioCoinList: some View {
        List(homeVM.portfolioCoins, id: \.id) { coin in
            CoinItemView(coin: coin, showHoldingColumn: true) {
                presentedDetailCoin = coin
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listRowSpacing(5)
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
    
    private var tableHeaderView: some View {
        HStack(spacing: 0) {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        [.rank, .rankReversed].contains(homeVM.sortOption) ? 1 : 0
                    )
                    .rotationEffect(Angle(degrees: homeVM.sortOption == .rank ? 0: 180))
            }
            .onTapGesture {
                homeVM.sortOption = homeVM.sortOption == .rank ? .rankReversed : .rank
            }
            
            Spacer()
            
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            [.holdings, .holdingsReversed].contains(homeVM.sortOption) ? 1 : 0
                        )
                        .rotationEffect(Angle(degrees: homeVM.sortOption == .holdings ? 0: 180))
                }
                .onTapGesture {
                    homeVM.sortOption = homeVM.sortOption == .holdings ? .holdingsReversed : .holdings
                }
            } else {
                HStack {
                    Text("Max/Min 24h")
                    Image(systemName: "chevron.down")
                        .opacity(
                            [.change24h, .change24hReversed].contains(homeVM.sortOption) ? 1 : 0
                        )
                        .rotationEffect(Angle(degrees: homeVM.sortOption == .change24h ? 0: 180))
                }
                .onTapGesture {
                    homeVM.sortOption = homeVM.sortOption == .change24h ? .change24hReversed : .change24h
                }
            }
            
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(
                        [.price, .priceReversed].contains(homeVM.sortOption) ? 1 : 0
                    )
                    .rotationEffect(Angle(degrees: homeVM.sortOption == .price ? 0: 180))
            }
            .onTapGesture {
                homeVM.sortOption = homeVM.sortOption == .price ? .priceReversed : .price
            }
            .frame(
                width: UIScreen.main.bounds.width / 3,
                alignment: .trailing
            )
            
            Button {
                homeVM.refresh()
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: homeVM.isLoading ?  360 : 0), anchor: .center)
            .padding(.leading, 5)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.accentColor)
        .padding(0)
        .animation(.linear(duration: 2.0), value: homeVM.isLoading)
    }
    
    private var searchView: some View {
        SearchBarView(inputText: $homeVM.inputSearchText)
            .padding(.vertical, 15)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        NavigationStack {
            HomeView()
                .navigationBarHidden(true)
                .environmentObject(PreviewDataProvider.shared.previewHomeVM)
        }
    }
}
#endif
