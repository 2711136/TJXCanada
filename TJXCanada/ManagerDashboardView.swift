//
//  ManagerDashboardView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct ManagerDashboardView: View {
    @State private var teamRequests: [LeaveRequest] = []
    @State private var selectedRequest: LeaveRequest? = nil
    @StateObject private var firestoreService = FirestoreService()

    var body: some View {
        NavigationView {
            List {
                if teamRequests.isEmpty {
                    Text("Aucune demande pour le moment.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(teamRequests) { request in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("👤 \(request.employeeName)")
                                .font(.headline)

                            Text("📌 Type : \(request.type)")
                            Text("📅 Date : \(request.dateFormatted)")
                            Text("⏳ Statut : \(request.status)")
                                .foregroundColor(request.statusColor)

                            Button("📁 Voir dossier") {
                                selectedRequest = request
                            }
                            .padding(.top, 5)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Demandes de mon équipe")
            .onAppear {
                fetchRequests()
            }
            .sheet(item: $selectedRequest) { request in
                RequestDetailsView(
                    request: request,
                    onStatusChange: { status in
                        updateStatus(for: request, to: status)
                    }
                )
            }
        }
    }

    func fetchRequests() {
        firestoreService.fetchLeaveRequests { requests in
            self.teamRequests = requests
        }
    }

    func updateStatus(for request: LeaveRequest, to newStatus: String) {
        if let index = teamRequests.firstIndex(where: { $0.id == request.id }) {
            teamRequests[index].status = newStatus

            // 🔄 Mettre à jour le statut dans Firestore
            firestoreService.addLeaveRequest(teamRequests[index]) { error in
                if let error = error {
                    print("❌ Erreur maj statut : \(error.localizedDescription)")
                } else {
                    print("✅ Statut mis à jour dans Firestore")

                    // TODO : Ajouter mise à jour du solde ici si nécessaire
                }
            }
        }
        selectedRequest = nil
    }
}
