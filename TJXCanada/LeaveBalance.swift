//
//  LeaveBalance.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

import Foundation

struct LeaveBalance: Identifiable, Codable {
    var id = UUID().uuidString
    var type: String
    var accrued: Double   // Total disponible (en heures)
    var approved: Double  // Congé approuvé
    var pending: Double   // Congé en attente

    // 🧮 Calcul automatique du restant
    var remaining: Double {
        return max(accrued - approved - pending, 0)
    }

    // 🧮 Si le solde est dépassé
    var exceeded: Double {
        let totalUsed = approved + pending
        return max(totalUsed - accrued, 0)
    }
}
