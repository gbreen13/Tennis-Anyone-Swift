//
//  ScheduledPlayerSelectionDetailedView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 11/3/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import SwiftUI

struct ScheduledPlayerSelectionDetailedView: View {
    var player: Player
    @Binding var scheduledPlayer: ScheduledPlayer
    var doneAction: ()->Void

    @EnvironmentObject var schedule: Schedule
    @Environment(\.presentationMode) var presentationMode

    var playerIndex: Int {
        self.schedule.players.firstIndex(where: { $0.id == scheduledPlayer.playerId })!
    }
//    @State var name: String = self.venue.name
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                
                Button(action: {}) {
                    Text("Cancel")
                        .onTapGesture(perform: {
                            print("Cancel")
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Done")
                        .onTapGesture( perform: {
                            print("Done")
                            self.doneAction()
                            self.presentationMode.wrappedValue.dismiss()
                        })
                }
            }

            Image(uiImage: self.player.profilePicture!).resizable().frame(width: 100, height: 100, alignment: .center)
            TextField("UserName", text: $scheduledPlayer.name)
        }.padding()
        }
    }
}

