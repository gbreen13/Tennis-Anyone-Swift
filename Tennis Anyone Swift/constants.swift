//
//  constants.swift
//  TennisSchedulerSwift
//
//  Created by George Breen on 9/24/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green:Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    convenience init( rgb: Int) {
        self.init(red: (rgb >> 16) & 0xff, green: (rgb >> 8) & 0xff, blue: (rgb & 0xff))
    }
}

struct Constants {
    static let minimumNumberOfPlayers = 4
    static let scrambleCount = 50
    static let maxTries = 5
    static let defaultCourtMinutes = 90
    static let defaultIconSize = 45.0
    static let jsonFileName = "schedule.json"
    static let blueBackgroundColor = UIColor(rgb: 0x4288C5)
    static let redBackgroundColor = UIColor(rgb: 0xea8685)
    static let yellowBackgroundColor = UIColor(rgb: 0xf4d03f)}
