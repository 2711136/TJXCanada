//
//  LeaveBalanceDetailView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

import SwiftUI

struct LeaveBalanceDetailView: View {
    let balances: [LeaveBalance]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if balances.isEmpty {
                        Text("Aucun solde trouvé.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(balances, id: \.type) { balance in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(balance.type.uppercased())
                                    .font(.headline)
                                    .padding(.bottom, 4)

                                HStack {
                                    Text("Total acquis")
                                    Spacer()
                                    Text("\(balance.accrued, specifier: "%.2f") H")
                                }

                                HStack {
                                    Text("Approuvé")
                                    Spacer()
                                    Text("\(balance.approved, specifier: "%.2f") H")
                                }

                                HStack {
                                    Text("En attente")
                                    Spacer()
                                    Text("\(balance.pending, specifier: "%.2f") H")
                                }

                                HStack {
                                    Text("Restant")
                                    Spacer()
                                    Text("\((balance.accrued - balance.approved), specifier: "%.2f") H")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(12)
                            .shadow(radius: 1)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Détails des soldes")
        }
    }
}
