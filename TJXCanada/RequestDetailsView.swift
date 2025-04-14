//
//  RequestDetailsView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct RequestDetailsView: View {
    let request: LeaveRequest
    let onStatusChange: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("👤 Dossier de \(request.employeeName)")
                    .font(.title2)

                Text("📌 Type de congé : \(request.type)")
                Text("📅 Date : \(request.dateFormatted)")
                Text("⏳ Statut : \(request.status)")
                    .foregroundColor(request.statusColor)

                Spacer()

                if request.status == "En attente" {
                    HStack(spacing: 30) {
                        Button(action: {
                            onStatusChange("Approuvé")
                        }) {
                            Label("Approuver", systemImage: "checkmark.circle.fill")
                                .font(.title3)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Button(action: {
                            onStatusChange("Rejeté")
                        }) {
                            Label("Rejeter", systemImage: "xmark.circle.fill")
                                .font(.title3)
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                } else {
                    Text("✅ Cette demande est déjà traitée.")
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Dossier")
            .navigationBarItems(trailing: Button("Fermer") {
                onStatusChange(request.status)
            })
        }
    }
}
