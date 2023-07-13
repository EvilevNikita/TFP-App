//
//  CurrentUser.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 29/4/23.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CurrentUserViewModel: Identifiable, ObservableObject {
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
    
    var firebaseService: FirebaseService
    
    init(data: [String: Any], firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? "ива"
        self.bio = data["bio"] as? String ?? ""
        self.city = data["city"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.portfolio = (data["portfolio"] as? [Portfolio]) ?? []
        self.creatorRole = data["creatorRole"] as? CreatorRole
    }
    
    init(firebaseService: FirebaseService = FirebaseService()) {
        self.firebaseService = firebaseService
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
    
    func saveUserToFirestore(completion: @escaping (Error?) -> Void) {
        firebaseService.saveUserToFirestore(user: self, completion: completion)
    }
    
    func loadUserData(settings: SettingsViewModel, completion: @escaping (Bool, Error?) -> Void) {
        firebaseService.loadUserData(user: self, settings: settings, completion: completion)
    }
    
    func persistImageToStorage() {
        firebaseService.persistImageToStorage(user: self)
    }
    
    func updateProfileImageURLInFirestore(completion: @escaping (Error?) -> Void) {
        firebaseService.updateProfileImageURLInFirestore(user: self, completion: completion)
    }
    
    func userDidChooseNewProfileImage(_ newImage: UIImage) {
        firebaseService.userDidChooseNewProfileImage(user: self, newImage)
    }
    
    func deleteProfileImageFromStorage(completion: @escaping (Error?) -> Void) {
        firebaseService.deleteProfileImageFromStorage(user: self, completion: completion)
    }
    
    func storeUserInformation(imageProfileURL: URL) {
        firebaseService.storeUserInformation(user: self, imageProfileURL: imageProfileURL)
    }
}
