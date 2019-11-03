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
        NavigationView {
        VStack {
            
            Button(action: {
                print("dismisses form")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done").multilineTextAlignment(.leading).frame(height: 60)
            }
            Spacer()
            List {
                ForEach(schedule.players, id:\.name) { player in
                    MultipleSelectionRow(player: player,
                         isSelected: self.schedule.scheduledPlayers.contains(where:  {$0.playerId == player.id}),
                         action: {
                            if self.schedule.scheduledPlayers.contains(where: {$0.playerId == player.id}) {
                                self.schedule.scheduledPlayers.removeAll(where: { $0.playerId == player.id })
                            }
                            else {
                                self.schedule.scheduledPlayers.append(ScheduledPlayer(player:player))
                            }
                        }
                        )
                 }
            }
            }.navigationBarTitle("Player Selection")
        }
    }
}

struct MultipleSelectionRow: View {
    var player: Player
    var isSelected: Bool
    var action: () -> Void
    @State var showingDetail = false
    
    var body: some View {
        HStack {
            if self.isSelected {
                Button(action: {}) {
                    Image(systemName: "checkmark.circle")
                        .onTapGesture(perform: self.action)
                }
            } else {
                Button(action: {}) {
                    Image(systemName: "circle")
                        .onTapGesture(perform: self.action)
                }
            }
            Image(uiImage: self.player.profilePicture!).renderingMode(.original)
            Text(self.player.firstName + " " + self.player.lastName)
            Spacer()
            if self.isSelected {
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "info.circle")
                }.sheet(isPresented: $showingDetail) {
                    ScheduledPlayerSelectionDetailedView(player:self.player)
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
