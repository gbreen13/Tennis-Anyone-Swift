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
    @State var localBlockedDates: [Date] = [Date]()
    @State var sliderValue: Double = 100.0
    
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
                                self.scheduledPlayer.blockedDays = self.localBlockedDates
                                self.scheduledPlayer.percentPlaying = self.sliderValue
                                self.onDone()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    }
                }
                Image(uiImage: self.player.profilePicture!).resizable().frame(width: 100, height: 100, alignment: .center)
                Spacer()
                Form {
                    Section(header: Text(scheduledPlayer.name)){
                        Slider(value: $sliderValue, in: 25...100, step: 5)
                        Text("Percent booked:\(sliderValue, specifier: "%.f")%")
                    }

                    Section(header:
                        HStack {
                            Text("UNAVAILABLE DAYS")
                            Spacer()
                            Button(action: { self.localBlockedDates.append(Date().stripTime())}) {
                                Image( systemName:"plus.circle")
                                    .font(.title)
                            }
                    }){
                        List {
                            ForEach(self.localBlockedDates.indices, id:\.self) { index in
                                DatePicker(selection: self.$localBlockedDates[index],
                                           //in: self.schedule.startDate ... self.schedule.endDate,
                                displayedComponents: .date) {
                                    Text("Unavailable")
                                }
                            }.onDelete(perform: delete)
                        }
                    }
                    
                }
            }
        }.onAppear {
            self.localBlockedDates = self.scheduledPlayer.blockedDays
            self.sliderValue = self.scheduledPlayer.percentPlaying
        }.padding()
    }
    func delete(at offsets: IndexSet) {
        localBlockedDates.remove(atOffsets: offsets)
    }
}

