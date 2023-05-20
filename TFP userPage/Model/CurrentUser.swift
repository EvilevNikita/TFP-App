//
//  CurrentUser.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 29/4/23.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CurrentUser: Identifiable, ObservableObject {
  var id: String { uid }
  var uid: String { email }
  @Published var username: String
  @Published var email: String
  @Published var creatorRole: CreatorRole?
  @Published var bio: String
  @Published var city: String
  @Published var image: UIImage?
  @Published var profileImageURL: String? = nil
  @Published var portfolio: [Portfolio]

  init(data: [String: Any]) {
    self.email = data["email"] as? String ?? ""
    self.username = data["username"] as? String ?? ""
    self.bio = data["bio"] as? String ?? ""
    self.city = data["city"] as? String ?? ""
    self.profileImageURL = data["profileImageURL"] as? String ?? ""
    self.portfolio = (data["portfolio"] as? [Portfolio]) ?? []
    self.creatorRole = data["creatorRole"] as? CreatorRole
  }

  init() {
    self.email = ""
    self.username = ""
    self.bio = ""
    self.city = ""
    self.profileImageURL = ""
    self.portfolio = []
    self.creatorRole = .none
  }

  func updateProfile(username: String, creatorRole: CreatorRole, bio: String, city: String/*, portfolio: [Portfolio]*/) {
    self.username = username
    self.creatorRole = creatorRole
    self.bio = bio
    self.city = city
  }

  func saveUserToFirestore(user: CurrentUser, completion: @escaping (Error?) -> Void) {
    let db = Firestore.firestore()
    let usersRef = db.collection("users")

    guard !user.uid.isEmpty else {
      completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User UID is empty"]))
      return
    }

    let userData: [String: Any] = [
      "uid": user.uid,
      "email": user.email,
      "username": user.username,
      "bio": user.bio,
      "city": user.city,
      "profileImageURL": user.profileImageURL,
      "creatorRole": user.creatorRole?.rawValue as Any ]
    usersRef.document(user.uid).setData(userData) { error in
      completion(error)
    }
    print("Save to firebase: username - \(String(describing: userData["username"])), bio - \(String(describing: userData["bio"])), city - \(String(describing: userData["city"])), creator role - \(String(describing: userData["creatorRole"]))")
  }

  func loadUserData(settings: SettingsViewModel, completion: @escaping (Bool, Error?) -> Void) {
    guard let uid = Auth.auth().currentUser?.id else {
      completion(false, nil)
      return
    }
    let db = Firestore.firestore()
    let usersRef = db.collection("users")

    usersRef.document(uid).getDocument { (document, error) in
      if let error = error {
        print("User data failed to load: \(error)")
        completion(false, error)
      } else if let document = document, document.exists, let data = document.data() {
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.bio = data["bio"] as? String ?? ""
        self.city = data["city"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.portfolio = (data["portfolio"] as? [Portfolio]) ?? []
        if let creatorRoleString = data["creatorRole"] as? String {
          self.creatorRole = CreatorRole(rawValue: creatorRoleString)
        }
        print("Загрузка данных с firebase. createor role - \(String(describing: self.creatorRole))")
        print("Updating CurrentUser profile")
        completion(true, nil)
      } else {
        completion(false, nil)
      }
    }
  }

//  func saveToUserDefaults() {
//    UserDefaults.standard.set(username, forKey: Keys.usernameKey.rawValue)
//    UserDefaults.standard.set(bio, forKey: Keys.bioKey.rawValue)
//    UserDefaults.standard.set(creatorRole?.rawValue, forKey: Keys.creatorRoleKey.rawValue)
//    UserDefaults.standard.set(city, forKey: Keys.city.rawValue)
//    print("Saved UD: username: \(username), city: \(String(describing: city)), bio: \(bio), creatorRole: \(String(describing: creatorRole?.rawValue))")
//  }

  func persistImageToStorage() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard let image = self.image else {
      print("Error: image is nil.")
      return
    }

    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
      print("Error: unable to convert image to Data.")
      return
    }

    let ref = Storage.storage().reference(withPath: "profile_images/\(uid)")
    ref.putData(imageData, metadata: nil) { metadata, error in
      if let error = error {
        print("Failed to upload image: \(error)")
        return
      }

      ref.downloadURL { url, error in
        if let error = error {
          print("Failed to retrieve downloadURL: \(error)")
          return
        }

        guard let url = url else { return }
        self.profileImageURL = url.absoluteString
        self.storeUserInformation(imageProfileURL: url)
      }
    }
  }


  func userDidChooseNewProfileImage(_ newImage: UIImage) {
    self.image = newImage
    self.persistImageToStorage()
  }

  func deleteProfileImageFromStorage(completion: @escaping (Error?) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else {
      completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User UID is empty"]))
      return
    }

    let storage = Storage.storage()
    let storageRef = storage.reference()
    let profileImageRef = storageRef.child("profile_images/\(uid)")

    profileImageRef.delete { error in
      if let error = error {
        print("Failed to delete image: \(error)")
      } else {
        print("Image deleted successfully")
        self.profileImageURL = nil
        self.updateProfileImageURLInFirestore(uid: uid, completion: completion)
      }
    }
  }

  private func updateProfileImageURLInFirestore(uid: String, completion: @escaping (Error?) -> Void) {
    let db = Firestore.firestore()
    let usersRef = db.collection("users")
    usersRef.document(uid).updateData(["profileImageURL" : FieldValue.delete()]) { error in
      if let error = error {
        print("Failed to update profile image URL: \(error)")
        completion(error)
      } else {
        print("Profile image URL updated successfully")
        completion(nil)
      }
    }
  }

  private func storeUserInformation(imageProfileURL: URL) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let userData = ["email" : self.email, "uid" : uid, "profileImageURL" : imageProfileURL.absoluteString]
    Firestore.firestore().collection("users")
      .document(uid).setData(userData) { error in
        if let error = error {
          print(error)
          return
        }

        print("Success")
      }
  }
}
