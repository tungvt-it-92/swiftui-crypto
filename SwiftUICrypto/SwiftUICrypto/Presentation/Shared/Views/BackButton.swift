//
//  BackButton.swift
//  SwiftUICrypto
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }

    }
}

#Preview {
    BackButton()
}
