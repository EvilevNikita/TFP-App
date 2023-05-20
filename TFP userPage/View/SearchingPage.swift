//
//  SearchingPage.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 24/4/23.
//

import SwiftUI

struct SearchingPage: View {

  @State private var selectedCityIndex = 0

  @State private var searchQuery = ""

  @State private var selectedCity: String? = UserDefaults.standard.string(forKey: "selectedCity")
  @State private var filteredParticipants: [TFPParticipant] = tfpParticipants

  @State private var selectedRole: CreatorRole? = nil

  var body: some View {
    VStack {
      NavigationView {
        GeometryReader { geo in
          ScrollView {
            ForEach(filteredParticipants, id: \.username) { participant in
              VStack {
                HStack {
                  if let username = participant.username {
                    Text(username)
                      .font(.title2)
                  } else {
                    Text("Unknown")
                      .font(.title2)
                  }
                  Spacer()
                  if let city = participant.city {
                    Text(city)
                      .opacity(0.5)
                  } else {
                    Text("Unknown")
                      .opacity(0.5)
                  }
                }
                HStack {
                  if let role = participant.role {
                    Text(role.rawValue)
                      .opacity(0.5)
                  } else {
                    Text("Unknown")
                      .opacity(0.5)
                  }
                  Spacer()
                }
                Text("Random description of a creative person, random description of a creative person, random description of a creative person")

                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 3) {
                    ForEach(portfolio, id: \.self) { index in
                      Text("Portfolio \(index)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(randomColor())
                        .padding(.bottom)
                    }
                  }
                }

                Rectangle()
                  .frame(height: 1)
                  .foregroundColor(Color(.label).opacity(0.2))
              }.padding(.horizontal)
            }
          }
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {

            NavigationLink(destination: ChooseCityPage(selectedCity: $selectedCity)) {
              HStack {
                Text("\(selectedCity ?? "Choose city")")
                Image(systemName: "mappin.and.ellipse")
              }.foregroundColor(Color(.label))
            }
          }
          ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: ChooseCreatorPage(selectedRole: $selectedRole)) {
              HStack {
                Image(systemName: "camera")
                Text("\(selectedRole?.rawValue ?? "Choose creator")")
              }.foregroundColor(Color(.label))
            }
          }
        }
      }
    }
    .onChange(of: selectedCity) { newValue in
      updateFilteredParticipants()
    }
    .onChange(of: selectedRole) { newValue in
      updateFilteredParticipants()
    }
  }

  private func updateFilteredParticipants() {
    var filtered = tfpParticipants

    if let selectedCity = selectedCity {
      filtered = filtered.filter { $0.city == selectedCity }
    }

    if let selectedRole = selectedRole {
      filtered = filtered.filter { $0.role == selectedRole }
    }

    filteredParticipants = filtered
  }
}

struct SearchingPage_Previews: PreviewProvider {
  static var previews: some View {
    SearchingPage()
  }
}
