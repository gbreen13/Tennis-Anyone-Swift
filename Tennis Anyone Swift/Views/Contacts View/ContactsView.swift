//
//  ContactsView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI


func dismiss() {
    print("dismiss")
}

struct ContactsView: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule

    @State var isDoubles = true
    @State private var showingAlert = false
    @State private var errorString = ""
    
    @State private var showModal = false
    @State private var showVenueModal = false
    @State var selectedPlayers:[Player]?


    
    @State var dismissfunc = dismiss

    var body: some View {

        NavigationView {
            
            Form {
                Section(header:
                    HStack {
                        Text("COURTS")
                        Spacer()
                        Button(action: {
                            self.showVenueModal.toggle()
                            self.schedule.venues.append(Venue())
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                    }
                ) {
                    if (self.schedule.venues.count == 0) {
                        VenuePrompt()
                    } else {
                        VenueList()
                    }
                }
                
                Section(header:
                    HStack {
                        Text("POTENTIAL PLAYERS")
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
                        ModalView(selectedPlayers: self.$selectedPlayers)
                        
                    })
                {
                    if (self.schedule.players.count == 0) {
                        ContactsPrompt()
                    } else {
                        PlayerList()
                    }
                }
            }
            .navigationBarTitle("Contacts")
//#if DEBUG
            .navigationBarItems(trailing:
                    Button(action: {
                        
                        print(self.schedule)
                        print(self.schedule.players)
                        print(self.schedule.scheduledPlayers)
                    }
                    ) {
                        Text("Dump")
                    }
            )
//#endif
                .listStyle(GroupedListStyle())
        }
    }
    
}

struct ContactsPrompt: View {
    var body: some View {
        GentlePrompt(errorString: "Press to add tennis players from contacts.  Swipe to delete.",promptImage: "addcontactsel")
    }
}
struct VenuePrompt: View {
    var body: some View {
            GentlePrompt(errorString: "Press to add a slot for a tennis club, then select to fill in the details.  swipe to delete",promptImage: "plus.circle")
    }
}

struct ModalView: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule
    @Binding var selectedPlayers: [Player]?
    
    @State var dismissfunc = dismiss

    var body: some View {
        EmbeddedContactPicker(selectedPlayers: self.$selectedPlayers, dismissfunc: self.$dismissfunc)
    }
}
struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView().environmentObject(Schedule())
    }
}
