//
//  AppToggleStyle.swift
//  mathpuzzle
//
//  Created by Juri Breslauer on 7/28/25.
//

import SwiftUI

extension View {
    func toggleStyle(theme: AppTheme) -> some View {
        self
//            .tint(AppColors.surface(for: theme)) // ножка переключателя
            .tint(theme == .dark ? .orange : .orange.opacity(0.9))
            .foregroundColor(AppColors.primaryText(for: theme)) // текст рядом
    }
}

//struct OrangeToggleStyle: ToggleStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        HStack {
//            configuration.label
//                .foregroundColor(.gray)
//            
//            Spacer()
//            
//            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(configuration.isOn ? Color.orange : Color(.systemGray5))
//                    .frame(width: 50, height: 30)
//                
//                Circle()
//                    .fill(Color.white)
//                    .frame(width: 24, height: 24)
//                    .padding(3)
//                    .shadow(radius: 1)
//            }
//            .onTapGesture {
//                withAnimation {
//                    configuration.isOn.toggle()
//                }
//            }
//        }
//    }
//}
