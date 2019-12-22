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
                .navigationBarItems(leading:
                    Button(action: {
                        
                        print(self.schedule)
                        print(self.schedule.players)
                        print(self.schedule.scheduledPlayers)
                    }
                    ) {
                        Text("Dump")
                    },
                                    trailing: Button(action: {
                                        do {
                                            try self.schedule.saveJson()
                                        }
                                        catch {}
                                    }
                                        
                                    ) {
                                        Text("Save")
                    }
            )
                .listStyle(GroupedListStyle())
        }
    }
    
}

struct ContactsPrompt: View {
    var body: some View {
        HStack {
            Spacer()
            Image("addcontactsel").renderingMode(.original)
            Spacer()
            Text("Press to add tennis players from contacts.  Swipe to delete.")
                .font(.title)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.white)
        }
        .background(Color(Constants.blueBackgroundColor))
        .listRowInsets(EdgeInsets())
        
        
    }
}
struct VenuePrompt: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "plus.circle")
                .foregroundColor(Color.white)
                .font(.title)
            Spacer()
            Text("Press to add a tennis club ")
                .font(.title)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.white)
        }
        .background(Color(Constants.blueBackgroundColor))
        .listRowInsets(EdgeInsets())
        
        
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
