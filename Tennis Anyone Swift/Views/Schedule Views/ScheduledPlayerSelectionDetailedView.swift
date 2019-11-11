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
    @ObservedObject var rkManager: RKManager
    var onCancel:()->Void
    var onDone:()->Void

    @EnvironmentObject var schedule: Schedule
    @Environment(\.presentationMode) var presentationMode

    var playerIndex: Int {
        self.schedule.scheduledPlayers.firstIndex(where: { $0.id == scheduledPlayer.id })!
    }
//
    @State var sliderValue: Double = 100.0
    @State var calIsPresented = false
    
    static let dayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: self.player.profilePicture!).resizable().frame(width: 100, height: 100, alignment: .center).clipShape(Circle())
                Spacer()
                Form {
                    Section(header: Text(scheduledPlayer.name)){
                        Slider(value: $sliderValue, in: 25...100, step: 5)
                        Text("Percent booked:\(sliderValue, specifier: "%.f")%")
                    }

                    Section(header:
                        HStack {
                            Text("\(self.rkManager.blockedDates.count) UNAVAILABLE DAYS")
                            Spacer()
                            Button(action: {self.calIsPresented.toggle()})
                            {
                                Image( systemName:"calendar")
                                    .font(.title)
                            }.sheet(isPresented: self.$calIsPresented, content: {
                                RKViewController(isPresented: self.$calIsPresented, rkManager: self.rkManager)})


                            
                    }){
                        List {
                            ForEach(self.rkManager.blockedDates,id:\.self) { blocked in
                                Text("\(blocked, formatter: Self.dayDateFormat)")
                            }.onDelete(perform: delete)
                        }
                    }
                    
                }
            }.navigationBarTitle(scheduledPlayer.name + " Settings")
            .navigationBarItems(
              leading:
                Button(action: {}) {
                  Text("Cancel")
                      .onTapGesture(perform: {
                          print("Cancel")
                          self.onCancel()
                          self.presentationMode.wrappedValue.dismiss()
                      })
                  
                },
              trailing:
                Button(action: {}) {
                    Text("Done")
                        .onTapGesture( perform: {
                            print("Done")
                            self.scheduledPlayer.blockedDays = self.rkManager.blockedDates
                            self.scheduledPlayer.percentPlaying = self.sliderValue
                            self.onDone()
                            self.presentationMode.wrappedValue.dismiss()
                        })
                }
            )
        }.onAppear {
            self.rkManager.blockedDates = self.scheduledPlayer.blockedDays
            self.sliderValue = self.scheduledPlayer.percentPlaying
        }.padding()
    }
    func delete(at offsets: IndexSet) {
        self.scheduledPlayer.blockedDays.remove(atOffsets: offsets)
        self.rkManager.blockedDates = self.scheduledPlayer.blockedDays


    }
}

