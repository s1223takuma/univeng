//
//  MylistViewModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/03.
//


import FirebaseFirestore
import FirebaseAuth

class MylistViewModel: ObservableObject {
    var authenticationManager = AuthenticationManager()
    private var db = Firestore.firestore()
    @Published private(set) var mylistmodel: [MylistModel] = []

    func saveMylist(title: String,completion: @escaping (Error?) -> Void){
        let docRef = db.collection("Mylist").document()

        let mylist = MylistModel(id: docRef.documentID,title:title,createuser:Auth.auth().currentUser?.uid ?? "",shereuser: [], quizlist: [])

        docRef.setData([
            "id": mylist.id,
            "title": mylist.title,
            "createuser": mylist.createuser,
            "shereuser": mylist.shereuser
        ]) { error in
            completion(error)
        }
    }

    func fetchMyLists() {
        let shereUserFilter = Filter.whereField("shereuser", arrayContains: Auth.auth().currentUser?.email ?? "")
        let createUserFilter = Filter.whereField("createuser", isEqualTo: Auth.auth().currentUser?.uid ?? "")
        db.collection("Mylist")
            .whereFilter(Filter.orFilter([shereUserFilter, createUserFilter]))
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    DispatchQueue.main.async {
                        self.mylistmodel = documents.compactMap { doc in
                            let data = doc.data()
                            return MylistModel(
                                id: doc.documentID,
                                title: data["title"] as? String ?? "",
                                createuser: data["createuser"] as? String ?? "",
                                shereuser: data["shereuser"] as? [String] ?? [],
                                quizlist: data["quizlist"] as? [String] ?? []
                            )
                        }
                    }
                }
            }
    }

    

    func addShereuser(usermail: String, mylistid: String){
        let docRef = db.collection("Mylist").document(mylistid)
        docRef.updateData(["shereuser": FieldValue.arrayUnion([usermail])])
    }

    func deletemylist(mylistid: String){
        let docRef = db.collection("Mylist").document(mylistid)
        docRef.delete()
    }

    func removeShereuser(usermail: String,mylistid:String){
        let docRef = db.collection("Mylist").document(mylistid)
        docRef.updateData(["shereuser": FieldValue.arrayRemove([usermail])])
    }
}
