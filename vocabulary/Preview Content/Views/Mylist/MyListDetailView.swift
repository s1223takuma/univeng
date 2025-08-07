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
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = MylistViewModel()

    @State private var quizzes: [QuizModel] = [
        QuizModel(id: "q1", question: "富士山の高さは？", answer: "3776m", category: "地理", createuser: "u1", createuserdomain: "example.com"),
        QuizModel(id: "q2", question: "Swiftの開発元は？", answer: "Apple", category: "プログラミング", createuser: "u2", createuserdomain: "example.com")
    ]

    @State private var isPresentingAddQuizSheet = false
    @State private var isPresentingShareSheet = false
    @State private var isdeletealert: Bool = false
    

    var body: some View {
        List {
            // タイトル + 削除ボタン + 追加ボタン（1つのカード内に統合）
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(mylist.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        if mylist.createuser == uid {
                            Button {
                                isdeletealert.toggle()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                            .alert("\(mylist.title)を削除しますか",isPresented: $isdeletealert){
                                Button("戻る",role:.cancel){}
                                Button("削除する",role:.destructive){
                                    viewModel.deletemylist(mylistid: mylist.id)
                                    dismiss()
                                }
                            }
                        }
                    }
                    // 追加ボタンをタイトル直下に
                    HStack(spacing: 5) {
                        Button(action: { isPresentingAddQuizSheet = true }) {
                            Text("クイズを追加")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)

                        if mylist.createuser == uid {
                            Button(action: { isPresentingShareSheet = true }) {
                                Text("共有追加")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .listRowBackground(Color.clear)
            }

            // クイズ一覧
            Section(header: Label("クイズ一覧", systemImage: "list.bullet.rectangle")) {
                if quizzes.isEmpty {
                    Text("クイズがまだ追加されていません")
                        .foregroundColor(.gray)
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
                        .cornerRadius(10)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // クイズ削除処理
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            // 共有ユーザー
            if mylist.createuser == uid {
                Section(header: Label("共有ユーザー", systemImage: "person.2")) {
                    if mylist.shereuser.isEmpty {
                        Text("共有ユーザーはいません")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(mylist.shereuser, id: \.self) { user in
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(.blue)
                                Text(user)
                                    .font(.body)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.removeShereuser(usermail: user, mylistid: mylist.id)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
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
