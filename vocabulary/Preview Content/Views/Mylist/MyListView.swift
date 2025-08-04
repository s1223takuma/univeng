//
//  MyListView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/04.
//

import SwiftUI
import FirebaseAuth

struct MyListView: View {
    @StateObject private var viewModel = MylistViewModel()
    @State private var currentUserId = Auth.auth().currentUser?.uid ?? ""

    var body: some View {
            VStack {
                Text("マイリスト一覧")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                NavigationLink(destination: CreateMylistView()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("マイリストを作る")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)


                if viewModel.mylistmodel.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("まだマイリストがありません")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.mylistmodel) { list in
                            NavigationLink(destination: MyListDetailView(mylist: list)) {
                                VStack(alignment: .leading) {
                                    Text(list.title)
                                        .font(.headline)
                                    if list.createuser == currentUserId {
                                        Text("自分が作成")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    } else {
                                        Text("共有リスト")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                viewModel.fetchMyLists()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
}
