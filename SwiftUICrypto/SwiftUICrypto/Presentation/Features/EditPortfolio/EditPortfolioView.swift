//
//  EditPortfolio.swift
//  SwiftUICrypto
//

import SwiftUI

struct EditPortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: CoinModel?
    @State private var quantity: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SearchBarView(inputText: $viewModel.inputSearchText)
                    
                    coinList
                    
                    portfolioInputView
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("Edit portfolio")
            .toolbar {
                navigationItems
            }
            .animation(.spring, value: showCheckMark)
        }
       
    }
}

fileprivate struct CoinView: View {
    let coinModel: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(coin: coinModel)
                .frame(width: 32, height: 32)
            
            Text("\(coinModel.symbol)")
                .font(.headline)
                .foregroundStyle(Color.theme.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text("\(coinModel.name)")
                .foregroundStyle(Color.theme.secondaryTextColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
    }
}

extension EditPortfolioView {
    private var navigationItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.theme.greenColor)
                        .opacity(showCheckMark ? 1.0 : 0.0)
                    
                    Button {
                        saveButtonTapped()
                    } label: {
                        Text("Save".uppercased())
                    }
                    .opacity((selectedCoin != nil && Double(quantity) != nil) ? 1.0 : 0.0)

                }
                .font(.headline)
            }
        }
    }
    
    private var coinList: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 10) {
                ForEach(
                    viewModel.inputSearchText.isEmpty
                    ? viewModel.portfolioCoins
                    : viewModel.filteredCoins,
                    id: \.id
                ) { coin in
                    CoinView(coinModel: coin)
                        .frame(width: 75)
                        .padding(5)
                        .onTapGesture {
                            updateSelectedCoin(coin: coin)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    coin.id == selectedCoin?.id
                                    ? Color.theme.greenColor
                                    : Color.clear
                                )
                        }
                }
            }
        }
    }
    
    private var portfolioInputView: some View {
        Group {
            if let selectedCoin = selectedCoin {
                VStack(spacing: 20) {
                    HStack {
                        Text("Current price of \(selectedCoin.symbol.uppercased()):")
                        Spacer()
                        Text(selectedCoin.currentPrice.valueOrZero().asCurrency())
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Amount in your portfolio: ")
                        Spacer()
                        TextField("Ex: 100", text: $quantity)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Current value:")
                        Spacer()
                        Text(getCurrentValue().asCurrency())
                    }
                }
            }
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantityNumber = Double(quantity) {
            return quantityNumber * (selectedCoin?.currentPrice ?? 0)
        }
           
        return 0
    }
    
    private func saveButtonTapped() {
        guard
            let selectedCoin = selectedCoin,
            let amount = Double(quantity)
        else { return }
        
        viewModel.updatePortfolio(coin: selectedCoin, amount: amount)
        self.selectedCoin = nil
        quantity = ""
        viewModel.inputSearchText = ""
        UIApplication.shared.endEditing()
        
        showCheckMark = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCheckMark = false
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        quantity = ""
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id ==  coin.id}),
           let currentAmount = portfolioCoin.currentHolding
        {
            quantity = String(currentAmount)
        }
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    EditPortfolioView()
        .environmentObject(PreviewDataProvider.shared.previewHomeVM)
}
#endif
