//
//  Portfolio.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI
import FirebaseFirestore

var portfolio = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]


struct Portfolio: Identifiable {
  var id: ObjectIdentifier
  let isPortfolio: Bool
  let timestamp: Timestamp
}


func randomColor() -> Color {
  let red = Double.random(in: 0...1)
  let green = Double.random(in: 0...1)
  let blue = Double.random(in: 0...1)
  return Color(red: red, green: green, blue: blue)
}

struct PhotoIndex: Identifiable {
  let id: Int
}
