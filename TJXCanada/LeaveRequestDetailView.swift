//
//  Untitled.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//
import SwiftUI

struct LeaveRequestDetailView: View {
    let request: LeaveRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📌 Type de congé : \(request.type)")
                .font(.title2)

            Text("📅 Du \(request.startDate.formatted()) au \(request.endDate.formatted())")

            Text("⏳ Statut : \(request.status)")
                .foregroundColor(request.statusColor)
                .fontWeight(.medium)

            Spacer()
        }
        .padding()
        .navigationTitle("Détail de la demande")
        .navigationBarTitleDisplayMode(.inline)
    }
}
