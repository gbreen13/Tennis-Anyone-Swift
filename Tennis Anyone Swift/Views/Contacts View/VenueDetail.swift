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
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var venue: Venue

    @EnvironmentObject var schedule: Schedule
    
    var venueIndex: Int {
        schedule.venues.firstIndex(where: { $0.id == venue.id })!
    }

//    @State var name: String = self.venue.name
    var body: some View {

        NavigationView {
            
            Form {
                TextField("Venue name", text: $schedule.venues[venueIndex].name)
                TextField("Phone Number", text: $schedule.venues[venueIndex].phone)
                TextField("Email", text: $schedule.venues[venueIndex].email)
            }
        }
            /*
        .navigationBarItems(trailing:
            NavigationLink(destination: EmbeddedContactPicker()) {
                    Text("Contacts")
                }
        )*/        .navigationBarTitle(Text("Venues"))

    }
}
struct VenueDetail_Previews: PreviewProvider {
    @EnvironmentObject var schedule: Schedule
    static var previews: some View {
        VenueDetail(venue: Venue.example)
    }
}
