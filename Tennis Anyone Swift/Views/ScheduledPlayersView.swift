//
//  ScheduledPlayersView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct MultipleSelectionList: View {

    @EnvironmentObject var schedule: Schedule
    @State var selections: [ScheduledPlayer] = []

    var body: some View {
        List {
            ForEach(schedule.players, id:\.id) { player in
                MultipleSelectionRow(title: player.name!,
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

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
