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
            Image(uiImage: player.profilePicture!).clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(player.name!)
                    .multilineTextAlignment(.leading)
                Text(player.phone!)
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Tahoma", size: 10))
                    .foregroundColor(.gray)
                Text(player.email)
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Tahoma", size: 10))
                    .foregroundColor(.gray)            }
            
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
        for index in offsets {
            let p = self.schedule.players[index]
            
            let schindex = schedule.scheduledPlayers.firstIndex(where : {$0.playerId == p.id})
            if schindex != nil {        // WARNING! the deleted player is currently scheduled.  Do we want to kill the schedule?
                if schedule.isBuilt {
                    schedule.prepareForBuild()  // order of these two lines matter?
                }
                schedule.scheduledPlayers.remove(at: schindex!) //regardless, delete him from the scheduled list.
            }
        }
        schedule.players.remove(atOffsets: offsets)
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
