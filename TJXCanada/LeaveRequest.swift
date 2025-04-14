//
//  LeaveRequest.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct LeaveRequest: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var type: String
    var startDate: Date
    var endDate: Date
    var status: String
    var employeeName: String = "Moi"
    var employeeId: String = "" // 🔥 Pour filtrer par utilisateur connecté

    // Non codables → ignorés par Firestore
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) → \(formatter.string(from: endDate))"
    }

    var statusColor: Color {
        switch status.lowercased() {
        case "approuvé": return .green
        case "rejeté": return .red
        case "en attente": return .orange
        default: return .gray
        }
    }

    }
