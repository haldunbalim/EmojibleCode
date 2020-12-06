//
//  NotificationExtensions.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation

extension Notification.Name{
    // DataSource Notifications
    static let userModelChanged = Notification.Name(rawValue: "userModelChanged")
    static let authStateChanged = Notification.Name(rawValue: "authStateChanged")
    static let assignmentsChanged = Notification.Name(rawValue: "assignmentsChanged")
    static let defaultTutorialsChanged = Notification.Name(rawValue: "defaultTutorialsChanged")
    static let programsChanged = Notification.Name(rawValue: "programsChanged")
    
   

}
