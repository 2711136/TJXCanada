//
//  EmployeeTabView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

import SwiftUI

struct EmployeeTabView: View {
    let currentUser: User
    @State private var leaveRequests: [LeaveRequest] = []

    var body: some View {
        TabView {
            // Accueil
            EmployeeDashboardView(currentUser: currentUser)
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }

            // Calendrier
            CalendarView()
                .tabItem {
                    Label("Calendrier", systemImage: "calendar")
                }

            // Mes demandes avec badge s'il y en a en attente
            LeaveRequestsView(currentUser: currentUser, leaveRequests: $leaveRequests)
                .tabItem {
                    Label("Mes demandes", systemImage: "tray.full.fill")
                }
                .badge(pendingRequestCount())

            // Autres (disponibilités, paramètres, etc.)
            AvailabilityView()
                .tabItem {
                    Label("Autre", systemImage: "ellipsis")
                }
        }
        .onAppear {
            fetchLeaveRequests()
        }
    }

    // 🔄 Chargement des demandes de congé depuis Firestore
    private func fetchLeaveRequests() {
        FirestoreService().fetchLeaveRequests(for: currentUser.id) { requests in
            self.leaveRequests = requests
        }
    }

    // 🔔 Compter les demandes "en attente"
    private func pendingRequestCount() -> Int {
        leaveRequests.filter { $0.status.lowercased() == "en attente" }.count
    }
}
