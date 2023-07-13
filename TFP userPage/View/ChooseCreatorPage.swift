//
//  ChooseCreatorPage.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 25/4/23.
//

import SwiftUI

struct ChooseCreatorPage: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedRole: CreatorRole?
    
    var body: some View {
        VStack {
            List(CreatorRole.allCases, id: \.self) { role in
                HStack {
                    Text(role.rawValue)
                    
                    if role == selectedRole {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    selectedRole = role
                    if let role = selectedRole {
                        UserDefaults.standard.set(role.rawValue, forKey: "selectedRole")
                    }
                }
            }
        }
        .navigationBarTitle("Creators")
    }
}

struct ChooseCreatorPage_Previews: PreviewProvider {
    @State static private var dummySelectedRole: CreatorRole? = nil
    
    static var previews: some View {
        ChooseCreatorPage(selectedRole: $dummySelectedRole)
    }
}
