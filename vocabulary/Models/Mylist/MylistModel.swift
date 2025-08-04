//
//  MylistModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/02.
//

import FirebaseFirestore

struct MylistModel: Identifiable{
    var id: String
    var title: String
    var createuser: String
}

struct MylistLinkModel: Identifiable{
    var id: String
    var quizid: String
    var mylistid: String
}
