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

struct MyButtonStyle: ButtonStyle {
    var color: Color = .green
    
    public func makeBody(configuration: MyButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration, color: color)
    }
    
    struct MyButton: View {
        let configuration: MyButtonStyle.Configuration
        let color: Color
        
        var body: some View {
            
            return configuration.label
                .foregroundColor(.white)
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 5).fill(color))
                .compositingGroup()
                .shadow(color: .black, radius: 3)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        }
    }

}

struct ScheduleView: View {
    //    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    @EnvironmentObject var schedule: Schedule
    
    @State private var showingAlert = false
    @State private var showModal = false
    @State private var editMode: Bool = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var calIsPresented = false
    private var errorString: String = ""
    
    static let dayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    static let buildDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
                
        NavigationView {
            
            Form {
                
                if(self.schedule.isBuilt) {     // in Schedule Display mode

                    Button(action:  {self.generateSchedule()})
                    {
                        Text("Generate Schedule")
                    }.buttonStyle(MyButtonStyle(color: .blue))
                    .frame(alignment: .center)
                    
                    Text("Schedule Generation Date: \(self.schedule.buildDate, formatter: Self.buildDateFormat)")
                    if(!self.schedule.isSaved) {
                        WarningPrompt(errorString: "Schedule needs to be saved before it can be emailed out")
                    }

                    Section(header: Text("CONTRACT PLAYERS"))
                    {
                        ScheduledPlayersView()
                    }
                    
                    Section(header: Text("WEEKLY SCHEDULE (\(self.schedule.playWeeks!.count) weeks)")) {
                        WeeklyScheduleView()
                    }.foregroundColor ((self.schedule.numBadWeeks > 0) ? .red : .gray)
                    
                } else {                        // in Schedule Edit mode
                    if self.schedule.errorString  != "" {
                        ErrorPrompt(errorString: self.schedule.errorString)
                    } else {
                        Button(action:  {self.generateSchedule()})
                        {
                            Text("Generate Schedule")
                        }.buttonStyle(MyButtonStyle(color: .blue))
                            .frame(alignment: .center)
                    }

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
                            ScheduledPlayersSelectionView()
                                .environmentObject(self.schedule)
                        })
                    {
                        
                        ScheduledPlayersView()
                        
                    }
                }
            }
            .navigationBarTitle("Schedule")
//
//  If in Edit mode, There are no options on the screen
//  If the schedule is built then the options are to save if the file hasn't been saved.  If the file has been saved,
                
            .navigationBarItems(
                leading: Button(action: {
                    if(self.schedule.isBuilt && !self.schedule.isSaved) {   // save
                        do {
                            try self.schedule.saveJson()
                            self.schedule.isSaved = true
                        }
                        catch {}
                    } else  {                                               // email
                        self.isShowingMailView.toggle()
                        
                    }
                }) {
                    if(self.schedule.isBuilt && !self.schedule.isSaved) {
                        Text("Save")
                    } else {
                        Image(systemName: "square.and.arrow.up.on.square")
                    }
                } // disable the button if it is an email button AND can't email
                .disabled(!MFMailComposeViewController.canSendMail() && !(self.schedule.isBuilt && !self.schedule.isSaved))
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result).environmentObject(self.schedule)
                },
                trailing: Button(action: {
                    // put in edit mode
                    self.schedule.isBuilt = false;
                }
                ) {
                    Text("Edit")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(self.errorString), dismissButton: .default(Text("OK")))
                }
            ) .listStyle(GroupedListStyle())
        }
        .onAppear {
            self.schedule.rkManager.setParams(startDate: self.schedule.startDate, endDate: self.schedule.endDate, blockedDates: self.schedule.blockedDays)
            self.schedule.validateForm()
        }
        
        
    }
    
    func generateSchedule() {
        do {
            self.schedule.validateForm()
            if(self.showingAlert == false) {
                self.schedule.prepareForBuild()
                try self.schedule.BuildSchedule()
                let jsonEncoder = JSONEncoder()
                
                var jsonData = Data()
                jsonData = try jsonEncoder.encode(self.schedule)  // now reencode the data
                let jsonString = String(data: jsonData, encoding: .utf8)!
                self.schedule.isBuilt = true
                self.schedule.isSaved = false
                #if DEBUG
                print(jsonString)
                print(self.schedule as Any);
                #endif
            }
        } catch  {
            self.showingAlert = true
        }
        
    }

    
    func delete(at offsets: IndexSet) {
        self.schedule.blockedDays.remove(atOffsets: offsets)
        self.schedule.rkManager.blockedDates = self.schedule.blockedDays
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
