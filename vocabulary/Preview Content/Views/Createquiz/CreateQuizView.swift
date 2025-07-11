//
//  SwiftUIView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/10.
//

import SwiftUI

struct CreateQuizView: View {
    @State var answer:String = ""
    @State var question:String = ""
    @Environment(\.dismiss) private var dismiss
    @State var words:[String] = ["","Dart", "Swift", "Kotlin", "Go", "Python", "React"]
    @State var selectword:String = ""
    var body: some View {
        NavigationView{
            VStack{
                Text("問題作成")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                VStack{
                    Text("問題文を入力してください")
                        .font(.headline)
                    TextEditor(text: $question)
                        .border(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                        .padding()
                    Text("カテゴリーを選択")
                        .font(.headline)
                    Picker("カテゴリーを選択",selection: $selectword){
                        ForEach(words, id: \.self){word in
                            Text("\(word)")
                        }
                    }
                    .pickerStyle(.menu)
                    Text(selectword != "" ? "\(selectword)を選択中":"未選択")
                }.padding()
                Button(action:{
                    dismiss()
                }){
                    Text("答えの入力へ")
                }
            }
        }
    }
}

#Preview {
    CreateQuizView()
}

