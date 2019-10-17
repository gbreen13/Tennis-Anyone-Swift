//
//  player.swift
//  TennisSchedulerSwift
//
//  Created by George Breen on 9/19/19.
//  Copyright © 2019 George Breen. All rights reserved.
//


import Foundation

class Player: CustomStringConvertible, Codable, Equatable, Identifiable, ObservableObject {
    
    enum CodingKeys: CodingKey {
        case id, blockedDays, percentPlaying, name, numWeeks, scheduledWeeks, phone, email
    }
    
    var id: UUID
    @Published var blockedDays:[Date]?
    var percentPlaying: Double?
    @Published var email: String?
    @Published var phone: String?
    @Published var name: String?
    var numWeeks: Int? = 0
    var scheduledWeeks: Int = 0
     
    init(id: UUID? = UUID(),
     name: String? = nil,
     percentPlaying: Double? = 100.0,
     blockedDays: [Date]? = nil,
     email: String? = "",
        phone: String? = "") {
        self.id = id!
         self.name = name
         self.percentPlaying = percentPlaying
         if blockedDays != nil {
            self.blockedDays = blockedDays
         }
        self.email = email
        self.phone = phone

     }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "missing"
        self.percentPlaying = try container.decodeIfPresent(Double.self, forKey: .percentPlaying) ?? 0.0
        self.numWeeks = try container.decodeIfPresent(Int.self, forKey: .numWeeks) ?? 0
        self.scheduledWeeks = try container.decodeIfPresent(Int.self, forKey: .scheduledWeeks) ?? 0
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        let allDates: [String]? = try container.decodeIfPresent([String].self, forKey: .blockedDays) ?? nil
        self.blockedDays = [Date]()
        if allDates != nil { // convert array of date strings to array of dates using formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            self.blockedDays = allDates!.compactMap { dateFormatter.date(from: $0) }
            //           self.blockedDays!.forEach { print("\($0)") }
        }
    }
    
    static func == (pl1: Player, pl2: Player) -> Bool {
        return
            pl1.id == pl2.id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(percentPlaying, forKey: .percentPlaying)
        try container.encode(numWeeks, forKey: .numWeeks)
        try container.encode(scheduledWeeks, forKey: .scheduledWeeks)
        try container.encode(phone, forKey: .phone)
        try container.encode(email, forKey: .email)
        if blockedDays != nil && blockedDays!.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let addDateStr = self.blockedDays!.map{ dateFormatter.string(from: $0) }
            try container.encode(addDateStr, forKey: .blockedDays)
        }
    }
    
    var description: String {
        var s: String = name?.padding(toLength: 18, withPad: " ", startingAt: 0) ?? "unknown          "
        s += "\t \(numWeeks ?? 0)\tBlocked Weeks: "
        if blockedDays!.count <= 0 {
            s += "none"
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy,"
            blockedDays!.forEach { day in
                s += dateFormatter.string(from: day)
            }
        }
        return s
    }
    
#if DEBUG
    static let example = Player(id: UUID(), name: "Bobby Frey", percentPlaying: 100.0, blockedDays: [], phone: "215-555-1212")
#endif
}
