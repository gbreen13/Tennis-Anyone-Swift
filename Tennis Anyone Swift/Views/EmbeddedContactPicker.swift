//
//  EmbeddedContactPicker.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 10/24/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import SwiftUI
import Contacts
import Combine
import UIKit
import ContactsUI

protocol EmbeddedContactPickerViewControllerDelegate: class {
    func embeddedContactPickerViewControllerDidCancel(_ viewController: EmbeddedContactPickerViewController)
    func embeddedContactPickerViewController(_ viewController: EmbeddedContactPickerViewController, didSelect contact: CNContact)
    func embeddedContactPickerViewController(_ viewController: EmbeddedContactPickerViewController, didSelect contacts: [CNContact])
}

class EmbeddedContactPickerViewController: UIViewController, CNContactPickerDelegate {
    weak var delegate: EmbeddedContactPickerViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.open(animated: animated)
    }

    private func open(animated: Bool) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
 //        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        self.present(contactPicker, animated: animated)
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true) {
            self.delegate?.embeddedContactPickerViewControllerDidCancel(self)
        }
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.dismiss(animated: true) {
            self.delegate?.embeddedContactPickerViewController(self, didSelect: contact)
        }
    }
    //  multiple selection
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        self.dismiss(animated: true) {
            self.delegate?.embeddedContactPickerViewController(self, didSelect: contacts)
        }
    }

}


struct EmbeddedContactPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = EmbeddedContactPickerViewController
    @EnvironmentObject var schedule: Schedule

    final class Coordinator: NSObject, EmbeddedContactPickerViewControllerDelegate {
        @Binding var selectedPlayers: [Player]?
        @Binding var dismissfunc:()->Void

        init(selectedPlayers: Binding<[Player]?>, dismissfunc: Binding<()->Void>) {
                   _selectedPlayers = selectedPlayers
                    _dismissfunc = dismissfunc
               }

        

        func embeddedContactPickerViewController(_ viewController: EmbeddedContactPickerViewController, didSelect contact: CNContact) {
            print("selected")
        }
        
        func contactPicker(_ picker: CNContactPickerViewController,
                           didSelect contacts: [CNContact]) {

            print("selected a bunch")
        }
        func embeddedContactPickerViewController(_ viewController: EmbeddedContactPickerViewController, didSelect contacts: [CNContact]) {
            print("selected")

            self.selectedPlayers = contacts.compactMap { Player(contact: $0) }
            self.dismissfunc()

        }

        func embeddedContactPickerViewControllerDidCancel(_ viewController: EmbeddedContactPickerViewController) {
            print("canceled")
        }
    }

    @Binding var selectedPlayers:[Player]?
    @Binding var dismissfunc:()->Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedPlayers: $selectedPlayers, dismissfunc: $dismissfunc)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<EmbeddedContactPicker>) -> EmbeddedContactPicker.UIViewControllerType {
        let result = EmbeddedContactPicker.UIViewControllerType()
        result.delegate = context.coordinator
        return result
    }

    func updateUIViewController(_ uiViewController: EmbeddedContactPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<EmbeddedContactPicker>) { }

}

