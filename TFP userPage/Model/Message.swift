//
//  Message.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 28/4/23.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable {
  var id = UUID()
  let senderId: String
  var isCurrentUser: Bool
  let text: String
  var content: String
  let timestamp: Timestamp
  
}
