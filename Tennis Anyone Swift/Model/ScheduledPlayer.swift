//
//  ScheduledPlayer.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation

class ScheduledPlayer: CustomStringConvertible, Codable, Equatable, Identifiable, ObservableObject {

    enum CodingKeys: CodingKey {
        case id, playerId, name, blockedDays, percentPlaying, numWeeks, scheduledWeeks
    }
    

    var id: UUID  = UUID()       // id of this record
    var playerId: UUID = UUID()  // id of the player contac information

    var blockedDays:[Date]
    var percentPlaying: Double
    var numWeeks: Int = 0
    var scheduledWeeks: Int = 0
    var name:String

    init(player: Player,
        id: UUID? = UUID(),
        blockedDays: [Date]? = [Date](),
        percentPlaying: Double? = 100.0) {

            self.id = id!
            self.playerId = player.id
            self.name = player.firstName + player.lastName
            self.percentPlaying = percentPlaying!
            self.blockedDays = blockedDays!
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.playerId = try container.decodeIfPresent(UUID.self, forKey: .playerId) ?? UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.percentPlaying = try container.decodeIfPresent(Double.self, forKey: .percentPlaying) ?? 0.0
        self.numWeeks = try container.decodeIfPresent(Int.self, forKey: .numWeeks) ?? 0
        self.scheduledWeeks = try container.decodeIfPresent(Int.self, forKey: .scheduledWeeks) ?? 0
        let allDates: [String]? = try container.decodeIfPresent([String].self, forKey: .blockedDays) ?? nil
        self.blockedDays = [Date]()
        if allDates != nil { // convert array of date strings to array of dates using formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            self.blockedDays = allDates!.compactMap { dateFormatter.date(from: $0) }
            //           self.blockedDays!.forEach { print("\($0)") }
        }
    }

    static func == (pl1: ScheduledPlayer, pl2: ScheduledPlayer) -> Bool {
        return pl1.playerId == pl2.playerId
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(playerId, forKey: .playerId)
        try container.encode(name, forKey: .name)
        try container.encode(percentPlaying, forKey: .percentPlaying)
        try container.encode(numWeeks, forKey: .numWeeks)
        try container.encode(scheduledWeeks, forKey: .scheduledWeeks)
        if blockedDays.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let addDateStr = self.blockedDays.map{ dateFormatter.string(from: $0) }
            try container.encode(addDateStr, forKey: .blockedDays)
        }
    }

    var description: String {
        var s: String = name.padding(toLength: 18, withPad: " ", startingAt: 0)
        s += "\t \(numWeeks)\tBlocked Weeks: "
            if blockedDays.count <= 0 {
                s += "none"
            }
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy,"
                blockedDays.forEach { day in
                    s += dateFormatter.string(from: day)
                }
            }
            return s
        }
}
