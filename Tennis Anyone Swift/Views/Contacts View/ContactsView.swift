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
    
    @State private var showModal = false
    @State var selectedPlayers:[Player]?


    var body: some View {

        NavigationView {
            
            Form {
               Section(header: Text("PLACES")){
                   VenueList()
               }

                Section(header:
                    HStack {
                        Text("PLAYERS")
                        Spacer()
                        Button(action: {
                            self.showModal.toggle()
                        }) {
                            Image("addcontactsel")//.renderingMode(.original)
                        }
                    }
                    .sheet(isPresented: self.$showModal,onDismiss: {
                        if self.selectedPlayers != nil {
                            print(self.selectedPlayers as Any)
                            for player in self.selectedPlayers! {
                                if !self.schedule.players.contains(player) {
                                    self.schedule.players.append(player)
                                }
                            }
                        }
                    }) {
                        EmbeddedContactPicker(selectedPlayers: self.$selectedPlayers)
                    }                   )
                {
                   PlayerList()
                }
            }//.background(Image("background")).aspectRatio(contentMode: .fill)
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
