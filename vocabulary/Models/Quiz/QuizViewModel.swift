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

        let quiz = QuizModel(id: docRef.documentID,question:question,answer:answer,category:category,createuser:Auth.auth().currentUser!.uid, createuserdomain: String(Auth.auth().currentUser!.email!.split(separator:"@")[1]))

        docRef.setData([
            "id": quiz.id,
            "question": quiz.question,
            "answer": quiz.answer,
            "category": quiz.category,
            "createuser": quiz.createuser,
            "createuserdomain": quiz.createuserdomain
        ]) { error in
            completion(error)
        }
    }

//    func fetchAllQuizzesfilter(category:String) {
//        db.collection("Quiz")
//            .whereField("category",isEqualTo:category)
//            .limit(to:10)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching quizzes: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else { return }
//
//                let quizzes = documents.compactMap { doc -> QuizModel? in
//                    let data = doc.data()
//                    return QuizModel(
//                        id: doc.documentID,
//                        question: data["question"] as? String ?? "",
//                        answer: data["answer"] as? String ?? "",
//                        category: data["category"] as? String ?? "",
//                        createuser: data["createuser"] as? String ?? "",
//                        createuserdomain: data["createuserdomain"] as? String ?? ""
//                    )
//                }
//                DispatchQueue.main.async {
//                    self.quizmodel = quizzes
//                }
//            }
//    }
    func fetchAllQuizzes() {
        db.collection("Quiz")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching quizzes: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let quizzes = documents.compactMap { doc -> QuizModel? in
                    let data = doc.data()
                    return QuizModel(
                        id: doc.documentID,
                        question: data["question"] as? String ?? "",
                        answer: data["answer"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        createuser: data["createuser"] as? String ?? "",
                        createuserdomain: data["createuserdomain"] as? String ?? ""
                    )
                }

                DispatchQueue.main.async {
                    self.quizmodel = quizzes
                }
            }
    }
//    func fetchMyQuizzesfilter(category:String) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//
//        db.collection("Quiz")
//            .whereField("createuser", isEqualTo: userID)
//            .whereField("category",isEqualTo:category)
//            .limit(to:10)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching quizzes: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else { return }
//
//                let quizzes = documents.compactMap { doc -> QuizModel? in
//                    let data = doc.data()
//                    return QuizModel(
//                        id: doc.documentID,
//                        question: data["question"] as? String ?? "",
//                        answer: data["answer"] as? String ?? "",
//                        category: data["category"] as? String ?? "",
//                        createuser: data["createuser"] as? String ?? "",
//                        createuserdomain: data["createuserdomain"] as? String ?? ""
//                    )
//                }
//
//                DispatchQueue.main.async {
//                    self.quizmodel = quizzes
//                }
//            }
//    }
    func fetchMyQuizzes() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("Quiz")
            .whereField("createuser", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching quizzes: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let quizzes = documents.compactMap { doc -> QuizModel? in
                    let data = doc.data()
                    return QuizModel(
                        id: doc.documentID,
                        question: data["question"] as? String ?? "",
                        answer: data["answer"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        createuser: data["createuser"] as? String ?? "",
                        createuserdomain: data["createuserdomain"] as? String ?? ""
                    )
                }

                DispatchQueue.main.async {
                    self.quizmodel = quizzes
                }
            }
    }

    func deleteQuiz(quiz:QuizModel){
        let docRef = db.collection("Quiz").document(quiz.id)
        docRef.delete()
    }


    // プロフィール更新後に呼び出すメソッド
    func refreshQuiz() {
        fetchMyQuizzes()
    }
}
