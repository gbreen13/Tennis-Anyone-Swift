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
    var onCancel:()->Void
    var onDone:()->Void

    @EnvironmentObject var schedule: Schedule
    @Environment(\.presentationMode) var presentationMode

    var playerIndex: Int {
        self.schedule.scheduledPlayers.firstIndex(where: { $0.id == scheduledPlayer.id })!
    }
//
    @State private var blockedDay =  Date()

    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    Button(action: {}) {
                        Text("Cancel")
                            .onTapGesture(perform: {
                                print("Cancel")
                                self.onCancel()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Done")
                            .onTapGesture( perform: {
                                print("Done")
                                self.onDone()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    }
                }
                Image(uiImage: self.player.profilePicture!).resizable().frame(width: 100, height: 100, alignment: .center)
                Spacer()
                Form {
                    Section(header: Text(scheduledPlayer.name)){
                        Slider(value: self.$scheduledPlayer.percentPlaying, in: 25...100, step: 5)
                        Text("Percent booked:\(self.scheduledPlayer.percentPlaying, specifier: "%.f")%")
                    }
                    Section(header: Text("Unavailable Days")){
                        List {
                            ForEach(scheduledPlayer.blockedDays, id: \.self) { blockedDay in
                                DatePicker(selection: self.$blockedDay,
                                           //in: self.schedule.startDate ... self.schedule.endDate,
                                displayedComponents: .date) {
                                    Text("Venue Blocked/Closed")
                                }
                            }
                        }
                    }
                    
                }
            }
        }.padding()
    }
}

