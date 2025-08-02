//
//  Login.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore


struct LoginView: View {
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var documentExists = false
    @State private var isChecking = false
    @State private var isShowSecure = false
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isSecureFieldFocused: Bool
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene


    var body: some View {
        VStack(spacing: 20) {
            // App Logo or Title
            Text("ログイン")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Login Methods
            VStack(spacing: 15) {
                VStack{
                    // Google Sign-In Button
                    Button(action: {
                        loginWithGoogle()
                    }) {
                        Text("googleアカウントでログイン")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding()

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

                Button(action: {
                    AuthenticationManager().signin(email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        checkDocumentExists(documentID: user.uid)
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
                }) {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Emailでログイン")
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
                        window.rootViewController = UIHostingController(rootView: CreateAccountView())
                    }
                }) {
                    HStack {
                        Text("アカウント作成はこちら")
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Button(action: {
                    if let window = windowScene?.windows.first {
                        window.rootViewController = UIHostingController(rootView: PassResetView())
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("パスワードを忘れてしまった方はこちら→")
                            .padding()
                    }
                }
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

extension LoginView {
    func loginWithGoogle() {
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
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        } else if let user = authResult?.user {
                            self.checkDocumentExists(documentID: user.uid)
                        }
                    }
                }
            }
        }
    }

    func checkDocumentExists(documentID: String) {
        isChecking = true
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(documentID)

        docRef.getDocument { document, error in
            DispatchQueue.main.async {
                self.isChecking = false

                if let document = document, document.exists {
                    self.documentExists = true
                    if let window = self.windowScene?.windows.first {
                        window.rootViewController = UIHostingController(rootView: ContentView())
                    }
                } else {
                    let newUser = [
                        "uid": documentID,
                        "email": Auth.auth().currentUser?.email ?? "",
                        "createdAt": FieldValue.serverTimestamp(),
                        "totalpoint": 0
                    ]
                    docRef.setData(newUser) { error in
                        if let error = error {
                            print("ユーザーデータの保存に失敗: \(error.localizedDescription)")
                        } else {
                            print("新しいユーザーデータを保存しました")
                        }
                        if let window = self.windowScene?.windows.first {
                            window.rootViewController = UIHostingController(rootView: ContentView())
                        }
                    }
                }
            }
        }
    }
}
