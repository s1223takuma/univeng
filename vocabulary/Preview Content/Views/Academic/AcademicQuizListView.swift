//
//  AnswerQuizView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/02.
//

import SwiftUI

struct AcademicQuizListView: View {
    @ObservedObject private var viewModel = checkmaildomain()
    @ObservedObject private var categoryviewModel = CategoryViewModel()

    var body: some View {
            VStack {
                Text("みんなの作ったクイズ一覧")
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
                                NavigationLink(destination: SolveQuizView(quiz: quiz)) {
                                    QuizCardView(quiz:quiz)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                if categoryviewModel.selectword == ""{
                    viewModel.fetchAllQuizzes()
                }else{
                    viewModel.fetchAllQuizzesfilter(category: categoryviewModel.selectword)
                }
                categoryviewModel.fetchCategoryNames()
            }
            .onChange(of:categoryviewModel.selectword){
                if categoryviewModel.selectword == ""{
                    viewModel.fetchAllQuizzes()
                }else{
                    viewModel.fetchAllQuizzesfilter(category: categoryviewModel.selectword)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview{
    AcademicQuizListView()
}
