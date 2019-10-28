//
//  ScheduledPlayersView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct ScheduledPlayersDetailedView: View {

    @EnvironmentObject var schedule: Schedule
    @State var selections: [ScheduledPlayer] = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            
         Button(action: {
             print("dismisses form")
             self.presentationMode.wrappedValue.dismiss()
         }) {
            Text("Done").multilineTextAlignment(.leading).frame(height: 30)
         }
            Spacer()
          List {
                ForEach(schedule.players, id:\.name) { player in
                    MultipleSelectionRow(title: player.name!, thumbNail: player.profilePicture,
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
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var thumbNail: UIImage?
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(uiImage: thumbNail!).renderingMode(.original)
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct ScheduledPlayersDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledPlayersDetailedView().environmentObject(Schedule())
    }
}
