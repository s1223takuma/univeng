//
//  AnswerQuizView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/13.
//

import SwiftUI

struct MyQuizListView: View {
    @ObservedObject private var viewModel = QuizViewModel()
    @ObservedObject private var categoryviewModel = CategoryViewModel()

    var body: some View {
            VStack {
                Text("自分の作ったクイズ一覧")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                if categoryviewModel.categoryNames.isEmpty {
                    ProgressView("カテゴリーを読み込み中…")
                } else {
                    HStack{
                        Picker(categoryviewModel.selectword != "" ? "\(categoryviewModel.selectword)を選択中" : "カテゴリーを選択", selection: $categoryviewModel.selectword) {
                            ForEach(categoryviewModel.categoryNames, id: \.self) { name in
                                Text(name != "" ? "\(name)で絞り込む":"絞り込み無し")
                            }
                        }
                    }
                }


                if viewModel.quizmodel.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("まだクイズがありません")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    Spacer()
                } else {
                    VStack{
                        List {
                            ForEach(viewModel.quizmodel) { quiz in
                                if quiz.category == categoryviewModel.selectword{
                                    NavigationLink(destination: SolveQuizView(quiz: quiz)) {
                                        QuizCardView(quiz:quiz)
                                    }
                                    .padding(.vertical, 4)
                                }
                                else if categoryviewModel.selectword == ""{
                                    NavigationLink(destination: SolveQuizView(quiz: quiz)) {
                                        QuizCardView(quiz:quiz)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                    viewModel.fetchMyQuizzes()

                categoryviewModel.fetchCategoryNames()
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview{
    MyQuizListView()
}
