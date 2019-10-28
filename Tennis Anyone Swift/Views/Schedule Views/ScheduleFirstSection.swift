//
//  ScheduleFirstSection.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/27/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct ScheduleFirstSection : View {

@EnvironmentObject var schedule: Schedule

    var body: some View {
        
        Section(header: Text("TIME AND PLACE")) {

            HStack(alignment: .center) {
                
                if(schedule.isDoubles){
                    Text("Singles")
                        .foregroundColor(Color.gray)
                    
                } else {
                    Text("Singles")
                        .foregroundColor(Color.gray)
                    .bold()
                }
                
                Toggle(isOn: $schedule.isDoubles)
 //                   .frame(alignment: .center)
                    {
                        EmptyView()
                    }
                
                Spacer()
                
                if(!schedule.isDoubles){
                    Text("Doubles")
                        .foregroundColor(Color.gray)
                } else {
                    Text("Doubles")
                        .foregroundColor(Color.gray)
                        .bold()
                }

            }
            
            DatePicker(
                selection: $schedule.startDate,
               // in: dateClosedRange,
                displayedComponents: .date,
                label: { Text("Start Date") }
            )
            DatePicker(
                selection: $schedule.endDate,
    //                        in: self.schedule.starDate ... ,
                displayedComponents: .date,
                label: { Text("End Date").foregroundColor(schedule.validDates() ? .black: .red) }
            )
            
           Text("# Playable Weeks:\(schedule.returnNumberOfPlayweeks())")

            Picker(selection: $schedule.currentVenue, label: Text("Where") .foregroundColor((schedule.venues.firstIndex(where: { $0.id == self.schedule.currentVenue }) != nil) ? .black: .red)) {

                ForEach(self.schedule.venues, id: \.id) { venue in
                    Text(venue.name).tag(venue.id)
                }
            }
        }
    }
}
