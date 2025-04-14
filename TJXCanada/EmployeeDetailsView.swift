//
//  EmployeeDetailsView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//
import SwiftUI

struct EmployeeDetailsView: View {
    let request: LeaveRequest

    var body: some View {
        VStack(spacing: 20) {
            Text("👤 Dossier de \(request.employeeName)")
                .font(.title2)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                Text("Type de congé : \(request.type)")
                Text("Date demandée : \(request.dateFormatted)")
                Text("Statut actuel : \(request.status)")
                    .foregroundColor(request.statusColor)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Détails")
        .navigationBarTitleDisplayMode(.inline)
    }
}
