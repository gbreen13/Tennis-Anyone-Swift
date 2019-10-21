//
//  ContentView.swift
//  iDine
//
//  Created by George Breen on 10/9/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Combine
import SwiftUI

enum ScheduleFormError: Error {
    case EndDateTooEarly
    case NoWeeksToSchedule
}

extension ScheduleFormError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .EndDateTooEarly:
            return NSLocalizedString("End date must be after start date", comment: "")
        case .NoWeeksToSchedule:
            return NSLocalizedString("Start and end dates must be at least one week apart", comment:"")

        }
    }
}

struct ContentView: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule

    @State var isDoubles = true
    @State private var showingAlert = false
    @State private var errorString = ""


    var body: some View {

        NavigationView {
            
            Form {
  
                Section(header: Text("Time and Place")) {

                    Toggle(isOn: $isDoubles) {
                        if(isDoubles) {
                            Text("Singles").foregroundColor(Color.gray)
                            Text("/")
                            Text("Doubles").bold()
                        }else {
                            Text("Singles").bold()
                            Text("/")
                            Text("Doubles").foregroundColor(Color.gray)
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
                       // in: dateClosedRange,
                        displayedComponents: [.date],
                        label: { Text("End Date") }
                    )
                        
                    Picker(selection: $schedule.currentVenue, label: Text("Where") .foregroundColor((schedule.venues.firstIndex(where: { $0.id == schedule.currentVenue }) != nil) ? .black: .red)) {

                        ForEach(schedule.venues, id: \.id) { venue in
                            Text(venue.name).tag(venue.id)
                        }
                    }
                    
                }
                Section(header: Text("Players")){
                    PlayerList()
                }
                Section(header: Text("Venues")){
                    VenueList()
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarItems(trailing:
                Button(action: {
                    do  {
                            try self.validateForm()
                    } catch  {
                            self.showingAlert = true
                         self.errorString = error.localizedDescription
                    }

                    if(self.showingAlert == false) {
                        print("saved")
                    }
                    }) {
                        Text("Save")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(self.errorString), dismissButton: .default(Text("OK")))
                    }

            )
            .listStyle(GroupedListStyle())
        }
    }
    func validateForm() throws {

        if (self.schedule.endDate < self.schedule.startDate) {
            throw(ScheduleFormError.EndDateTooEarly)
        }
        let diffInDays = Calendar.current.dateComponents([.day], from: self.schedule.startDate, to: self.schedule.endDate).day!
        
        if (diffInDays < 7) {
            throw(ScheduleFormError.NoWeeksToSchedule)
        }
    }

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        return min...max
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Schedule())
    }
}
