//
//  venue.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/17/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation

class Venue: CustomStringConvertible, Codable, Equatable, Identifiable, ObservableObject {

    enum CodingKeys: CodingKey {
        case id, name, phone, email
    }

    var id = UUID()
    @Published var email: String = ""
    @Published var phone = ""
    @Published var name: String = ""

        
    init(id: UUID? = UUID(),
         name: String? = "",
        email: String? = "",
        phone: String? = "") {
            self.id = id!
            self.name = name!
            self.email = email!
            self.phone = phone!

     }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
    static func == (pl1: Venue, pl2: Venue) -> Bool {
        return
            pl1.id == pl2.id
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(phone, forKey: .phone)
        try container.encode(email, forKey: .email)
    }

    var description: String {
        return "Venue: \(self.name), phone: \(self.phone). email: \(self.email)"
    }
    #if DEBUG
        static let example = Venue(id: UUID(), name: "Tennis Place",  phone: "215-555-1212")
    #endif

}

