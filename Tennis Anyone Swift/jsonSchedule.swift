//
//  jsonSchedule.swift
//  TennisSchedulerSwift
//
//  Created by George Breen on 9/19/19.
//  Copyright © 2019 George Breen. All rights reserved.
//


let jsonSchedule = """
  {
      "venues": [{
          "email": "radnor.com",
          "id": "D68FE878-67FD-43DB-89D4-B614BBF2B116",
          "phone": "1-800-radnorr",
          "name": "Radnor Racquet Club"
      }, {
          "email": "",
          "id": "F24315EF-35C1-445B-A5D7-94E809EFAFD8",
          "phone": "",
          "name": "Thomas WIlliams"
      }, {
          "email": "",
          "id": "258FED10-39D4-4C81-97EE-96C49427E0A7",
          "phone": "",
          "name": "Brigantine Courts"
      }],
      "playWeeks": [{
          "date": "09/13/18",
          "scheduledPlayers": ["Hedley LaMar", "Bart", "Mongo", "Howard Johnson"]
      }, {
          "date": "09/20/18",
          "scheduledPlayers": ["Bart", "Mongo", "Howard Johnson", "Lilli Von Shtupp"]
      }, {
          "date": "09/27/18",
          "scheduledPlayers": ["Bart", "Mongo", "Lilli Von Shtupp", "The Gov"]
      }, {
          "date": "10/04/18",
          "scheduledPlayers": ["Hedley LaMar", "Waco Kid", "Bart", "Mongo"]
      }, {
          "date": "10/11/18",
          "scheduledPlayers": ["Hedley LaMar", "Bart", "Mongo", "Howard Johnson"]
      }, {
          "date": "10/18/18",
          "scheduledPlayers": ["Lilli Von Shtupp", "Gabby", "The Gov", "Waco Kid"]
      }, {
          "date": "10/25/18",
          "scheduledPlayers": ["Waco Kid", "Bart", "Lilli Von Shtupp", "Gabby"]
      }, {
          "date": "11/01/18",
          "scheduledPlayers": ["Hedley LaMar", "Bart", "Howard Johnson", "Lilli Von Shtupp"]
      }, {
          "date": "11/08/18",
          "scheduledPlayers": ["Hedley LaMar", "Waco Kid", "Mongo", "Howard Johnson"]
      }, {
          "date": "11/15/18",
          "scheduledPlayers": ["Mongo", "Howard Johnson", "Lilli Von Shtupp", "The Gov"]
      }, {
          "date": "11/22/18",
          "scheduledPlayers": ["Hedley LaMar", "Waco Kid", "Mongo", "Howard Johnson"]
      }, {
          "date": "11/29/18",
          "scheduledPlayers": ["Hedley LaMar", "Howard Johnson", "Gabby", "The Gov"]
      }, {
          "date": "12/06/18",
          "scheduledPlayers": ["Hedley LaMar", "Bart", "Howard Johnson", "Gabby"]
      }, {
          "date": "12/13/18",
          "scheduledPlayers": ["Bart", "Howard Johnson", "Lilli Von Shtupp", "Gabby"]
      }, {
          "date": "12/20/18",
          "scheduledPlayers": ["Waco Kid", "Bart", "Gabby", "The Gov"]
      }, {
          "date": "01/03/19",
          "scheduledPlayers": ["Hedley LaMar", "Waco Kid", "Gabby", "The Gov"]
      }, {
          "date": "01/10/19",
          "scheduledPlayers": ["Bart", "Lilli Von Shtupp", "The Gov", "Hedley LaMar"]
      }, {
          "date": "01/17/19",
          "scheduledPlayers": ["Hedley LaMar", "Lilli Von Shtupp", "Gabby", "The Gov"]
      }, {
          "date": "01/24/19",
          "scheduledPlayers": ["Waco Kid", "Howard Johnson", "Lilli Von Shtupp", "Gabby"]
      }, {
          "date": "01/31/19",
          "scheduledPlayers": ["Waco Kid", "Mongo", "Howard Johnson", "Lilli Von Shtupp"]
      }, {
          "date": "02/07/19",
          "scheduledPlayers": ["Waco Kid", "Mongo", "Lilli Von Shtupp", "Gabby"]
      }, {
          "date": "02/14/19",
          "scheduledPlayers": ["Bart", "Howard Johnson", "The Gov", "Hedley LaMar"]
      }, {
          "date": "02/21/19",
          "scheduledPlayers": ["Lilli Von Shtupp", "The Gov", "Hedley LaMar", "Waco Kid"]
      }, {
          "date": "02/28/19",
          "scheduledPlayers": ["Bart", "Lilli Von Shtupp", "Gabby", "The Gov"]
      }, {
          "date": "03/07/19",
          "scheduledPlayers": ["Bart", "Mongo", "Howard Johnson", "The Gov"]
      }, {
          "date": "03/14/19",
          "scheduledPlayers": ["Waco Kid", "Howard Johnson", "Lilli Von Shtupp", "The Gov"]
      }, {
          "date": "03/21/19",
          "scheduledPlayers": ["Waco Kid", "Mongo", "Gabby", "The Gov"]
      }, {
          "date": "03/28/19",
          "scheduledPlayers": ["Bart", "Gabby", "The Gov", "Hedley LaMar"]
      }, {
          "date": "04/04/19",
          "scheduledPlayers": ["Hedley LaMar", "Mongo", "Gabby", "The Gov"]
      }, {
          "date": "04/11/19",
          "scheduledPlayers": ["Waco Kid", "Mongo", "Howard Johnson", "Gabby"]
      }, {
          "date": "04/18/19",
          "scheduledPlayers": ["Hedley LaMar", "Waco Kid", "Mongo", "Lilli Von Shtupp"]
      }, {
          "date": "04/25/19",
          "scheduledPlayers": ["Waco Kid", "Bart", "Mongo", "Gabby"]
      }],
      "endDate": "05/02/19",
      "startDate": "09/13/18",
      "currentVenue": "D68FE878-67FD-43DB-89D4-B614BBF2B116",
      "players": [{
          "email": "unknown",
          "id": "BEB6E19F-F88A-4149-990C-4A464E9D075A",
          "phone": "unknown",
          "name": "Hedley LaMar"
      }, {
          "email": "",
          "id": "00794D70-E5C6-4455-92E4-26FDBCA9024B",
          "phone": "",
          "name": "Waco Kid"
      }, {
          "email": "",
          "id": "B843C4DB-4FB8-4B28-BBD3-E3E20317992F",
          "phone": "",
          "name": "Bart"
      }, {
          "email": "",
          "id": "D04019F4-0CFC-430B-BDA5-77F40D72B64D",
          "phone": "",
          "name": "Mongo"
      }, {
          "email": "",
          "id": "D467F3EF-8C74-4F93-977C-6EA8219F2259",
          "phone": "",
          "name": "Howard Johnson"
      }, {
          "email": "",
          "id": "E4651BD9-69A5-498B-BC2E-A0C61B587D77",
          "phone": "",
          "name": "Lilli Von Shtupp"
      }, {
          "email": "",
          "id": "EBAA0B3E-5317-48D8-859C-88DF45BE9B83",
          "phone": "",
          "name": "Gabby"
      }, {
          "email": "",
          "id": "D0BC9AAB-85B9-4624-ACF8-208609DB7D3D",
          "phone": "",
          "name": "The Gov"
      }],
      "isBuilt": true,
      "blockedDays": ["12/27/18"],
      "isDoubles": true,
      "scheduledPlayers": [{
          "id": "9E00A810-3D03-4F24-8F8E-6E436B462D48",
          "playerId": "BEB6E19F-F88A-4149-990C-4A464E9D075A",
          "percentPlaying": 100,
          "name": "Hedley LaMar",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "2D81327F-A805-49D7-BA89-B3D56B632BF8",
          "playerId": "00794D70-E5C6-4455-92E4-26FDBCA9024B",
          "percentPlaying": 100,
          "name": "Waco Kid",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "DB6899D7-B52D-41B3-AA9A-C88A44A08BE6",
          "playerId": "B843C4DB-4FB8-4B28-BBD3-E3E20317992F",
          "percentPlaying": 100,
          "name": "Bart",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "DC254F4B-55F1-45EE-A453-D5E15FFB1F96",
          "playerId": "D04019F4-0CFC-430B-BDA5-77F40D72B64D",
          "percentPlaying": 100,
          "name": "Mongo",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "2B379C78-1D38-471C-8172-ED4BBC395F4C",
          "playerId": "D467F3EF-8C74-4F93-977C-6EA8219F2259",
          "percentPlaying": 100,
          "name": "Howard Johnson",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "10892BA1-60A9-4B6C-B2C9-3AE7EF7CFE21",
          "playerId": "E4651BD9-69A5-498B-BC2E-A0C61B587D77",
          "percentPlaying": 100,
          "name": "Lilli Von Shtupp",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "0F12E53E-4801-4829-B00B-5D2121B18239",
          "playerId": "EBAA0B3E-5317-48D8-859C-88DF45BE9B83",
          "percentPlaying": 100,
          "name": "Gabby",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }, {
          "id": "2590F4D8-A518-408B-B222-C0CF90701544",
          "playerId": "D0BC9AAB-85B9-4624-ACF8-208609DB7D3D",
          "percentPlaying": 100,
          "name": "The Gov",
          "numWeeks": 16,
          "scheduledWeeks": 16
      }],
      "courtMinutes": 90
  }
""".data(using: .utf8)!
/*

 "MemberDues" : 120.00,
 "MemberDuesNeeded":  4,
 "HourlyCourtCost" :  80.00
 
 */
