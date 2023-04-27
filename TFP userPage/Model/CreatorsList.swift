//
//  CreatorsList.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 25/4/23.
//

import Foundation

enum CreatorRole: String, CaseIterable {
    case photographer = "Photographer"
    case model = "Model"
    case makeupArtist = "Makeup Artist"
    case hairStylist = "Hair Stylist"
    case wardrobeStylist = "Wardrobe Stylist"
    case retoucher = "Retoucher"
}

struct TFPParticipant {
    let role: CreatorRole?
    let username: String?
    let bio: String?
//    let portfolio: [Int]?
//    let references: [Int]?
    var city: String?
}

func generateTFPParticipants(count: Int) -> [TFPParticipant] {
    var participants: [TFPParticipant] = []
    
    let firstNames = ["John", "Jane", "Emily", "Michael", "Sophia", "David", "Alice", "Bob", "Charlie", "Diana", "Eva", "Fred"]
    let lastNames = ["Doe", "Smith", "Brown", "Johnson", "Williams", "Martinez", "Adams", "Baker", "Clark", "Davis", "Evans", "Franklin"]

    var usedNames = Set<String>()

    for _ in 0..<count {
        let randomRole = CreatorRole.allCases.randomElement()!
        var randomName: String
        repeat {
            let randomFirstName = firstNames.randomElement()!
            let randomLastName = lastNames.randomElement()!
            randomName = "\(randomFirstName) \(randomLastName)"
        } while usedNames.contains(randomName)
        
        usedNames.insert(randomName)
        let randomCity = cities.randomElement()!
        
        participants.append(TFPParticipant(role: randomRole, username: randomName, bio: "", city: randomCity))
    }
    
    return participants
}

let tfpParticipants = generateTFPParticipants(count: 130)

