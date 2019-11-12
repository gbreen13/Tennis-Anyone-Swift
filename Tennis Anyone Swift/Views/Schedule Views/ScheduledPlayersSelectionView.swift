//
//  ScheduledPlayersView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct ScheduledPlayersSelectionView: View {
    
    @EnvironmentObject var schedule: Schedule
    @State var selections: [ScheduledPlayer] = []
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        NavigationView{
            VStack {
                List {
                    ForEach(self.schedule.players, id:\.id) { player in
                        MultipleSelectionRow(player: player,
                                             isSelected: self.selections.contains(where:  {$0.playerId == player.id}),
                                             action: {
                                                if self.selections.contains(where: {$0.playerId == player.id}) {
                                                    self.selections.removeAll(where: { $0.playerId == player.id })
                                                }
                                                else {
                                                    // we are adding a new player.  If for some reason this players is not already in the
                                                    // selected players array, create one based on the player.
                                                    if !self.schedule.scheduledPlayers.contains( where: {$0.playerId == player.id}) {
                                                        self.schedule.scheduledPlayers.append(ScheduledPlayer(player: player))
                                                    }
                                                    self.selections.append(self.schedule.scheduledPlayers.first( where: {$0.playerId == player.id})!)
                                                }
                        },
                                             scheduledPlayer: self.selections.first(where: {$0.playerId == player.id}),
                                             schedule:self.schedule)
                    }
                    
                }
                Spacer()
            }.onAppear(perform: {
                self.selections = self.schedule.scheduledPlayers.map{$0.copy() as! ScheduledPlayer}
                print("onAppear")
            })
                .navigationBarTitle("Contract Players")
                .navigationBarItems(
                    leading:
                    Button(action: {
                        print("cancel form")
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel").multilineTextAlignment(.leading).frame(height: 60)
                    },
                    trailing:                    Button(action: {
                        print("accept form")
                        self.schedule.scheduledPlayers = self.selections
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done").multilineTextAlignment(.leading).frame(height: 60)
                    }
            )
        }
    }
    
}

struct MultipleSelectionRow: View {
    var player: Player
    var isSelected: Bool
    var action: () -> Void
    var scheduledPlayer: ScheduledPlayer?
    var schedule: Schedule
    
    @State var showingDetail = false
    @State var workingPlayer = ScheduledPlayer()
    @ObservedObject var rkManager: RKManager

    init (player: Player, isSelected: Bool, action: @escaping ()->Void, scheduledPlayer: ScheduledPlayer?, schedule: Schedule) {
        self.player = player
        self.isSelected = isSelected
        self.action = action
        self.scheduledPlayer = scheduledPlayer
        self.schedule = schedule
        self.rkManager = RKManager(startDate: schedule.startDate, endDate: schedule.endDate, closedDates: schedule.blockedDays, blockedDates: [Date]())
    }
    
    var body: some View {
        
        HStack {
            if self.isSelected {
                Button(action: {}) {
                    Image(systemName: "checkmark.circle")
                        .font(.title)
                        .onTapGesture(perform: self.action)
                }
            } else {
                Button(action: {}) {
                    Image(systemName: "circle")
                        .font(.title)
                        .onTapGesture(perform: self.action)
                }
            }
            Image(uiImage: self.player.profilePicture!).renderingMode(.original).clipShape(Circle())
            Text(self.player.firstName + " " + self.player.lastName)
            Spacer()
            if self.isSelected {
                VStack {
                    Text("\(self.scheduledPlayer!.blockedDays.count) Blocked Days")
                        .font(Font.custom("Tahoma", size: 10))
                        .foregroundColor(.gray)
                    Text("Percent booked:\(self.scheduledPlayer!.percentPlaying, specifier: "%.f")%")
                        .font(Font.custom("Tahoma", size: 10))
                        .foregroundColor(.gray)
                    
                }
            }
            
            if self.isSelected {
                Button(action: {
                    self.showingDetail.toggle()
                    self.rkManager.blockedDates = self.workingPlayer.blockedDays
                }) {
                    Image(systemName: "chevron.right")
                }.sheet(isPresented: $showingDetail) {
 
                    ScheduledPlayerSelectionDetailedView(player: self.player, scheduledPlayer: self.$workingPlayer, rkManager: self.rkManager, onCancel: {
                        self.workingPlayer = self.scheduledPlayer!
                    }, onDone: {
                        self.schedule.scheduledPlayers.removeAll(where: { $0.id == self.workingPlayer.id })
                        self.schedule.scheduledPlayers.append(self.workingPlayer)
                    })
                }.onAppear {
                    self.workingPlayer = self.scheduledPlayer!
                }
            }
            
        }
    }
}


struct ScheduledPlayersDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledPlayersSelectionView().environmentObject(Schedule())
    }
}

