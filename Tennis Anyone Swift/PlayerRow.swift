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
//            Image(item.thumbnailImage)   .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(player.name!)
                    .multilineTextAlignment(.leading)
                Text(player.phone!)
                    .multilineTextAlignment(.leading)
            }
            
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayerRow(player: Player.example)
    }
}
