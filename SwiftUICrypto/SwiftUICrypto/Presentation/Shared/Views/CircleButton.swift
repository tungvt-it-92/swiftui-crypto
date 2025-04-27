//
//  CircleButtonView.swift
//  SwiftUICrypto
//

import SwiftUI

struct CircleButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accentColor)
            .frame(width: 50, height: 50)
            .background {                   
                Circle()
                    .foregroundStyle(Color.theme.background)
            }
            .contentShape(Circle())
            .onTapGesture {
                action()
            }
            .shadow(
                color: Color.theme.accentColor.opacity(0.3),
                radius: 5
            )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CircleButton(iconName: "heart.fill") {}
            
        CircleButton(iconName: "heart.fill") {}
            .colorScheme(.dark)
        
        CircleButton(iconName: "person.crop.artframe") {}
            
        CircleButton(iconName: "person.crop.artframe") {}
            .colorScheme(.dark)
    }
    
    
}
