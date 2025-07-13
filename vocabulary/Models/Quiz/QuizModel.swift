//
//  QuizModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/10.
//

import FirebaseFirestore

struct QuizModel: Identifiable{
    var id: String
    var question: String
    var answer: String
    var category: String
    var createuser: String
}
