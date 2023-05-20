//
//  NewPublications.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI

struct NewPublications: View {
  var body: some View {
    VStack {
      HStack {
        Text("New publications")
          .font(.title2)
        Spacer()
      }
      
      GeometryReader { geo in
        ScrollView {
          ForEach(0..<10) {
            Text("Publication \($0)")
              .foregroundColor(.white)
              .font(.largeTitle)
              .frame(width: geo.size.width, height: geo.size.width)
              .background(.gray)
          }
        }
      }
    }
  }
}

struct NewPublications_Previews: PreviewProvider {
  static var previews: some View {
    NewPublications()
  }
}
