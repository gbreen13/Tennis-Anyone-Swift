//
//  VenueList.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/17/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI
struct VenueRow : View {
    var venue: Venue
    
    @EnvironmentObject var schedule: Schedule

    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(venue.name)
                    .multilineTextAlignment(.leading)
                Text(venue.phone)
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Tahoma", size: 10))
                    .foregroundColor(.gray)

            }
            
        }
    }
}


struct VenueList : View {
    @EnvironmentObject var schedule: Schedule
    @State private var showDeleteActionSheet = false

    var body: some View {
        List {
            ForEach(schedule.venues, id: \.id) { venue in
                NavigationLink(destination: VenueDetail(venue: venue)) {
                    VenueRow(venue: venue)
                }
            }.onDelete(perform: delete)
        }
        
    }
    
      func delete(at offsets: IndexSet) {
        schedule.venues.remove(atOffsets: offsets)
    }
}

struct VenueList_Previews: PreviewProvider {
    @EnvironmentObject var schedule: Schedule
    static var previews: some View {

        List {
            VenueRow(venue: Venue.example)
        }
    }
}

