//
//  AddQuizToMylistView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/04.
//

import SwiftUI
import FirebaseAuth

struct MyListDetailView: View {
    let mylist: MylistModel
    var uid: String = Auth.auth().currentUser?.uid ?? ""
    @State private var selectedQuizId: String = ""
    @State private var selectedUserEmail: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("「\(mylist.title)」の編集")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            GroupBox(label: Label("クイズを追加", systemImage: "plus.square.on.square")) {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("クイズIDを入力", text: $selectedQuizId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        // クイズ追加処理
                    }) {
                        Label("クイズをマイリストに追加", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .padding()
            }
            if mylist.createuser == uid{
                GroupBox(label: Label("共有ユーザーを追加", systemImage: "person.crop.circle.badge.plus")) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("共有したいユーザーのメールアドレス", text: $selectedUserEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            // 共有ユーザー追加処理
                        }) {
                            Label("ユーザーを共有に追加", systemImage: "person.badge.plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}
