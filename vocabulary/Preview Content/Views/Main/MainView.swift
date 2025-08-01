//
//  MainView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseAuth
import Combine

struct MainView: View {
    var authenticationManager = AuthenticationManager()
    @ObservedObject private var ckeckmail = checkmaildomain()

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                Text("クイズアプリ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                NavigationLink(destination: QuizListMainView()) {
                    Text("1問ずつ問題を探す・解く")
                        .font(.headline)
                        .frame(maxWidth: .infinity,maxHeight: 75)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                NavigationLink(destination: NotfoundView()) {
                    Text("連続で問題を解く")
                        .font(.headline)
                        .frame(maxWidth: .infinity,maxHeight: 50)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                if ckeckmail.check(mail:Auth.auth().currentUser?.email!){
                    NavigationLink(destination: AcademicQuizListView()){
                        Text("大学生モード")
                            .font(.headline)
                            .frame(maxWidth: .infinity,maxHeight: 30)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                HStack{
                    NavigationLink(destination: CreateQuizView()) {
                        Text("問題を作る")
                            .font(.headline)
                            .frame(maxWidth: .infinity,maxHeight: 30)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    NavigationLink(destination: NotfoundView()) {
                        Text("マイリストを編集")
                            .font(.headline)
                            .frame(maxWidth: .infinity,maxHeight: 30)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                HStack{
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
                            .frame(maxWidth: .infinity,maxHeight: 30)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                Spacer()
            }
        }.onAppear()
    }
}

#Preview {
    MainView()
}
