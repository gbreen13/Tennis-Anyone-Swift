//
//  RKManager.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

class RKManager : ObservableObject {
//
//  Note, all dates are disabled (unselectabled) by  default.  That includes those dates that the club is closed.
//  Only the weekly dates that ths contract is valis can be chosen.
//

    @Published var calendar = Calendar.current      // calendar we are using
    @Published var minimumDate: Date = Date()       // first day of the contract
    @Published var maximumDate: Date = Date()       // last day of the contract
    @Published var disabledDates: [Date] = [Date]() // dates facility is closed.
    @Published var blockedDates: [Date] = [Date]()  // dates player will block
    @Published var enabledDates: [Date] = [Date]()  // list of contract dates to be enabledin the system
    
    var colors = RKColorSettings()
  
    init(schedule: Schedule, blockedDates: [Date]) {
        self.minimumDate = schedule.startDate
        self.maximumDate = schedule.endDate
        self.disabledDates = schedule.blockedDays
        self.blockedDates = blockedDates            // this is the array of player's blocked days.
    }
    
    func blockedDatesContains(date: Date) -> Bool {
        if let _ = self.blockedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func blockedDatesFindIndex(date: Date) -> Int? {
        return self.blockedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
    func disabledDatesContains(date: Date) -> Bool {
        if let _ = self.disabledDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func disabledDatesFindIndex(date: Date) -> Int? {
        return self.disabledDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
}
