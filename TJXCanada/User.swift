//
//  User.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var username: String
    var password: String
    var role: String
    var email: String
    var leaveBalances: [LeaveBalance] = []

    // ✅ Ajout manuel pour Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // ✅ Ajout manuel pour Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
