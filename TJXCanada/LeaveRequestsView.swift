//
//  LeaveRequestsView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

// 🔹 LeaveRequestsView.swift
import SwiftUI

struct LeaveRequestsView: View {
    let currentUser: User
    @Binding var leaveRequests: [LeaveRequest]
    @StateObject private var firestoreService = FirestoreService()
    @State private var selectedRequest: LeaveRequest? = nil

    var body: some View {
        NavigationView {
            List {
                if leaveRequests.isEmpty {
                    Text("Aucune demande trouvée.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(leaveRequests) { request in
                        Button {
                            selectedRequest = request
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Label(request.type.uppercased(), systemImage: "pin.fill")
                                    .font(.headline)

                                HStack {
                                    Label("\(request.dateFormatted)", systemImage: "calendar")
                                        .font(.subheadline)
                                    Spacer()
                                }

                                HStack {
                                    Label("Statut : \(request.status)", systemImage: "hourglass")
                                        .foregroundColor(request.statusColor)
                                }
                            }
                            .padding()
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        }
                    }
                }
            }
            .navigationTitle("Mes demandes")
            .onAppear {
                firestoreService.fetchLeaveRequests(for: currentUser.id) { requests in
                    self.leaveRequests = requests
                }
            }
            // Ouvre la vue de détails en feuille
            .sheet(item: $selectedRequest) { request in
                LeaveRequestDetailView(request: request)
            }
        }
    }

    // Badge count helper
    func pendingRequestCount() -> Int {
        leaveRequests.filter { $0.status.lowercased() == "en attente" }.count
    }
}
