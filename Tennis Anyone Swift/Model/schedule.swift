//
//  schedule.swift
//  TennisSchedulerSwift
//
//  Created by George Breen on 9/19/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
class Schedule: Codable, CustomStringConvertible, ObservableObject {
    @Published var startDate: Date = Date()       // date of first week
    @Published var endDate: Date = Date()          // date of last week inclusive
    @Published var buildDate: Date = Date()
    var courtMinutes: Int? = 90      // how long is court time each week
    @Published var playWeeks: [PlayWeek]? = [PlayWeek]()
    @Published var blockedDays: [Date] = [Date]()    // weeks courts are closed (e.g. Thanksgiving)
    @Published var players:[Player] = [Player]()      // all of the members
    @Published var isBuilt: Bool = false   // is it built?
    var numBadWeeks: Int = 0           // after a build, # weeks that don't have the proper numberof players
    @Published var venues:[Venue] = [Venue]()    // possible locations
    @Published var currentVenue = UUID()
    @Published var isDoubles = true
    @Published var errorString = ""
    @Published var scheduledPlayers: [ScheduledPlayer] = [ScheduledPlayer]()  // which players are scheduled for this contract time
    @Published var  rkManager = RKManager(startDate: Date(), endDate: Date(), closedDates: [Date](), blockedDates: [Date]())

    
    enum CodingKeys: CodingKey {
        case startDate, endDate, buildDate, courtMinutes, playWeeks, blockedDays, isBuilt, players, venues, currentVenue, isDoubles, scheduledPlayers
    }
    
//  MARK: String
    
    var description: String {
        var s: String = ""
        for player in scheduledPlayers  {
            s += "\(String(describing: player))\n"
        }
        s += "\n"
        for i in 0 ... 3 {
            s += "  "
            for player in scheduledPlayers  {
                s += String(Array(player.name)[i]) + " "
            }
            s += "\n"
        }

        if playWeeks != nil {
            for pw in playWeeks! {
                if pw.scheduledPlayers!.count < Constants.minimumNumberOfPlayers {
                    s += "🥵"
                } else {
                    s += "  "
                }
                for scheduledPlayer in scheduledPlayers {
                    if pw.isScheduled(s: scheduledPlayer) {
                        s += "O"
                    } else if pw.couldSchedule(s: scheduledPlayer) {
                        s += "."
                    } else {
                        s += "X"
                    }
                    s += " "
                }
                s += "\t\(String(describing: pw))"
            }
            s += "\n"
        }
        return s
    }
    
    var html: String {
        var s: String = """
        <!doctype html>
        <html>
        <head>
        <title>Schedule</title>
        </head>
        <style>
        .error {
            color: .red
        }
        .normal {
            color: .gray
        }
        </style>
        <body>
        <h1>Contract Schedule</h1>
        """
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        s += "<h2>Schedule built:\(dateFormatter.string(from: self.buildDate))</h2>"

        dateFormatter.timeStyle = .none
        s += "\(self.venues.first(where: {$0.id == self.currentVenue})?.html ?? "Unknown")<br/>"
        s += "Play time:<br/>"
        s += "First Date: \(dateFormatter.string(from:self.startDate))<br/>"
        s += "Last Date: \(dateFormatter.string(from:self.endDate))<br/>"
        s += "Total Playing Weeks: \(self.playWeeks!.count)<br/>"

        
//
//  Players
//
        s +=
        """
        <h1>Players</h1>
        <table border="1">
            <tr>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Desired % playing time</th>
                <th>Number of Weeks</th>
            </tr>
        """
        
        for sp in scheduledPlayers {
            let p = players.first(where:{$0.id == sp.playerId})
            let phoneStr = p?.phone
            let nameStr = p?.name
            s += "<tr><td>\(nameStr ?? "")</td><td>\(phoneStr ?? "")</td><td>\(p!.email)</td><td>\(sp.percentPlaying)</td><td>\(sp.numWeeks)</td></tr>"
        }
        s += "</table>"

        

//
//  Weekly Schedule
//
        s += """
        <h1>Weekly Schedule</h1>
        <table border="1">
            <tr>
                <th>Date</th>
                <th>Players</th>
            </tr>
        """
        

        var thisWeek: Date = self.startDate
        while thisWeek < self.endDate {
            if self.blockedDays.contains(thisWeek) == false {      // as long as the facility is open
                let pw = self.playWeeks?.first(where: {$0.date == thisWeek})
                if( pw != nil) {
                    s += "<tr"
                    if pw?.scheduledPlayers!.count != ((self.isDoubles) ? 4: 2 ){
                        s += " bgcolor = \"#ffa0a0\""
                    }
                    s += "><td>\(dateFormatter.string(from: thisWeek))</td><td>"
                    for scheduledPlayer in pw!.scheduledPlayers! {
                        s += scheduledPlayer.name
                        s += ", "
                    }
                    var unavailStr = "(Unavailable:"
                    var hasUnavail = false
                    for scheduledPlayer in scheduledPlayers {
                         if pw!.isBlocked(s: scheduledPlayer) {
                             unavailStr += "\(scheduledPlayer.name), "
                            hasUnavail = true
                         }
                    }
                    if hasUnavail {
                        s += unavailStr + ")"
                    }
                }
            } else {
                s += "<tr bgcolor = \"#a0a0a0\"><td>\(dateFormatter.string(from: thisWeek))</td><td>Closed</span>"
            }
            s += "</td></tr>"
            thisWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: thisWeek)!
        }

        s += "</table>"
        
        s += """
            </body>
            </html>
        """
        
        return s
        
    }
    
    enum ScheduleError: Error {
        case noStartDate(String)
        case noEndDate(String)
        case startDateAfterEndDate(String)
    }
    
    func FindPlayer(uuid:UUID) ->ScheduledPlayer? {
        for s in self.scheduledPlayers {
            if s.id == uuid {
                return s;
            }
        }
        return nil
    }
 // MARK: Init
    
    required init() {
#if DEBUG
        self.venues.append(Venue.example)
        self.players.append(Player.example)
        self.isDoubles = true
        self.scheduledPlayers.append(ScheduledPlayer(player: self.players[0], id: UUID(), blockedDays: [Date](), percentPlaying: 100.0))
#endif
        
    }
    
    func validNumberOfPlayers()->Bool {
        return (self.players.count >= (self.isDoubles ? 4 : 2))
    }
    
    func validNumberOfScheduledPlayers()->Bool {
        return (self.scheduledPlayers.count >= (self.isDoubles ? 4 : 2))
    }
    
    func validDates()->Bool {
        return self.endDate >= self.startDate
    }
    func validSchedule()->Bool {
        return self.validDates() && self.validNumberOfPlayers()
        
    }
    func validateForm()  {
        
        self.errorString = ""

        if (!self.validDates()) {
            self.errorString = "Correct the start and end dates"
            return
        }
        let diffInDays = Calendar.current.dateComponents([.day], from: self.startDate, to: self.endDate).day!
        
        if (diffInDays < 7) {
            self.errorString = "Set the end date to be at least a week after the start date"
            return
        }
        
        if (!self.validNumberOfScheduledPlayers()) {
            self.errorString = "Add more players to this contract schedule below"
        }
        
        if (!self.validNumberOfPlayers()) {
            self.errorString = "Add more tennis players to contacts screen"
        }
        
    }

    func returnNumberOfPlayweeks()->Int {
        var numweeks = 0
        if(self.validDates() == false) {
            return numweeks
        }
        var thisWeek: Date = self.startDate
        while thisWeek < self.endDate {
            if self.blockedDays.contains(thisWeek) == false {      // as long as the facility is open
                numweeks += 1
            }
            thisWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: thisWeek)!
        }
        return numweeks

    }
    
    //
    //  remove the old schedule and whatever is needed prior to calling BuildSchedule
    //
    func prepareForBuild() {
        self.isBuilt = false
        if (self.playWeeks != nil) {
            self.playWeeks!.removeAll()
        } else {
            self.playWeeks = [PlayWeek]()   // wipe out the schedule
        }
        self.numBadWeeks = 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var when: String? = try (container.decodeIfPresent(String.self, forKey: .startDate) ?? nil)
        
        if when != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            self.startDate = dateFormatter.date(from: when!)!
        } else {
            throw ScheduleError.noStartDate("No Start Date")
        }
        
        when = try (container.decodeIfPresent(String.self, forKey: .endDate) ?? nil)
        if when != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            self.endDate = dateFormatter.date(from: when!)!
        } else {
            throw ScheduleError.noEndDate("No End Date")
        }
        
        if self.endDate < self.startDate {throw ScheduleError.startDateAfterEndDate("End Date before Start Date")}
        
        self.buildDate = try (container.decodeIfPresent(Date.self, forKey: .buildDate) ?? Date())

        self.courtMinutes = try (container.decodeIfPresent(Int.self, forKey: .courtMinutes) ?? Constants.defaultCourtMinutes)
        self.playWeeks = try (container.decodeIfPresent([PlayWeek].self, forKey: .playWeeks) ?? nil)
        self.players = try (container.decodeIfPresent([Player].self, forKey: .players) ?? nil)!
        self.scheduledPlayers = try (container.decodeIfPresent([ScheduledPlayer].self, forKey: .scheduledPlayers) ?? [ScheduledPlayer]())
        self.venues = try (container.decodeIfPresent([Venue].self, forKey: .venues) ?? nil)!
        self.currentVenue = try (container.decodeIfPresent(UUID.self, forKey: .currentVenue) ?? self.venues[0].id)!
        self.isBuilt = try (container.decodeIfPresent(Bool.self, forKey: .isBuilt) ?? false)
        self.isDoubles = try (container.decodeIfPresent(Bool.self, forKey: .isDoubles) ?? true)
        let allDates: [String]? = try container.decodeIfPresent([String].self, forKey: .blockedDays) ?? nil
        if(self.playWeeks != nil) {
            for pw in self.playWeeks! {
                pw.scheduledPlayers = pw.scheduledPlayersNames!.map{ self.FindPlayer(uuid:$0)! }
            }
        }
        self.blockedDays = [Date]()
        if allDates != nil { // convert array of date strings to array of dates using formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            self.blockedDays = allDates!.compactMap { dateFormatter.date(from: $0) }
        }

        self.rkManager.setParams(startDate: self.startDate, endDate: self.endDate, blockedDates: self.blockedDays)


    }
//  MARK: Find Slot
//  FindSlot attempts to find a an avaiable week to schedule this player.  We randomly select a week to start and then walk through the PlayWeeks from there.
//  If we find a week that still needs a player, that does not already have this player and the PlayWeek is not in the PLayer's blocked weeks, return.
//
//  If that doesn't work (usually towards the end), then let's find a week that is completely filled and the player is already scheduled to play and swap him ou
//  with another viable week.  Once he's ben swapepd out, we can add him to this week.
//
//  If that fails, give up.
//

    func findSlot(s: ScheduledPlayer) ->PlayWeek? {
        var index = Int.random(in: 0 ..< self.playWeeks!.count)
        var maxloop = self.playWeeks!.count
//
//  First, randomly pick a slot and see if there is an opening, that p is not already scheduled in here and that p can
//  be scheduled here (not in p's blockedDays list.  If so, we found our slot.  Else, keep walking through the playweeks
//  and find the first week that matches this criteria.
//
        while maxloop > 0 {
            // Keep trying until we exhaust all slots
            // This slot is good only if: there are less than 4 players assigned, this player is not already assigned,
            // this week is not in the player's blocked weeks
            
            maxloop -= 1
            let pw = self.playWeeks![index]
            if pw.scheduledPlayers!.count < Constants.minimumNumberOfPlayers &&
            pw.isNotScheduled(s: s) &&
            pw.canSchedule(s: s) {
                return pw
            }
            index = (index + 1) % self.playWeeks!.count
        }
//
//  If we get here, there are probably PlayWeeks that have less than min players bt already have this player scheduled.
//  Let's try to swap this player on the short week, with another player from a week that doesn't contain player.
//
        maxloop = self.playWeeks!.count
        var fromIndex:Int = -1
        var sourceWeek: PlayWeek
        
        while(maxloop > 0) {
            maxloop -= 1
            sourceWeek = self.playWeeks![index]
            if sourceWeek.couldSchedule(s: s) {     // see if we could schedule p here if it were not already full.
// we found a slot that has all of the players booked.  now lets see if we can move one of the scheduled players to anoher seek to make room for this
//  player.
                fromIndex = index
                break
            }
            
            index = (index + 1) % self.playWeeks!.count
        }
        
        if fromIndex == -1 {
            print("***Couldn't find another week to swap this player with***")
            return nil
        }
//
//  Now, for each of the players in the source week, try to find another week to move them to in order to create room for Player p.
//
        sourceWeek = self.playWeeks![fromIndex]
        for swapPlayer in sourceWeek.scheduledPlayers! {
            
            maxloop = self.playWeeks!.count-1
            index = (fromIndex + 1) % self.playWeeks!.count
            
            while maxloop > 0 {
                
                let dstWeek = self.playWeeks![index]

                if dstWeek.canSchedule(s: swapPlayer) { // there is room and swapPlayer is not scheduled.
                        sourceWeek.unSchedulePlayer(s: swapPlayer)
                        dstWeek.schedulePlayer(s: swapPlayer)
                        return findSlot(s: s)  // ok, we should have successfully moved a player and created a slot for p.
                    
                }
                maxloop -= 1
                index = (index + 1) % self.playWeeks!.count

            }
        }
        return nil
    }
    
    func getBlockedPlayers(pw: PlayWeek) ->[ScheduledPlayer]
    {
        var blockedPlayers = [ScheduledPlayer]()
        for s in self.scheduledPlayers {
           if pw.isBlocked(s:s) {
                blockedPlayers.append(s)
            }
        }
        return (blockedPlayers)
    }
    
    func getBlockedPlayersImages(pw: PlayWeek) ->[UIImage]
    {
        let blockedPlayers: [ScheduledPlayer] = self.getBlockedPlayers(pw: pw)
        let blockedPlayerIDs: [UUID] = blockedPlayers.map{ $0.playerId}
        var retimg:[UIImage] = [UIImage]()
        
        for bpid in blockedPlayerIDs {
            let p = self.players.first(where: {$0.id == bpid})
            retimg.append(p!.profilePicture!)
        }
        return retimg
    }
    
    // MARK: BuildSchedule
    
    func BuildSchedule() throws {
 
        if isBuilt {return}
        
        if  self.scheduledPlayers.count < Constants.minimumNumberOfPlayers {
            throw ScheduleError.startDateAfterEndDate("Need " + String(Constants.minimumNumberOfPlayers) + " players and there are only " + String(self.scheduledPlayers.count))
        }
                

       //
       self.playWeeks = [PlayWeek]()
       var thisWeek: Date = self.startDate
       while thisWeek < self.endDate {
           if self.blockedDays.contains(thisWeek) == false {      // as long as the facility is open
               self.playWeeks!.append(PlayWeek(date:thisWeek))
           }
           thisWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: thisWeek)!
           }
 //
//  figure out how many weeks each person gets to play this season.  This is a function of how many players there are (e.g. if four players,
//  everyone plays every week.  If 6 players, everyone plays 4 out of 6 weeks.  We also factor in the playing percentage weight.
//  a value of 1.0 means this is a full time player - this affects the player's cost and the nujmber of weeks they get to play.  a .5 means they
//  play half as many weeks as a 1.0 weighted player.  The individual's cost will be calculated based on the total number of weeks each person plays
//
        var totalweight = 0.0
        for s in self.scheduledPlayers {
            totalweight += s.percentPlaying
        }
        let unweightedWeeksPlying: Double = Double(Constants.minimumNumberOfPlayers * self.playWeeks!.count)
        for s in self.scheduledPlayers {
            let weightedBias:Double = (s.percentPlaying * unweightedWeeksPlying) / totalweight
            s.numWeeks = Int(weightedBias.rounded())
        }
//
//  Becase of rounding errors, we may need to tweak individual's playing weeks up or down one to align with the actual number
//  of playing slots available.
//

        let playingslots = Constants.minimumNumberOfPlayers * self.playWeeks!.count
        var calculatedSlots = 0
        
        for s in self.scheduledPlayers {
            calculatedSlots += s.numWeeks
        }
        if playingslots != calculatedSlots {
            print("Actual Slots = \(playingslots) but calculated slots = \(calculatedSlots)")
            var index =  Int.random(in: 0 ..< self.scheduledPlayers.count)
            while calculatedSlots < playingslots {
                let s = self.scheduledPlayers[index]
                s.numWeeks += 1
                calculatedSlots += 1
                index = (index + 1) % self.scheduledPlayers.count
            }
            while calculatedSlots > playingslots {
                let s = self.scheduledPlayers[index]
                s.numWeeks -= 1
                calculatedSlots -= 1
                index = (index + 1) % self.scheduledPlayers.count
            }
        }
                //
        //  Validate PlayWeeks.  If there is nothing in the Playweek, create the array
        for pw in self.playWeeks! {
            pw.scheduledPlayers = pw.scheduledPlayersNames!.map{ self.FindPlayer(uuid:$0)! }
        }
        
        for s in self.scheduledPlayers {
            for _ in 0 ..< s.numWeeks {
                for _ in 0 ... Constants.maxTries {
                    let pw = self.findSlot(s: s)
                    if pw != nil {
                        pw?.schedulePlayer(s: s)
                        break;
                    }
                }
            }
        }
        
        for _ in 0 ..< Constants.scrambleCount {
            let srcweek = self.playWeeks![Int.random(in: 0 ..< self.playWeeks!.count)]
            let dstweek = self.playWeeks![Int.random(in: 0 ..< self.playWeeks!.count)]
            let srcplayer = self.scheduledPlayers[Int.random(in: 0 ..< self.scheduledPlayers.count)]
            let dstplayer = self.scheduledPlayers[Int.random(in: 0 ..< self.scheduledPlayers.count)]
            
            if dstweek.isNotScheduled(s: srcplayer) &&
                dstweek.canSchedule(s: srcplayer) &&
                srcweek.isNotScheduled(s: dstplayer) &&
                srcweek.canSchedule(s: dstplayer) {
                
                    srcweek.unSchedulePlayer(s: srcplayer)
                    srcweek.schedulePlayer(s: dstplayer)
                    dstweek.unSchedulePlayer(s: dstplayer)
                    dstweek.schedulePlayer(s: srcplayer)
            }
        }
        
        let numplayers = (isDoubles) ? 4 : 2
        
        for pw in self.playWeeks! {
            if pw.scheduledPlayers!.count < numplayers {
                self.numBadWeeks += 1
            }
        }
        
        self.isBuilt = true
        self.buildDate = Date() // now
    }
    
  // MARK: decode
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        try container.encode(dateFormatter.string(from: self.startDate), forKey: .startDate)
        try container.encode(dateFormatter.string(from: self.endDate), forKey: .endDate)
        try container.encode(buildDate, forKey: .buildDate)
        try container.encode(courtMinutes, forKey: .courtMinutes)
        try container.encode(isBuilt, forKey: .isBuilt)
        try container.encode(isDoubles, forKey: .isDoubles)
        if playWeeks != nil {
            for pw in playWeeks! {
                pw.scheduledPlayersNames = pw.scheduledPlayers!.map{ $0.id}
            }
        }
        try container.encode(playWeeks, forKey: .playWeeks)
        try container.encode(players, forKey: .players)
        try container.encode(scheduledPlayers, forKey: .scheduledPlayers)
        try container.encode(venues, forKey: .venues)
        try container.encode(currentVenue, forKey: .currentVenue)
        if blockedDays.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let addDateStr = self.blockedDays.map{ dateFormatter.string(from: $0) }
            try container.encode(addDateStr, forKey: .blockedDays)
        }
    }
    
    func saveJson() throws {

        let jsonEncoder = JSONEncoder()
        var jsonData = Data()
        jsonData = try jsonEncoder.encode(self)  // now reencode the data
        let jsonString = String(data: jsonData, encoding: .utf8)!
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(Constants.jsonFileName)

            //writing

            try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
        }

    }
 
}

