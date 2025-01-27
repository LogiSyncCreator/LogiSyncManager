//
//  Item.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/09.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
