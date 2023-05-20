//
//  Messenger.swift
//  TFP userPage
//
//  Created by Nikita Ivlev on 28/4/23.
//

import SwiftUI

struct MainMessagesView: View {
    @State private var messageText: String = ""
    @State private var messages: [Message] = []

    var body: some View {
        VStack {
            // Список сообщений
            List(messages) { message in
                MessageRow(message: message)
            }
            
            // Поле для отправки сообщений
            HStack {
                TextField("Type your message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 8)

                Button(action: sendMessage) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.trailing, 8)
            }
            .padding(.bottom)
        }
        .navigationTitle("TFP Messenger")
    }
    
    private func sendMessage() {
        // Здесь реализуйте отправку сообщений через Firebase
        print("Sending message: \(messageText)")
        messageText = ""
    }
}

struct MessageRow: View {
    var message: Message

    var body: some View {
        HStack {
            if message.isCurrentUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}

struct Message: Identifiable {
    var id = UUID()
    var content: String
    var isCurrentUser: Bool
}
