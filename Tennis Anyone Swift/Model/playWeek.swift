//
//  playWeek.swift
//  TennisSchedulerSwift
//
//  Created by George Breen on 9/19/19.
//  Copyright © 2019 George Breen. All rights reserved.
//


import Foundation

class PlayWeek: CustomStringConvertible, Codable {
    
    enum CodingKeys: CodingKey {
        case date, scheduledPlayers
    }
    enum PlayWeekError: Error {
        case invalidDate
    }
    var scheduledPlayersNames: [UUID]?  // who's playing this week
	var scheduledPlayers: [ScheduledPlayer]?			// the player class that matches the names.
    var date: Date
    
    init(date: Date) {
        self.date = date
        self.scheduledPlayers = [ScheduledPlayer]()
		self.scheduledPlayersNames = [UUID]()
    }
    
    func schedulePlayer(s: ScheduledPlayer) {
        if self.scheduledPlayers!.contains(s) {
            return// already there
        }
        self.scheduledPlayers!.append(s)
        s.scheduledWeeks += 1
        
    }
	
	func unSchedulePlayer(s: ScheduledPlayer) {
		if let index = self.scheduledPlayers!.firstIndex(of: s) {
			self.scheduledPlayers!.remove(at: index)
			s.scheduledWeeks -= 1
		}
		
	}
	
	func isScheduled(s: ScheduledPlayer) ->Bool {
		return(self.scheduledPlayers!.contains(s))
	}
	
	func isNotScheduled(s: ScheduledPlayer) ->Bool {
		return(self.isScheduled(s: s) == false)
	}
//
//	couldSchedule checks to see if the playweek is blocked by the player regardless of whether the playweek is full.
//
	func couldSchedule(s: ScheduledPlayer) ->Bool {
		return self.isNotScheduled(s: s) && s.blockedDays.contains(self.date) == false
	}
//
//	canSchedule says the week is not blocked and there is room to schedule
//
	func canSchedule(s: ScheduledPlayer) ->Bool {
// test for blocked days
		return (self.scheduledPlayers!.count < Constants.minimumNumberOfPlayers && self.couldSchedule(s:s))
	}
	
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        var s: String = dateFormatter.string(from: self.date) + "\t"
        s += "(\(scheduledPlayers!.count))"
        if(scheduledPlayers != nil && scheduledPlayers!.count > 0){
			for sp in scheduledPlayers! { s = s + "\(sp.name), "}
        } else {
            s += "no players scheduled"
        }
        s += "\n"
        return s
    }
	

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scheduledPlayersNames = try (container.decodeIfPresent([UUID].self, forKey: .scheduledPlayers) ?? nil)!
        let when: String? = try (container.decodeIfPresent(String.self, forKey: .date) ?? nil)
        if when != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            self.date = dateFormatter.date(from: when!)!
        } else {
            throw PlayWeekError.invalidDate
        }
        if self.scheduledPlayersNames == nil { self.scheduledPlayersNames = [UUID]()}
		self.scheduledPlayers = [ScheduledPlayer]()	// create empty array.  after the schedule has been completely read in, we will go back
											// and cfill this in the with Player class that matches the name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        try container.encode(dateFormatter.string(from: self.date), forKey: .date)
		try container.encode(scheduledPlayersNames, forKey: .scheduledPlayers)
    }
	
}
