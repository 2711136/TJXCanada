//
//  Absence.swift
//  TJXCanada
//
//  Created by Erick DONFACK on 2025-03-22.
//

import Foundation
//Definition de la structure de données
struct Absence: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var reason: String
    var date: Date
    var employeeId: String

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
