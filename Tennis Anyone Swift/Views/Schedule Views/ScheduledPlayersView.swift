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
        
        //            NavigationLink(destination: ScheduledPlayersDetailedView()) {
        //                Color.green
        
        ScrollView (.horizontal, content: {
            //Color(red:225/255, green: 225/255, blue: 225/255)
            HStack(alignment: .top) {
                
                ForEach(self.schedule.scheduledPlayers, id:\.id) { sp in
                    VStack {
                        Image(uiImage: self.schedule.players.first(where: {$0.id == sp.playerId})!.profilePicture!).renderingMode(.original).clipShape(Circle())
                        //.offset(x: -18)
                        //.padding(.trailing, -18)
                        Text(sp.name)
                            .font(Font.custom("Tahoma", size: 10))
                            .foregroundColor(.blue)
                        Spacer()
                        
                        Text("\(sp.percentPlaying, specifier: "%.f")%")
                            .font(Font.custom("Tahoma", size: 10))
                            .foregroundColor(.gray)
                        
                        Text("\(sp.numWeeks) Weeks")
                            .font(Font.custom("Tahoma", size: 10))
                            .foregroundColor(.gray)
                    } .frame(width: 40.0)
                    //   .padding(.trailing, -8.0)
                    //.offset(x: -18)
                }
            }
        })
    }
}


struct ScheduledPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledPlayersView().environmentObject(Schedule())
    }
}
