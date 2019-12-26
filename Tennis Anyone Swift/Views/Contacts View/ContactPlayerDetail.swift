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
    private var playerFirstNameProxy:Binding<String> {
        Binding<String>(get: {self.player.firstName}, set: {
            self.player.firstName = $0
            self.player.name = self.player.firstName + " " +
                self.player.lastName
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
        })
    }

    private var playerLastNameProxy:Binding<String> {
        Binding<String>(get: {self.player.lastName}, set: {
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
            self.player.lastName = $0
            self.player.name = self.player.firstName + " " +
                self.player.lastName
})
    }
    private var playerEmailProxy:Binding<String> {
        Binding<String>(get: {self.player.email}, set: {
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
            self.player.email = $0
         })
    }
    private var playerPhoneProxy:Binding<String> {
         Binding<String>(get: {self.player.phone}, set: {
             self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
             self.player.phone = $0
         })
     }

    var body: some View {
        NavigationView {
                         Form {
                TextField("First Name", text: playerFirstNameProxy)
                TextField("Last Name", text: playerLastNameProxy)
                TextField("Phone #", text: playerPhoneProxy)
                TextField("Email", text: playerEmailProxy)

            }
        }
       .navigationBarTitle(Text(self.player.firstName))

    }
}

