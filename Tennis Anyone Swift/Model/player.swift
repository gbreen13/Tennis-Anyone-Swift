//
//  player.swift
//  TennisSchedulerSwift
//
//  Created by George Breen on 9/19/19.
//  Copyright © 2019 George Breen. All rights reserved.
//


import Foundation
import UIKit
import Contacts
import Combine
import SwiftUI



class Player: CustomStringConvertible, Codable, Equatable, Identifiable, ObservableObject {
    
    enum CodingKeys: CodingKey {
        case id, blockedDays, percentPlaying, name, numWeeks, scheduledWeeks, phone, email, firstName, lastName, profilePicture
    }
    
    var id: UUID
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var name: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    var profilePicture: UIImage?
    var storedContact: CNMutableContact?
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
    static var colorIndex = 0

    
    func createProfilePicture() -> UIImage?    {
        let lblNameInitialize = UILabel()
        let flatColors = [0x55efc4, 0x74b9ff, 0xdfe6e9, 0x00cec9, 0x6c5ce7, 0xffeaa7, 0xff7675, 0x636e72,0xe17055, 0xe84393,
                          0x81ecec,0xa29bfe,0xfab1a0, 0xfd79a8]
        lblNameInitialize.frame.size = CGSize(width: Constants.defaultIconSize, height: Constants.defaultIconSize)
        lblNameInitialize.textColor = UIColor.white
        var s = ""
        if self.firstName.first != nil {
            s = String(self.firstName.first!)
        }
        if self.lastName.first != nil {
                s += String(self.lastName.first!)
        }

        if s == "" { s = "?"}
        lblNameInitialize.text = s
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor(rgb:flatColors[Player.self.colorIndex])
        Player.self.colorIndex = (Player.self.colorIndex+1) % flatColors.count
        lblNameInitialize.layer.cornerRadius = 50.0

        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if img == nil {
            img = UIImage(named: "PlaceholderProfilePic")
         }
        img = imageWithImage(image:img!, scaledToSize: CGSize(width:Constants.defaultIconSize,height:Constants.defaultIconSize))
        return img!
     }
    
    init(id: UUID? = UUID(),
     name: String? = "",
     email: String? = "",
        phone: String? = "",
        firstName: String? = "",
        lastName: String? = "",
        profilePicture: UIImage? = nil
    ) {
        self.id = id!
        self.name = name!
        self.email = email!
        self.phone = phone!
        self.firstName = firstName!
        self.lastName = lastName!
        if profilePicture != nil {self.profilePicture = imageWithImage(image:profilePicture!, scaledToSize: CGSize(width:Constants.defaultIconSize,height:Constants.defaultIconSize))}
        else { self.profilePicture = createProfilePicture()}
     }
    
    

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ??  UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        let imageStr: String? = try container.decodeIfPresent(String.self, forKey: .profilePicture) ?? nil
        if imageStr != nil {
            let decodedData : Data = Data(base64Encoded: imageStr!, options: .ignoreUnknownCharacters)!
            self.profilePicture = UIImage(data: decodedData)
        } else {
            self.profilePicture = createProfilePicture()
        }
        self.profilePicture = imageWithImage(image:self.profilePicture!, scaledToSize: CGSize(width:40,height:40))
print(self)
    }
    
    static func == (pl1: Player, pl2: Player) -> Bool {
        return
            pl1.firstName == pl2.firstName && pl1.lastName == pl2.lastName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(phone, forKey: .phone)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        if(self.profilePicture != nil) {
            let imageData:NSData = profilePicture!.pngData()! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            try container.encode(strBase64, forKey: .profilePicture)
        }

    }
    
    var description: String {
        return "id:\(self.id)\n\(self.firstName) \(self.lastName), \(self.email), \(self.phone)"
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
#if DEBUG
    static  let example = Player(id: UUID(), name: "Bobby Frey", email: "test@jnk.com", phone: "215-555-1212", firstName: "Bobby", lastName: "Frey", profilePicture: UIImage(named:"PlaceholderProfilePic"))
#endif
}

extension Player {
    var contactValue: CNContact {
      let contact = CNMutableContact()
      contact.givenName = firstName
      contact.familyName = lastName
      contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value:email as NSString)]
      if let profilePicture = profilePicture {
        let imageData = profilePicture.jpegData(compressionQuality: 1)
        contact.imageData = imageData
      }
      if let phoneNumberField = phoneNumberField {
        contact.phoneNumbers.append(phoneNumberField)
      }
      return contact.copy() as! CNContact
    }
    
    convenience init?(contact: CNContact) {
        let email = contact.emailAddresses.first
        let firstName = contact.givenName
        let lastName = contact.familyName
        var phone = ""
        for num in contact.phoneNumbers {
            if num.label == CNLabelPhoneNumberMobile {
                phone = ("\(num.value.stringValue)")
                break
            }
        }
 /*
        if phone == "" {
            for num in contact.phoneNumbers {
                if num.label == CNLabelPhoneNumberMobile {
                    phone = ("\(num.value.stringValue)(P)")
                    break
                }
            }
        }
 */
        var workEmail = ""
        if email != nil {
            workEmail = email!.value as String
        }
            
            
        var profilePicture: UIImage?
        if let imageData = contact.imageData {
            profilePicture = UIImage(data: imageData)
        }
        /*
        if let contactPhone = contact.phoneNumbers.first {
          phoneNumberField = contactPhone
        }
 */
        let name = firstName + " " + lastName
        self.init(id: UUID(), name: name, email: workEmail, phone: phone, firstName: firstName, lastName: lastName, profilePicture:profilePicture)

     }

}

