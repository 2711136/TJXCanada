//
//  WelcomeView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-26.
//
import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var animateLogo = false
    @State private var showContent = false

    var body: some View {
        ZStack {
            // 🌌 Dégradé futuriste
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer()

                // ✨ Logo animé
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.6), radius: 10)
                    .scaleEffect(animateLogo ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateLogo)

                if showContent {
                    Text("Bienvenue sur")
                        .font(.title2)
                        .foregroundColor(.white)
                        .transition(.move(edge: .top).combined(with: .opacity))

                    Text("TJXCanada")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale)

                    Text("Gérez vos absences, retards, congés\nfacilement avec style.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal)
                        .transition(.opacity)
                }

                Spacer()

                if showContent {
                    Button(action: {
                        withAnimation {
                            showLogin = true
                        }
                    }) {
                        Text("Commencer")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.white)
                            .cornerRadius(18)
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            animateLogo = true
            withAnimation(.easeOut(duration: 1.2)) {
                showContent = true
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
}
