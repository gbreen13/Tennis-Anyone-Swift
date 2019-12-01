//
//  ContentView.swift
//  iDine
//
//  Created by George Breen on 10/9/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Combine
import SwiftUI
import MessageUI

enum ScheduleFormError: Error {
    case EndDateTooEarly
    case NoWeeksToSchedule
}

extension ScheduleFormError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .EndDateTooEarly:
            return NSLocalizedString("End date must be after start date", comment: "")
        case .NoWeeksToSchedule:
            return NSLocalizedString("Start and end dates must be at least one week apart", comment:"")
            
        }
    }
}


struct ScheduleView: View {
    //    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule
    
    @State private var showingAlert = false
    @State private var errorString = ""
    
    @State private var showModal = false
    private var editMode: Bool = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var calIsPresented = false
    
    static let dayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                
                if(!self.schedule.isBuilt) {
                    
                    ScheduleFirstSection()
                    
                    Section(header:
                        HStack {
                            Text("CLOSED DAYS")
                            Spacer()
                            Button(action: {self.calIsPresented.toggle()})
                            {
                                Image( systemName:"calendar")
                                    .font(.title)
                            }.sheet(isPresented: self.$calIsPresented,
                                    onDismiss:{self.schedule.blockedDays = self.schedule.rkManager.blockedDates},
                                        content: {
                                RKViewController(isPresented: self.$calIsPresented, rkManager: self.schedule.rkManager)}
                             )
                        }
                    ) {
                        List {
                            ForEach(self.schedule.blockedDays,id:\.self) { blocked in
                                Text("\(blocked, formatter: Self.dayDateFormat)")
                            }.onDelete(perform: delete)
                        }
                    }
                }
                Section(header:
                    HStack {
                        Text("CONTRACT PLAYERS")
                        Spacer()
                        if(!self.schedule.isBuilt) {
                            Button(action: { self.showModal.toggle() }) {
                                Image( systemName:"pencil")
                                    .font(.title)
                            }
                        }
                    }
                    .sheet(isPresented: $showModal){
                        //print("popover")
                        ScheduledPlayersSelectionView()
                            .environmentObject(self.schedule)
                    })
                {
                    
                    ScheduledPlayersView()
                }
                if(self.schedule.isBuilt) {
                    Section(header: Text("WEEKLY SCHEDULE (\(self.schedule.playWeeks!.count) weeks)")) {
                        WeeklyScheduleView()
                    }.foregroundColor ((self.schedule.numBadWeeks > 0) ? .red : .gray)
                }
            }
            .navigationBarTitle("Schedule")
                
            .navigationBarItems(
                leading: Button(action: {
                    self.isShowingMailView.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up.on.square")
                }
                .disabled(!MFMailComposeViewController.canSendMail() || !self.schedule.isBuilt)
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result).environmentObject(self.schedule)
                },
                trailing: Button(action: {
                    if(!self.schedule.isBuilt) {
                        do {
                            try self.validateForm()
                            
                            if(self.showingAlert == false) {
                                self.schedule.prepareForBuild()
                                try self.schedule.BuildSchedule()
                                let jsonEncoder = JSONEncoder()
                                
                                var jsonData = Data()
                                jsonData = try jsonEncoder.encode(self.schedule)  // now reencode the data
                                let jsonString = String(data: jsonData, encoding: .utf8)!
                                #if DEBUG
                                print(jsonString)
                                print(self.schedule as Any);
                                #endif
                            }
                        } catch  {
                            self.showingAlert = true
                            self.errorString = error.localizedDescription
                        }
                        
                    }
                    else {
                        self.schedule.prepareForBuild()
                    }
                }) {
                    if(!self.schedule.isBuilt) {
                        Text("Build")
                    } else {
                        Text("Edit")
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(self.errorString), dismissButton: .default(Text("OK")))
                }
            ) .listStyle(GroupedListStyle())
        }
        .onAppear {
            self.schedule.rkManager.setParams(startDate: self.schedule.startDate, endDate: self.schedule.endDate, blockedDates: self.schedule.blockedDays)
        }
        
        
    }
    
    
    func delete(at offsets: IndexSet) {
        self.schedule.blockedDays.remove(atOffsets: offsets)
        self.schedule.rkManager.blockedDates = self.schedule.blockedDays
    }
    
    func validateForm() throws {
        
        if (self.schedule.endDate < self.schedule.startDate) {
            throw(ScheduleFormError.EndDateTooEarly)
        }
        let diffInDays = Calendar.current.dateComponents([.day], from: self.schedule.startDate, to: self.schedule.endDate).day!
        
        if (diffInDays < 7) {
            throw(ScheduleFormError.NoWeeksToSchedule)
        }
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        return min...max
    }
    
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView().environmentObject(Schedule())
    }
}
