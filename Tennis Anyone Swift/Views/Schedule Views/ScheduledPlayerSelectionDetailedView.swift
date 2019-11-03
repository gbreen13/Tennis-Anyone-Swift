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
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var player: Player

    @EnvironmentObject var schedule: Schedule
    @Environment(\.presentationMode) var presentationMode

//    var scheduledPlayer = self.schedule.scheduledPlayers.first(where: { $0.playerId == player.id })

//    @State var name: String = self.venue.name
    var body: some View {
        VStack {
            Button(action: {
                 print("dismisses form")
                 self.presentationMode.wrappedValue.dismiss()
            })
            {
                 Text("Done").multilineTextAlignment(.leading).frame(height: 60)
            }
            .frame(alignment: .top)

            Image(uiImage: player.profilePicture!).resizable().frame(width: 100, height: 100, alignment: .center)
     /*       Form {
            List {
                ForEach(player.blockedDays, id: \.self) { blockedDay in
                    DatePicker(selection: self.player.$blockedDay,
                               //in: self.schedule.startDate ... self.schedule.endDate,
                    displayedComponents: .date) {
                        Text("Venue Blocked/Closed")
                    }
                }
            }
        }*/
        }

    }
}

