//
//  PlayerRow.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/16/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI


struct PlayerRow : View {
    var player: Player

    var body: some View {
        HStack {
//            Image(uiImage: player.profilePicture!).clipShape(Circle())
            
            Image(uiImage: player.profilePicture!).clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(player.name!)
                    .multilineTextAlignment(.leading)
                Text(player.phone!)
                    .multilineTextAlignment(.leading)
            }
            
        }
    }
}


struct PlayerList : View {
    @EnvironmentObject var schedule: Schedule

    var body: some View {

        List {      //id:\.id causes a fuckup for some reason
            ForEach(schedule.players ,id:\.name) { player in
                PlayerRow(player: player)
            }.onDelete(perform: delete)
            .onMove(perform: move)
        }
    }
    func delete(at offsets: IndexSet) {
        var killThemAll = true
        for index in offsets {
            let p = self.schedule.players[index]
            
            let schindex = schedule.scheduledPlayers.firstIndex(where : {$0.playerId == p.id})
            if schindex != nil {        // WARNING! the deleted player is currently scheduled.  Do we want to kill the schedule?
                if schedule.isBuilt! {
                    ActionSheet(title: Text("player is currently scheduled"), message: Text("Do you want to delete the player and rebuild the schedule?"), buttons: [
                        .cancel(Text("No Way")), .destructive(Text("Delete"))])

                }
                if killThemAll {
                    schedule.prepareForBuild()  // order of these two lines matter?
                    schedule.scheduledPlayers.remove(at: schindex!)
                }
            }
        }
        if killThemAll {
            schedule.players.remove(atOffsets: offsets)
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        schedule.players.move(fromOffsets: source, toOffset: destination)
     }
}

struct PlayerList_Previews: PreviewProvider {
    @EnvironmentObject var schedule: Schedule
    static var previews: some View {

        List {
            PlayerRow(player: Player.example)
        }
    }
}
