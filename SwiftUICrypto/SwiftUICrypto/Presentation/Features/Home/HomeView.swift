//
//  HomeView.swift
//  SwiftUICrypto
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
    @EnvironmentObject private var homeVM: HomeViewModel
    
    var body: some View {
        
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                if let marketData = homeVM.marketData {
                    MarketDataView(marketData: marketData)
                }
                
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
            Task {
                await homeVM.fetchCoins()
            }
            Task {
                await homeVM.fetchMarketData()
            }
        }
        .alert(isPresented: $homeVM.isShowError, error: homeVM.error) {}
    }
}


extension HomeView {
    private var headerView: some View {
        HStack {
            CircleButton(iconName: showPortfolio ? "plus" : "info") {}
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
            CoinItemView(coin: coin, showHoldingColumn: false)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listRowSpacing(5)
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    private var portfolioCoinList: some View {
        List(homeVM.filteredCoins, id: \.id) { coin in
            CoinItemView(coin: coin, showHoldingColumn: true)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listRowSpacing(5)
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
    
    private var tableHeaderView: some View {
        HStack(spacing: 0) {
            Text("Coin")
            Spacer()
            Text(showPortfolio ? "Holdings" : "Max/Min 24h")
            Text("Price")
                .frame(
                    width: UIScreen.main.bounds.width / 3,
                    alignment: .trailing
                )
            Spacer()
                .frame(width: 30)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.accentColor)
        .padding(0)
    }
    
    private var searchView: some View {
        SearchBarView(inputText: $homeVM.inputSearchText)
            .padding(.vertical, 15)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .environmentObject(HomeViewModel())
        }
    }
}
#endif
