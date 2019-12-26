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

/*
     Because we need to validate the dates and put up an error message if they don't jibe, we need to have
     proceedural code when the dates change to go back and trigger a redraw of the Schedule screen.
     onTapGesture doesn't seem to work with DatePickers, so the next best thing
     is to create a binding proxy with set and get code that manipulates the model and checks the
     */
    private var endDateProxy:Binding<Date> {
        Binding<Date>(get: {self.schedule.endDate }, set: {
            self.schedule.endDate = $0
            self.schedule.validateForm()
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen

        })
    }

    private var startDateProxy:Binding<Date> {
        Binding<Date>(get: {self.schedule.startDate }, set: {
            self.schedule.startDate = $0
            self.schedule.validateForm()
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen

        })
    }
    private var currentVenueProxy:Binding<UUID> {
        Binding<UUID>(get: {self.schedule.currentVenue }, set: {
            self.schedule.currentVenue = $0
            self.schedule.validateForm()
            self.schedule.objectWillChange.send()       // force the schedule to change to refresh the paretn screen

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
                displayedComponents: .date,
                label: { Text("Contract start date") }
            )
            DatePicker(
                selection: endDateProxy,
                displayedComponents: .date,
                label: { Text("Contract end date").foregroundColor(schedule.validDates() ? .black: .red) }
            )
            
           Text("# Playable Weeks:\(schedule.returnNumberOfPlayweeks())")

            Picker(selection: currentVenueProxy, label: Text("Where") .foregroundColor((schedule.venues.firstIndex(where: { $0.id == self.schedule.currentVenue }) != nil) ? .black: .red)) {

                ForEach(self.schedule.venues, id: \.id) { venue in
                    Text(venue.name).tag(venue.id)
                }
            }
        }
    }
}
