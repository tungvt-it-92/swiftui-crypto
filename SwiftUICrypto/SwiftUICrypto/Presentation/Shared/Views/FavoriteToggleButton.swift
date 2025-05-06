//
//  FavoriteToggleButton.swift
//  SwiftUICrypto
//

import SwiftUI
import WidgetKit

struct FavoriteToggleButton: View {
    var action: (() -> Void)?
    @State private var isFavorite: Bool
    
    init(initialValue: Bool, action: (() -> Void)? = nil) {
        self.isFavorite = initialValue
        self.action = action
    }
    
    var body: some View {
        Button {
            isFavorite.toggle()
            WidgetCenter.shared.reloadAllTimelines()
            HapticFeedback.notify(type: .success)
            UIApplication.shared.endEditing()
            action?()
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundStyle(Color.theme.accentColor)
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.3), value: isFavorite)
    }
}

#Preview {
    FavoriteToggleButton(initialValue: true)
    FavoriteToggleButton(initialValue: false)
}
