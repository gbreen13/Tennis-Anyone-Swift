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
    
    @State private var endDate: Date = Date()

    private var endDateProxy:Binding<Date> {
        Binding<Date>(get: {self.schedule.endDate }, set: {
            self.endDate = $0
            self.schedule.endDate = $0
            self.schedule.validateForm()
        })
    }

    @State private var startDate: Date = Date()

    private var startDateProxy:Binding<Date> {
        Binding<Date>(get: {self.schedule.startDate }, set: {
            self.startDate = $0
            self.schedule.startDate = $0
            self.schedule.validateForm()
        })
    }

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
                selection: startDateProxy,
               // in: dateClosedRange,
                displayedComponents: .date,
                label: { Text("Start Date") }
            )
            DatePicker(
                selection: endDateProxy,
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
