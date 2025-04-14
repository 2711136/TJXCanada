//
//  NewLeaveRequestView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct NewLeaveRequestView: View {
    @Binding var leaveRequests: [LeaveRequest]
    let currentUser: User

    @Environment(\.dismiss) var dismiss
    @StateObject private var firestoreService = FirestoreService()

    @State private var type: String = "VACATION"
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showAlert = false

    let leaveTypes = ["VACATION", "SICK", "PERSONNEL"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Type de congé")) {
                    Picker("Type", selection: $type) {
                        ForEach(leaveTypes, id: \.self) { t in
                            Text(t.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Dates")) {
                    DatePicker("Date de début", selection: $startDate, displayedComponents: .date)
                    DatePicker("Date de fin", selection: $endDate, displayedComponents: .date)
                }

                Button("Envoyer la demande") {
                    submitRequest()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Nouveau congé")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
            .alert("✅ Demande envoyée", isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    func submitRequest() {
        let request = LeaveRequest(
            type: type,
            startDate: startDate,
            endDate: endDate,
            status: "En attente",
            employeeName: currentUser.username,
            employeeId: currentUser.id
        )

        firestoreService.addLeaveRequest(request) { error in
            if error == nil {
                leaveRequests.append(request)
                showAlert = true
            }
        }
    }
}
