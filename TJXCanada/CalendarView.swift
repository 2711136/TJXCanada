//
//  CalendarView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

import SwiftUI

struct CalendarView: View {
    @State private var leaveRequests: [LeaveRequest] = []
    @State private var absences: [Absence] = []
    @StateObject private var firestoreService = FirestoreService()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Congés approuvés")) {
                    if leaveRequests.filter({ $0.status.lowercased() == "approuvé" }).isEmpty {
                        Text("Aucun congé approuvé.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(leaveRequests.filter { $0.status.lowercased() == "approuvé" }) { request in
                            HStack {
                                Image(systemName: "calendar.badge.checkmark")
                                VStack(alignment: .leading) {
                                    Text(request.type.capitalized)
                                        .font(.headline)
                                    Text("\(request.dateFormatted)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Absences signalées")) {
                    if absences.isEmpty {
                        Text("Aucune absence signalée.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(absences) { absence in
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                VStack(alignment: .leading) {
                                    Text(absence.reason)
                                        .font(.headline)
                                    Text(absence.dateFormatted)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Mon calendrier")
        }
        .onAppear {
            loadData()
        }
    }

    func loadData() {
        // Remplacer ici par l’utilisateur courant si nécessaire
        let userID = UserDefaults.standard.string(forKey: "currentUserID") ?? ""

        firestoreService.fetchLeaveRequests(for: userID) { requests in
            self.leaveRequests = requests
        }

        firestoreService.fetchAbsences(for: userID) { absences in
            self.absences = absences
        }
    }
}
