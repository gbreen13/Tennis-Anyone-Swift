//
//  ScheduledPlayersView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/25/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import SwiftUI

struct ScheduledPlayersView: View {

    @EnvironmentObject var schedule: Schedule
    var body: some View {

            NavigationLink(destination: ScheduledPlayersDetailedView()) {
                ScrollView {
                    HStack(alignment: .top) {
                       
                    ForEach(self.schedule.scheduledPlayers) { sp in
                        VStack {
                            Image(uiImage: self.schedule.players.first(where: {$0.id == sp.playerId})!.profilePicture!).renderingMode(.original).clipShape(Circle())
                            Text(sp.name)
                               .font(Font.custom("Tahoma", size: 10))
                                .foregroundColor(.blue)
                        } .frame(width: 45.0)
                            .padding(.trailing, -05)
                     }
                    }
            }
        }
    }
}

struct ScheduledPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledPlayersView().environmentObject(Schedule())
    }
}
