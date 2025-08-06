//
//  MyListDetailView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/04.
//

import SwiftUI
import FirebaseAuth

struct MyListDetailView: View {
    let mylist: MylistModel
    var uid = Auth.auth().currentUser?.uid ?? ""

    // ダミーデータ（後でFirestoreから取得に置き換え可）
    @State private var quizzes: [QuizModel] = [
        QuizModel(id: "q1", question: "富士山の高さは？", answer: "3776m", category: "地理", createuser: "u1", createuserdomain: "example.com"),
        QuizModel(id: "q2", question: "Swiftの開発元は？", answer: "Apple", category: "プログラミング", createuser: "u2", createuserdomain: "example.com")
    ]

    @State private var isPresentingAddQuizSheet = false
    @State private var isPresentingShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // タイトル
                Text("「\(mylist.title)」の詳細")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                // 追加ボタンエリア
                HStack(spacing: 16) {
                    Button(action: {
                        isPresentingAddQuizSheet = true
                    }) {
                        Label("クイズを追加", systemImage: "plus.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    if mylist.createuser == uid {
                        Button(action: {
                            isPresentingShareSheet = true
                        }) {
                            Label("共有を追加", systemImage: "person.crop.circle.badge.plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                }
                .padding(.vertical, 8)

                // クイズ一覧
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                        Text("クイズ一覧")
                            .font(.headline)
                        Spacer()
                    }

                    if quizzes.isEmpty {
                        Text("クイズがまだ追加されていません")
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(quizzes) { quiz in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(quiz.question)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text("カテゴリ: \(quiz.category)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }

                // 共有ユーザー一覧（作成者のみ表示）
                if mylist.createuser == uid {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "person.2")
                            Text("共有ユーザー")
                                .font(.headline)
                            Spacer()
                        }

                        if mylist.shereuser.isEmpty {
                            Text("共有ユーザーはいません")
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                        } else {
                            ForEach(mylist.shereuser, id: \.self) { user in
                                HStack {
                                    Image(systemName: "person.crop.circle")
                                    Text(user)
                                        .font(.body)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)

        // モーダル（UIだけでダミー）
        .sheet(isPresented: $isPresentingAddQuizSheet) {
            NavigationStack {
                AddQuizView()
                .navigationTitle("クイズを追加")
            }
        }
        .sheet(isPresented: $isPresentingShareSheet) {
            NavigationStack {
                AddShereUserView(mylistid: mylist.id)
                .navigationTitle("共有ユーザー追加")
            }
        }
    }
}
