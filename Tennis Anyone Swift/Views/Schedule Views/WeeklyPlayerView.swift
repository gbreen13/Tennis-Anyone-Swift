//
//  Weekly PlayerView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/30/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import SwiftUI

struct WeeklyPlayerView: View {

    var pw: PlayWeek
    @EnvironmentObject var schedule: Schedule
    
    var body: some View {
        HStack(alignment: .top){
            ForEach(self.pw.scheduledPlayers!, id:\.id) { sp in
                VStack {
                   Image(uiImage: self.schedule.players.first(where: {$0.id == sp.playerId})!.profilePicture!)
                        .renderingMode(.original)
                        .clipShape(Circle())
                   
                    Text(sp.name)
                        .font(Font.custom("Tahoma", size: 10))
                        .foregroundColor(.blue)

                    Spacer()
                    
                   Text("\(sp.numWeeks) Weeks")
                      .font(Font.custom("Tahoma", size: 10))
                       .foregroundColor(.gray)
      
                    
                }.frame(width: 45.0)
                    .padding(.trailing, -05)
            }
            
            ForEach(self.pw.scheduledPlayers!.count ..< (self.schedule.isDoubles ? 4 : 2), id:\.self) {_ in
                VStack {
                    Image("unassigned44b")
                 }.frame(width: 45.0)
                 .padding(.trailing, -05)
            }
 
            
        }
    }
}
