//
//  VenueDetail.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/17/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI
import Contacts
import SwiftUI
import os

struct VenueDetail: View {
    var venue: Venue

    @EnvironmentObject var schedule: Schedule
    
    private var venueNameProxy:Binding<String> {
        Binding<String>(get: {self.venue.name}, set: {
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
            self.venue.name = $0
        })
    }
    private var venuePhoneProxy:Binding<String> {
        Binding<String>(get: {self.venue.phone}, set: {
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
            self.venue.phone = $0
        })
    }
    private var venueEmailProxy:Binding<String> {
        Binding<String>(get: {self.venue.email}, set: {
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen
            self.venue.email = $0
        })
    }

    var body: some View {

        NavigationView {
            
            Form {
                TextField("Name of courts", text: venueNameProxy)
                TextField("Phone number", text: venuePhoneProxy)
                TextField("Email", text: venueEmailProxy)
            }
        }
        .navigationBarTitle(Text("Courts"))

    }
}
struct VenueDetail_Previews: PreviewProvider {
    @EnvironmentObject var schedule: Schedule
    static var previews: some View {
        VenueDetail(venue: Venue.example)
    }
}
