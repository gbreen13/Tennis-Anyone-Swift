//
//  HomeScreen.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/23/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var schedule: Schedule
    var body: some View {
        // 1
        TabView {
            // 2
          ContactsView()
                // 3
                .tabItem {
                    VStack {
                        Image(systemName: "1.circle")
                        Text("Contacts")
                    }
            // 4
            }.tag(1)
  
           // 5
            ScheduleView()
                .tabItem {
                    VStack {
                        Image(systemName: "2.circle")
                        Text("Schedule")
                    }
            }.tag(2)
         }

    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen().environmentObject(Schedule())
    }
}
