//
//  SplashView.swift
//  mathpuzzle
//
//  Created by Juri Breslauer on 7/26/25.
//

import SwiftUI

struct PreMenuView: View {
    @ObservedObject var navState: NavigationState

    var body: some View {
        ZStack {
            // Затемнённый фон
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 24) {
               

                Button(action: {
                    navState.navigate(to: .mainMenu)
                }) {
                    Text("Start")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(16)
                }
            }
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.3), value: navState.currentScreen)
    }
}



#Preview {
    PreMenuView(navState: NavigationState())
}
