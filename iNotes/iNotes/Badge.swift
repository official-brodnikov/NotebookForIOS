//
//  Badge.swift
//  iNotes
//
//  Created by alexey on 16/06/2019.
//  Copyright © 2019 alexey. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import CoreData

var notes = [Note]()
var notesContent = [NoteContent]()


func requestForNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) {
        (isEnabled, error) in
        if isEnabled {
        }
    }
}

func setBadge() {
    fetchRecords()
    var totalBadgeNumber = 0
    print(notes.count)
    totalBadgeNumber = notes.count
    UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
}

func fetchRecords() {
    guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
        return
    }
    
    let request: NSFetchRequest<Note> = Note.fetchRequest()
    
    notes = try! context.fetch(request)
}
