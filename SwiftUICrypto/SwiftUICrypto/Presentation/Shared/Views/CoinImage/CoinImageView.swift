//
//  CoinImageView.swift
//  SwiftUICrypto
//

import SwiftUI

struct CoinImageView: View {
    var coin: CoinModel
    
    @StateObject private var coinImageVM = CoinImageViewModel()
    
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
            }
        }
        .onAppear {
            Task {
                if let imageUrl = coin.image {
                    await coinImageVM.fetchImage(imageUrl: imageUrl)
                }
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
