//
//  PassResetView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore


struct PassResetView: View {
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var documentExists = false
    @State private var isChecking = false
    @State private var isShowSecure = false
    @State private var isalert:Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isSecureFieldFocused: Bool
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene


    var body: some View {
        VStack(spacing: 20) {
            // App Logo or Title
            Text("パスワードリセット")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Login Methods
            VStack(spacing: 30) {

                HStack{
                    TextField("email",text: $email)
                        .focused($isTextFieldFocused)
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 0.1)
                )

                Button(action: {
                    AuthenticationManager().passreset(email: email)
                    isalert.toggle()
                }) {
                    HStack {
                        Text("パスワードリセットのメールを送信")
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .alert("メールが送信されました",isPresented: $isalert) {
                        Button("ログイン画面に戻る",role: .destructive){
                            if let window = windowScene?.windows.first {
                                window.rootViewController = UIHostingController(rootView: LoginView())
                            }
                        }
                    }
                Button(action: {
                    if let window = windowScene?.windows.first {
                        window.rootViewController = UIHostingController(rootView: LoginView())
                    }
                }) {
                    HStack {
                        Text("ログインページに戻る")
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
}
