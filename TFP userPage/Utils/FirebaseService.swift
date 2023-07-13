//
//  FirebaseService.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 8/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirebaseService {
    func getUserCollection() -> CollectionReference {
        let db = Firestore.firestore()
        return db.collection("users")
    }
    
    func saveUserToFirestore(user: CurrentUserViewModel, completion: @escaping (Error?) -> Void) {
        let usersRef = getUserCollection()
        
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
    
    func loadUserData(user: CurrentUserViewModel, settings: SettingsViewModel, completion: @escaping (Bool, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }
        let usersRef = getUserCollection()
        
        usersRef.document(uid).getDocument { (document, error) in
            if let error = error {
                print("User data failed to load: \(error)")
                completion(false, error)
            } else if let document = document, document.exists, let data = document.data() {
                user.email = data["email"] as? String ?? ""
                user.username = data["username"] as? String ?? ""
                user.bio = data["bio"] as? String ?? ""
                user.city = data["city"] as? String ?? ""
                user.profileImageURL = data["profileImageURL"] as? String ?? ""
                user.portfolio = (data["portfolio"] as? [Portfolio]) ?? []
                if let creatorRoleString = data["creatorRole"] as? String {
                    user.creatorRole = CreatorRole(rawValue: creatorRoleString)
                }
                print("Загрузка данных с firebase. name - \(String(describing: user.username))")
                print("Загрузка данных с firebase. createor role - \(String(describing: user.creatorRole))")
                print("Updating CurrentUser profile")
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func persistImageToStorage(user: CurrentUserViewModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = user.image else {
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
                user.profileImageURL = url.absoluteString
                self.storeUserInformation(user: user, imageProfileURL: url)
            }
        }
    }
    
    
    func userDidChooseNewProfileImage(user: CurrentUserViewModel, _ newImage: UIImage) {
        user.image = newImage
        persistImageToStorage(user: user)
    }
    
    func updateProfileImageURLInFirestore(user: CurrentUserViewModel, completion: @escaping (Error?) -> Void) {
        let usersRef = getUserCollection()
        
        usersRef.document(user.uid).updateData(["profileImageURL" : FieldValue.delete()]) { error in
            if let error = error {
                print("Failed to update profile image URL: \(error)")
                completion(error)
            } else {
                print("Profile image URL updated successfully")
                completion(nil)
            }
        }
    }
    
    func deleteProfileImageFromStorage(user: CurrentUserViewModel, completion: @escaping (Error?) -> Void) {
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
                user.profileImageURL = nil
                self.updateProfileImageURLInFirestore(user: user, completion: completion)
            }
        }
    }
    
    func storeUserInformation(user: CurrentUserViewModel, imageProfileURL: URL) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["email" : user.email, "uid" : uid, "profileImageURL" : imageProfileURL.absoluteString]
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
