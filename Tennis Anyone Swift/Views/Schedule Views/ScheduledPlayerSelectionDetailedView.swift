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
    class DateItem: Identifiable {
        var id = UUID()
        @State var date: Date
        required init(date:Date) {
            _date = date
        }
    }

    @State private var blockedDay =  Date()
    @State var sliderValue: Double = 100.0
    @State var bd: [DateItem] = [DateItem]()
    
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
                            Text("UNAVAILABLE DAYS")
                            Spacer()
                            Button(action: {
                                self.bd.append(DateItem(date:Date().stripTime())) })
                            {
                                Image( systemName:"plus.circle")
                                    .font(.title)
                            }
                            
                    }){
                        List {
                            ForEach(self.bd, id:\.id) { bdate in
                                DatePicker(selection: bdate.$date, displayedComponents: .date) {
                                    Text("Unavailable:")
                                }
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
                            self.scheduledPlayer.blockedDays = self.bd.map {$0.date}
                            self.scheduledPlayer.percentPlaying = self.sliderValue
                            self.onDone()
                            self.presentationMode.wrappedValue.dismiss()
                        })
                }
            )
        }.onAppear {
            self.bd.removeAll()
            for bdate in self.scheduledPlayer.blockedDays {
                let di: DateItem = DateItem(date:bdate.stripTime())
                self.bd.append(di)
            }
            self.sliderValue = self.scheduledPlayer.percentPlaying
        }.padding()
    }
    func delete(at offsets: IndexSet) {
        self.bd.remove(atOffsets: offsets)

    }
}

