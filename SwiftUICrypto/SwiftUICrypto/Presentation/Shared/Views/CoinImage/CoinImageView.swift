//
//  CoinImageView.swift
//  SwiftUICrypto
//

import SwiftUI

struct CoinImageView: View {
    @StateObject private var coinImageVM: CoinImageViewModel
    
    init(coin: CoinModel) {
        _coinImageVM = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        Group {
            if coinImageVM.isFetchingImage {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: 32, height: 32)
            } else {
                Group {
                    if let dowloadedImage = coinImageVM.image {
                        Image(uiImage: dowloadedImage)
                            .resizable()
                    } else {
                        Image(systemName: "questionmark")
                            .resizable()
                    }
                }
                .scaledToFit()
            }
        }
    }
}

#if DEBUG

#Preview(traits: .sizeThatFitsLayout) {
    CoinImageView(coin: previewCoin)
    CoinImageView(coin: previewCoin)
}

#endif
