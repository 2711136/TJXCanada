//
//  LeaveBalanceView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//

import SwiftUI

struct LeaveBalanceView: View {
    let balance: LeaveBalance

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(balance.type.uppercased())
                .font(.headline)

            HStack {
                Text("Pending")
                Spacer()
                Text("\(balance.pending, specifier: "%.2f") h")
            }

            HStack {
                Text("Approved")
                Spacer()
                Text("\(balance.approved, specifier: "%.2f") h")
            }

            HStack {
                Text("Remaining").bold()
                Spacer()
                Text("\(balance.remaining, specifier: "%.2f") h").bold()
            }

            if balance.exceeded > 0 {
                HStack {
                    Text("Exceeded")
                    Spacer()
                    Text("\(balance.exceeded, specifier: "%.2f") h")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
