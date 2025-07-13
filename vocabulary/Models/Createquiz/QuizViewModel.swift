//
//  QuizViewModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/10.
//

import FirebaseFirestore
import FirebaseAuth

class QuizViewModel: ObservableObject {
    var authenticationManager = AuthenticationManager()
    private var db = Firestore.firestore()
    @Published private(set) var quizmodel: [QuizModel] = []

    func saveQuiz(question: String,answer: String,category: String,completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("Quiz").document()

        let quiz = QuizModel(id: docRef.documentID,question:question,answer:answer,category:category,createuser:Auth.auth().currentUser!.uid)

        docRef.setData([
            "id": quiz.id,
            "question": quiz.question,
            "answer": quiz.answer,
            "category": quiz.category,
            "createuser": quiz.createuser
        ]) { error in
            completion(error)
        }
    }
    // 通常のフェッチ（一回のみ）
    func fetchQuiz() {
        if quizmodel.isEmpty {
            guard let userEmail = Auth.auth().currentUser?.uid else { return }

            db.collection("Quiz").document(userEmail).addSnapshotListener { snapshot, error in
                if let error {
                    print("Error getting document: \(error)")
                } else if let data = snapshot?.data() {
                    _ = QuizModel(
                        id: snapshot?.documentID ?? "",
                        question: data["question"] as? String ?? "",
                        answer: data["answer"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        createuser: data["createuser"] as? String ?? ""
                    )
                }
            }
        }
    }

    // プロフィール更新後に呼び出すメソッド
    func refreshQuiz() {
        fetchQuiz()
    }
}
