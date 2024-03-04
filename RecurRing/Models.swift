//
//  Models.swift
//  RecurRing
//
//  Created by Luke Faupel on 3/2/24.
//

import Foundation

struct RecurringAlert: Identifiable, Codable {
    var id = UUID()
    var name: String
    var intervalMinutes: Double
    var isEnabled: Bool
    var lastEnabled: Date
}
