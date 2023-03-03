//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable identifier_name
// swiftlint:disable type_contents_order

import Account
import Firebase
import FirebaseAuth
import Foundation

public class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    let user = Auth.auth().currentUser
    @Published public var disease: String = ""
    var refresh = false

    public func update() {
       refresh.toggle()
    }
    
    public func fetchData() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument {document, err in
                if let err = err {
                    print("Error loading document: \(err)")
                    return
                }
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        self.disease = data["disease"] as? String ?? ""
                    }
                }
            }
       }
    }
    
    public init() {
        fetchData()
    }
}
