//
//  SearchBarView.swift
//  SwiftUICrypto
//

import SwiftUI

struct SearchBarView: View {
    @Binding var inputText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            if isSearching {
                progressView
            } else {
                searchIcon
            }

            inputTextField
            
            if !inputText.isEmpty {
                clearButton
            }
        }
        .padding(.horizontal, 10)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accentColor.opacity(0.2),
                    radius: 10, x: 0, y: 0
                )
        }
    }
}

extension SearchBarView {
    var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundStyle(
                inputText.isEmpty
                ? Color.theme.secondaryTextColor
                : Color.theme.accentColor
            )
    }
    
    var progressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(Color.theme.accentColor)
    }
    
    var inputTextField: some View {
        TextField("Search by name or symbol...", text: $inputText)
            .autocorrectionDisabled()
            .foregroundStyle(Color.theme.accentColor)
            .padding(.vertical, 8)
    }
    
    var clearButton: some View {
        Button {
            inputText = ""
            UIApplication.shared.endEditing()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(Color.theme.accentColor)
                .frame(width: 25, height: 25)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        SearchBarView(inputText: .constant(""),  isSearching: .constant(true))
            .colorScheme(.dark)
    }
}
