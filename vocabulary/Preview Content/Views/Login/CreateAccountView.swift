//
//  CreateAccountView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct CreateAccountView: View {
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkpassword: String = ""
    @State var isShowSecure = false
    @FocusState var isTextFieldFocused: Bool
    @FocusState var isSecureFieldFocused: Bool
    @FocusState var ischeckTextFieldFocused: Bool
    @FocusState var ischeckSecureFieldFocused: Bool
    @State var ischeckShowSecure = false
    @State private var createalart: Bool = false
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene

    var body: some View {
        VStack(spacing: 20) {
            // App Logo or Title
            Text("アカウント作成")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Login Methods
            VStack(spacing: 15) {

                HStack{
                    TextField("\(Image(systemName: "envelope.fill"))email",text: $email)
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
                HStack{
                    ZStack{
                        TextField("\(Image(systemName: "key.fill"))password",text: $password)
                            .focused($isTextFieldFocused)
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                            .opacity(isShowSecure ? 1 : 0)
                        SecureField("\(Image(systemName: "key.fill"))password",text: $password)
                            .focused($isSecureFieldFocused)
                            .opacity(isShowSecure ? 0 : 1)
                    }
                    Button {
                      if isShowSecure {
                          isShowSecure = false
                          isSecureFieldFocused = true
                      } else {
                          isShowSecure = true
                          isTextFieldFocused = true
                      }

                    } label: {
                        Image(systemName: isShowSecure ? "eye" : "eye.slash")
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 0.1)
                )
                HStack{
                    ZStack{
                        TextField("\(Image(systemName: "key.fill"))確認用:password",text: $checkpassword)
                            .focused($ischeckTextFieldFocused)
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                            .opacity(ischeckShowSecure ? 1 : 0)
                        SecureField("\(Image(systemName: "key.fill"))確認用:password",text: $checkpassword)
                            .focused($ischeckSecureFieldFocused)
                            .opacity(ischeckShowSecure ? 0 : 1)
                    }
                    Button {
                      if ischeckShowSecure {
                          ischeckShowSecure = false
                          ischeckSecureFieldFocused = true
                      } else {
                          ischeckShowSecure = true
                          ischeckTextFieldFocused = true
                      }

                    } label: {
                        Image(systemName: ischeckShowSecure ? "eye" : "eye.slash")
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 0.1)
                )
                Text("パスワードと確認用パスワードが違います")
                    .bold()
                    .foregroundColor(.red)
                    .opacity(createalart ? 1 : 0)

                Button(action: {
                    createalart = false
                    if !email.isEmpty && !password.isEmpty && password == checkpassword{
                        AuthenticationManager().signup(email: email, password: password)
                        if let window = windowScene?.windows.first {
                            window.rootViewController = UIHostingController(rootView: ContentView())
                        }
                    }
                    else{
                        createalart = true
                    }
                }) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Emailで作成")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Button(action: {
                    if let window = windowScene?.windows.first {
                        window.rootViewController = UIHostingController(rootView: LoginView())
                    }
                }) {
                    HStack {
                        Text("すでにアカウントを持っている方はこちら")
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()



            // Loading and Error Handling
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .background(Color(.systemBackground))
    }

    private func loginWithGoogle() {
        isLoading = true
        errorMessage = nil

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Google Sign-In configuration error"
            isLoading = false
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { signInResult, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let user = signInResult?.user,
                      let idToken = user.idToken?.tokenString else {
                    self.errorMessage = "Authentication failed"
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        // Handle successful sign-in (e.g., navigate to main app)
                    }
                }
            }
        }
    }

    private func presentEmailSignIn() {
        // Implement email sign-in logic
        // You might want to present a sheet or navigate to an email login view
    }

    // Utility function to get the root view controller
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
