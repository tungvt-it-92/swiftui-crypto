//
//  Untitled.swift
//  SwiftUICrypto
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var filteredCoins: [CoinModel] = []
    @Published var inputSearchText: String = ""
    
    @Published var error: APIError?
    @Published var isShowError: Bool = false
    
    private var allCoins: [CoinModel] = []
    private var coinGeckoApi = CoinGeckoApi()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscription()
    }
    
    func fetchCoins() async {
        coinGeckoApi
            .fetchCoins()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    MyLogger.debugLog("FINISHED")
                case .failure(let error):
                    MyLogger.debugLog("ERROR \(error.localizedDescription)")
                    self?.error = error
                    self?.isShowError = true
                }
            } receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.filteredCoins = coins
            }
            .store(in: &cancellables)
    }
    
    private func addSubscription() {
        $inputSearchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
            self?.filteredCoins = self?.allCoins.filter {
                value.isEmpty
                || $0.symbol.lowercased().contains(value.lowercased())
                || $0.name.lowercased().contains(value.lowercased())
                || $0.id.lowercased().contains(value.lowercased())
            } ?? []
        }
        .store(in: &cancellables)
    }
}
