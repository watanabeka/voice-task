//
//  Item.swift
//  voice-task
//
//  Created by 渡辺海星 on 2026/02/06.
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
