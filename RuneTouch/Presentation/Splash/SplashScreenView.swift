//
//  SplashView.swift
//  mathpuzzle
//
//  Created by Juri Breslauer on 7/26/25.
//

import SwiftUI


struct SplashScreenView: View {
    let onFinished: () -> Void

    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("RuneTouch")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)

                if isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            loadGameResources()
        }
    }

    private func loadGameResources() {
        // Имитация асинхронной загрузки, можно заменить на реальную
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
            onFinished()
        }
    }
}

#Preview("Splash Preview") {
    SplashPreviewWrapper()
    
}

private struct SplashPreviewWrapper: View {
    @State private var isFinished = false
    @State private var reloadToken = UUID()
    var body: some View {
        if isFinished {
            Text("🔥 Загрузка завершена")
                .font(.title)
                .padding()
            Button("🔄 Reload") {
                                isFinished = false
                                reloadToken = UUID() // обновит SplashScreenView
                            }
        } else {
            SplashScreenView {
                isFinished = true
            }.id(reloadToken)
        }
    }
}
