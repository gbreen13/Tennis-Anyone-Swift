//
//  WeeklyScheduleView.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/26/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import SwiftUI



struct WeeklyScheduleView: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()

    var body: some View {

        List {
            ForEach(schedule.playWeeks!, id:\.date) { pw in
                HStack {
                    Text("\(pw.date, formatter: Self.taskDateFormat)")
                    VStack {
                        HStack(alignment: .top) {
                            ForEach(pw.scheduledPlayers!) { sp in
                                VStack {
                                    Image(uiImage: self.schedule.players.first(where: {$0.id == sp.playerId})!.profilePicture!).renderingMode(.original).clipShape(Circle())
                                    Text(sp.name)
                                       .font(Font.custom("Tahoma", size: 10))
                                        .foregroundColor(.blue)
                                } .frame(width: 45.0)
                                    .padding(.trailing, -05)
                             }
                            Spacer()
                        }
                        HStack {
                            if self.schedule.getBlockedPlayersImages(pw: pw).count > 0 {
                                Text("Unavail:")
                                    .font(Font.custom("Tahoma", size: 12))
                                    //.foregroundColor(.red)
                                    //.multilineTextAlignment(.leading)
                                ForEach(self.schedule.getBlockedPlayersImages(pw: pw), id:\.self) { pi in
                                        Image(uiImage:  pi)
                                            .resizable()
                                            .frame(width: 20.0, height: 20.0)
                                            .clipShape(Circle())

                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct WeeklyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
    WeeklyScheduleView().environmentObject(Schedule())
    }
}
