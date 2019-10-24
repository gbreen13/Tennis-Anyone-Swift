//
//  ContactsView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct ContactsView: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule

    @State var isDoubles = true
    @State private var showingAlert = false
    @State private var errorString = ""
    


    var body: some View {

        NavigationView {
            
            Form {
               
                 Section(header: Text("Players").foregroundColor(schedule.validNumberOfPlayers() ? .gray : .red)){
                    PlayerList()
                }
                Section(header: Text("Venues")){
                    VenueList()
                }
            }
            .navigationBarTitle("Contacts")
            .navigationBarItems(trailing:
                Button(action: {
#if DEBUG
                    print(self.schedule)
                    print(self.schedule.players)
                    print(self.schedule.scheduledPlayers)
#endif

                    }

            ) {
                                   Text("Save")
                               }
                    )
            .listStyle(GroupedListStyle())
        }

    }
}
struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView().environmentObject(Schedule())
    }
}
