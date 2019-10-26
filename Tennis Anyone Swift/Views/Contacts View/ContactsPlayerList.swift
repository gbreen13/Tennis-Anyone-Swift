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
        }
    }
    func delete(at offsets: IndexSet) {
        schedule.players.remove(atOffsets: offsets)
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
