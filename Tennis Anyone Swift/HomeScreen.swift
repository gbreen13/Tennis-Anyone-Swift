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
    @State var selection = 1
    var body: some View {
        // 1

        TabView(selection: $selection) {
            // 2
          ContactsView()
                // 3
                .tabItem {
                    VStack {
                        selection == 1 ? Image("ContactsIcon_On").resizable().frame(width:40, height: 40) : Image("ContactsIcon_Off").resizable().frame(width:40, height: 40)
                        Text("Contacts")
                    }
            // 4
            }.tag(1)
  
           // 5
            ScheduleView()
                .tabItem {
                    VStack {
                        selection == 2 ? Image("ScheduleIcon_On").resizable().frame(width:40, height: 40) : Image("ScheduleIcon_Off").resizable().frame(width:40, height: 40)
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
