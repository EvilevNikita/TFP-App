//
//  FirebaseManager.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 28/4/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager: NSObject {
  let auth: Auth
  let storage: Storage
  let firestore: Firestore
  var currentUser: CurrentUser?
  static let shared = FirebaseManager()
  override init() {
    self.auth = Auth.auth()
    self.storage = Storage.storage()
    self.firestore = Firestore.firestore()
    super.init()
  }
}
