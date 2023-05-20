//
//  AuthViewModel.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 28/4/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AuthViewModel: ObservableObject {
  @Published var viewState: ViewState = .loginView
  @Published var user: User?
  @Published var isAuthenticated: Bool = false
  
  let auth = Auth.auth()
  let storage = Storage.storage()
  let firestore = Firestore.firestore()
  
  init() {
    checkAuthStatus()
    auth.addStateDidChangeListener { auth, user in
      self.user = user
      self.isAuthenticated = user != nil
      self.viewState = self.isAuthenticated ? .tabBarView : .loginView
    }
  }

  func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
    auth.signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        completion(.failure(error))
      } else if let result = result {
        completion(.success(result))
      }
    }
  }
  
  func signUp(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if let error = error {
        print("Error signing up: \(error.localizedDescription)")
        completion(false, error.localizedDescription)
        return
      }
      
      print("Successfully signed up")
      completion(true, "Signed up successfully")
    }
  }
  
  private func saveUserData(uid: String, data: [String: Any], completion: @escaping (Bool, String) -> Void) {
    self.firestore.collection("users")
      .document(uid).setData(data) { error in
        if let error = error {
          completion(false, "\(error)")
          return
        }
        completion(true, "Successfully created user: \(uid)")
      }
  }
  
  private func checkAuthStatus() {
    isAuthenticated = auth.currentUser != nil
    viewState = isAuthenticated ? .tabBarView : .loginView
  }

  func handleSignOut() {
    do {
      try Auth.auth().signOut()
      self.isAuthenticated = false
    } catch {
      print("Error signing out: \(error.localizedDescription)")
    }
  }
  
  enum ViewState {
    case loginView
    case tabBarView
  }
}

extension User: Identifiable {
  public var id: String { email ?? "" }
}
