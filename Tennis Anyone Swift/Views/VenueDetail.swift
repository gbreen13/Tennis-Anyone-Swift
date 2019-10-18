//
//  VenueDetail.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/17/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI
import Contacts
import SwiftUI
import os

class ContactStore: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var error: Error? = nil

    func fetch() {
        os_log("Fetching contacts")
        do {
            let store = CNContactStore()
            let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                               CNContactMiddleNameKey as CNKeyDescriptor,
                               CNContactFamilyNameKey as CNKeyDescriptor,
                               CNContactImageDataAvailableKey as CNKeyDescriptor,
                               CNContactImageDataKey as CNKeyDescriptor]
            os_log("Fetching contacts: now")
            let containerId = store.defaultContainerIdentifier()
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            os_log("Fetching contacts: succesfull with count = %d", contacts.count)
            self.contacts = contacts
        } catch {
            os_log("Fetching contacts: failed with %@", error.localizedDescription)
            self.error = error
        }
    }
}

extension CNContact: Identifiable {
    var name: String {
        return [givenName, middleName, familyName].filter{ $0.count > 0}.joined(separator: " ")
    }
}



struct ContactsView: View {
    @EnvironmentObject var store: ContactStore

    var body: some View {
        VStack{
            Text("Contacts")
            if store.error == nil {
                List(store.contacts) { (contact: CNContact) in
                    return Text(contact.name)
                }.onAppear{
                    DispatchQueue.main.async {
                        self.store.fetch()
                    }
                }
            } else {
                Text("error: \(store.error!.localizedDescription)")
            }
        }
    }
}

struct ContactsViewOrError: View {
    var body: some View {
        ContactsView().environmentObject(ContactStore())
    }
}

struct VenueDetail: View {
//    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var venue: Venue

    @EnvironmentObject var schedule: Schedule
    
    var venueIndex: Int {
        schedule.venues.firstIndex(where: { $0.id == venue.id })!
    }

//    @State var name: String = self.venue.name
    var body: some View {

        NavigationView {
            
            Form {
                TextField("Venue name", text: $schedule.venues[venueIndex].name)
                TextField("Phone Number", text: $schedule.venues[venueIndex].phone)
                TextField("Email", text: $schedule.venues[venueIndex].email)
            }
        }
        .navigationBarItems(trailing:
                NavigationLink(destination: ContactsView().environmentObject(ContactStore())) {
                    Text("Contacts")
                }
        )        .navigationBarTitle(Text("Venues"))

    }
}
