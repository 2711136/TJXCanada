//
//  ReportAbsenceVie.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct ReportAbsenceView: View {
    @State private var selectedType: String = "Vacances"
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var message = ""
    @State private var showConfirmation = false
    @State private var showError = false

    @StateObject var firestoreService = FirestoreService()

    let currentUser: User
    let absenceTypes = ["Vacances", "Maladie", "Personnel"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Type d'absence")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(absenceTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Dates")) {
                    DatePicker("Date de début", selection: $startDate, displayedComponents: .date)
                    DatePicker("Date de fin", selection: $endDate, displayedComponents: .date)
                }

                Section {
                    Button(action: {
                        submitRequest()
                    }) {
                        Text("Soumettre la demande")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Nouvelle absence")
            .alert("Demande envoyée ✅", isPresented: $showConfirmation) {
                Button("OK") { }
            }
            .alert("Erreur lors de l'envoi ❌", isPresented: $showError) {
                Button("OK") { }
            }
        }
    }

    func submitRequest() {
        print("🟡 Envoi de la demande…")

        let request = LeaveRequest(
            type: selectedType,
            startDate: startDate,
            endDate: endDate,
            status: "En attente",
            employeeName: currentUser.username,
            employeeId: currentUser.id // 🔥 Important pour filtrer plus tard
        )

        firestoreService.addLeaveRequest(request) { error in
            if let error = error {
                print("❌ Erreur : \(error.localizedDescription)")
                showError = true
            } else {
                print("✅ Demande ajoutée dans Firestore")
                showConfirmation = true
            }
        }
    }
}
