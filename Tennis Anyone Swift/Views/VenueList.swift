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
    /*
    var venueIndex: Int {
        schedule.venues.firstIndex(where: { $0.id == venue.id })!
    }
 */
    var body: some View {
        
        HStack {
//            Image(item.thumbnailImage)   .clipShape(Circle())

 
            VStack(alignment: .leading) {
                Text(venue.name)
                    .multilineTextAlignment(.leading)
                Text(venue.phone)
                    .multilineTextAlignment(.leading)
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
 /*
        VStack {
            Button(action: {
                print("Add")
            }, label: {
                Text("Add")
            })
   */         List {
                ForEach(schedule.venues) { venue in
                    NavigationLink(destination: VenueDetail(venue: venue)) {
                        VenueRow(venue: venue)
                    }
                }.onDelete(perform: delete)
     /*       }
       */ }
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

