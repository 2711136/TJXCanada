//
//  EmployeeDashboardView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//
import SwiftUI

struct EmployeeDashboardView: View {
    let currentUser: User

    @State private var leaveRequests: [LeaveRequest] = []
    @State private var absences: [Absence] = []
    @State private var showLeaveForm = false
    @State private var showAbsenceForm = false
    @State private var showBalanceDetails = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var hasRejectedRequest = false

    @State private var selectedFilter: String = "Tous"
    private let filterOptions = ["Tous", "Approuvé", "En attente", "Rejeté"]

    @StateObject private var firestoreService = FirestoreService()

    // 🔍 Filtrage dynamique
    var filteredRequests: [LeaveRequest] {
        if selectedFilter == "Tous" {
            return leaveRequests
        } else {
            return leaveRequests.filter {
                $0.status.lowercased() == selectedFilter.lowercased()
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // En-tête avec logo
                    HStack {
                        Image("tjx_logo")
                            .resizable()
                            .frame(width: 100, height: 40)
                        Spacer()
                        Text("Bonjour, \(currentUser.username)")
                            .font(.headline)
                    }

                    // Soldes
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Soldes de congé", systemImage: "person.fill")
                            .font(.headline)

                        Button("Voir les détails") {
                            showBalanceDetails = true
                        }
                    }

                    // 📊 Camembert des types de congés
                    LeaveSummaryChart(requests: leaveRequests)

                    // 💼 Mes demandes de congé
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mes demandes de congé")
                            .font(.title2)
                            .fontWeight(.bold)

                        // 🔘 Picker de filtre
                        Picker("Filtrer", selection: $selectedFilter) {
                            ForEach(filterOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.segmented)

                        if filteredRequests.isEmpty {
                            Text("Aucune demande correspondant à ce filtre.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(filteredRequests) { request in
                                NavigationLink(destination: EmployeeDetailsView(request: request)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "paperplane.fill")
                                                .foregroundColor(.blue)
                                            Text(request.type.uppercased())
                                                .font(.headline)
                                        }

                                        Text("📅 \(request.dateFormatted)")
                                            .font(.subheadline)

                                        HStack {
                                            Image(systemName: "hourglass")
                                            Text("Statut : \(request.status)")
                                        }
                                        .font(.subheadline)
                                        .padding(6)
                                        .background(request.statusColor.opacity(0.1))
                                        .foregroundColor(request.statusColor)
                                        .cornerRadius(8)
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 3))
                                }
                            }
                        }
                    }

                    // ❌ Absences signalées
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Absences signalées")
                            .font(.title2)
                            .fontWeight(.bold)

                        if absences.isEmpty {
                            Text("Aucune absence signalée.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(absences) { absence in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("❌ Motif : \(absence.reason)")
                                    Text("📅 \(absence.dateFormatted)")
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
                            }
                        }
                    }

                    // Boutons d'action
                    HStack {
                        Button("+ Demande de congé") {
                            showLeaveForm = true
                        }
                        .buttonStyle(.borderedProminent)

                        Button("🚨 Signaler une absence") {
                            showAbsenceForm = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .navigationTitle("Accueil")
        }
        .sheet(isPresented: $showLeaveForm) {
            NewLeaveRequestView(leaveRequests: $leaveRequests, currentUser: currentUser)
        }
        .sheet(isPresented: $showAbsenceForm) {
            ReportAbsenceView(currentUser: currentUser)
        }
        .sheet(isPresented: $showBalanceDetails) {
            LeaveBalanceDetailView(balances: currentUser.leaveBalances)
        }
        .onAppear {
            fetchData()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("📣 Notification"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        // ✅ Alerte visuelle automatique si rejet
        .alert("❌ Demande rejetée", isPresented: $hasRejectedRequest) {
            Button("OK", role: .cancel) {
                hasRejectedRequest = false
            }
        } message: {
            Text("Une ou plusieurs de vos demandes ont été rejetées. Consultez-les pour plus de détails.")
        }
    }

    // 🔄 Chargement des données Firestore
    private func fetchData() {
        firestoreService.fetchLeaveRequests(for: currentUser.id) { requests in
            self.leaveRequests = requests

            // 🚨 Détection de demandes rejetées
            if requests.contains(where: { $0.status.lowercased() == "rejeté" }) {
                self.hasRejectedRequest = true
            }
        }

        firestoreService.fetchAbsences(for: currentUser.id) { absences in
            self.absences = absences
        }
    }
}
