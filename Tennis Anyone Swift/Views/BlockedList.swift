//
//  BlockedList.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/21/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct BlockedList : View {

@EnvironmentObject var schedule: Schedule
@State private var blockedDay =  Date()

var body: some View {
        List {
            ForEach(schedule.blockedDays, id: \.self) { blockedDay in
                DatePicker(selection: self.$blockedDay, in: self.schedule.startDate ... self.schedule.endDate, displayedComponents: .date) {
                    Text("Venue Blocked/Closed")
                }
            }
        }
    }
}
