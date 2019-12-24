//
//  ContactPlayerDetail.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 12/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct ContactPlayerDetail: View {
    var player: Player
  
    @EnvironmentObject var schedule: Schedule
    
    var playerIndex: Int {
        schedule.players.firstIndex(where: { $0.id == player.id })!
    }

    private var playerFirstNameProxy:Binding<String> {
        Binding<String>(get: {self.player.firstName}, set: {
            self.player.firstName = $0
            self.player.name = self.player.firstName + " " +
                self.player.lastName
        })
    }

    private var playerLastNameProxy:Binding<String> {
        Binding<String>(get: {self.player.lastName}, set: {
            self.player.lastName = $0
            self.player.name = self.player.firstName + " " +
                self.player.lastName
})
    }
    private var playerEmailProxy:Binding<String> {
        Binding<String>(get: {self.player.email}, set: {
            self.player.email = $0
            self.schedule.objectWillChange.send()
            self.player.objectWillChange.send()


         })
    }
    private var playerPhoneProxy:Binding<String> {
         Binding<String>(get: {self.player.phone}, set: {
             self.player.phone = $0
         })
     }

    var body: some View {
        NavigationView {
                         Form {
                TextField("First Name", text: playerFirstNameProxy)
                TextField("Last Name", text: playerLastNameProxy)
                TextField("Phone #", text: $schedule.players[playerIndex].phone)
                TextField("Email", text: playerEmailProxy)

            }
        }
       .navigationBarTitle(Text(self.player.firstName))

    }
}

