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


struct ScheduleView: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule

    @State private var showingAlert = false
    @State private var errorString = ""
    
    @State private var showModal = false


    var body: some View {

        NavigationView {

            Form {


//                  .padding(.horizontal)
//               .background(Color.red.opacity(0.2))
//                   .colorMultiply(Color.green)

                ScheduleFirstSection()

                Section(header:
                    HStack {
                        Text("Closed Days")
                        Spacer()
                         Image(systemName: "plus.circle").foregroundColor(.blue)
                        
                    } .frame(height: 20.0)
                ) {
                    BlockedList()
                }

                Section(header:
                    HStack {
                        Text("Scheduled Players")
                        Spacer()
                        Button(action: { self.showModal.toggle() }) {
                            Image( systemName:"pencil")
                        }
                    }.popover(isPresented: $showModal,
                              arrowEdge: .bottom){
                                //print("popover")
                                ScheduledPlayersDetailedView()
                                    .environmentObject(self.schedule)
                    })
                {
                        
                    ScheduledPlayersView()
                }
                Section(header: Text("Weekly Schedule")){
                    WeeklyScheduleView()
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarItems(trailing:
                Button(action: {

 
#if DEBUG
                        /*
                            do  {
                            let jsonEncoder = JSONEncoder()
                            let decoder = JSONDecoder()

                            var jsonData = Data()
                            jsonData = try jsonEncoder.encode(self.schedule)  // now reencode the data
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                            print(jsonString)
                            let scheduleTest = try decoder.decode(Schedule.self, from: jsonString.data(using: .utf8)!)
                            print(scheduleTest as Any);
                        */
#endif
                    do {
                        try self.validateForm()

                        if(self.showingAlert == false) {
                            print("building")
                            self.schedule.prepareForBuild()
                            try self.schedule.BuildSchedule()
                            let jsonEncoder = JSONEncoder()
 
                            var jsonData = Data()
                            jsonData = try jsonEncoder.encode(self.schedule)  // now reencode the data
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                            print(jsonString)
                            print(self.schedule as Any);

                        }
                    } catch  {
                            self.showingAlert = true
                            self.errorString = error.localizedDescription
                        }

                    }) {
                        Text("Build")
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

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView().environmentObject(Schedule())
    }
}
