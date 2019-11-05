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
            ForEach(self.schedule.playWeeks!, id:\.date) { pw in

                HStack {
                   Text("\(pw.date, formatter: Self.taskDateFormat)")
                    .foregroundColor((pw.scheduledPlayers!.count < 4) ? .red : .black)
                    
                   Spacer()
                    
                   VStack(alignment: .leading) {
                       WeeklyPlayerView(pw: pw)

                    
                        HStack {
                            if self.schedule.getBlockedPlayersImages(pw: pw).count > 0 {
                                Text("Unavail:")
                                    .font(Font.custom("Tahoma", size: 12))
                                    .foregroundColor(.red)
                                    //.multilineTextAlignment(.leading)
                                ForEach(self.schedule.getBlockedPlayersImages(pw: pw), id:\.self) { pi in
                                        Image(uiImage:  pi)
                                            .resizable()
                                            .frame(width: 20.0, height: 20.0)
                                            .clipShape(Circle())

                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

