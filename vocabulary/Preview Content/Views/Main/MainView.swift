//
//  MainView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI

struct MainView: View {
    var authenticationManager = AuthenticationManager()

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                Text("Vocabulary App")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink(destination: CreateQuizView()) {
                    Text("問題を作る")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Button(action: {
                    authenticationManager.signOut()
                    DispatchQueue.main.async {
                        UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .flatMap { $0.windows }
                            .first?.rootViewController = UIHostingController(rootView: ContentView())
                    }
                }) {
                    Text("ログアウト")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
