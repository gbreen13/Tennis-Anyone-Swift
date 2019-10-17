//
//  VenueDetail.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/17/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI



struct VenueDetail: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var venue: Venue
    @State var name: String = ""
    var body: some View {

        NavigationView {
            
            Form {
                TextField("Enter your name", text: $name)
            }
        }
        .navigationBarTitle(Text("Venues"))
    }
}
