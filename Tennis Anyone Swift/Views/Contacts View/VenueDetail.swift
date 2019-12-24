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
    
    var venueIndex: Int {
        schedule.venues.firstIndex(where: { $0.id == venue.id })!
    }

    var body: some View {

        NavigationView {
            
            Form {
                TextField("Venue name", text: $schedule.venues[venueIndex].name)
                TextField("Phone Number", text: $schedule.venues[venueIndex].phone)
                TextField("Email", text: $schedule.venues[venueIndex].email)
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
