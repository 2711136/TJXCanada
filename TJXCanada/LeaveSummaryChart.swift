//
//  LeaveSummaryChart.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-24.
//

import SwiftUI
import Charts

struct LeaveSummaryChart: View {
    let requests: [LeaveRequest]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Répartition des types de congé")
                .font(.title2)
                .fontWeight(.semibold)

            Chart {
                ForEach(groupedByType(), id: \.key) { type, list in
                    SectorMark(
                        angle: .value("Total", list.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 2.5
                    )
                    .foregroundStyle(by: .value("Type", type))
                }
            }
            .frame(height: 220)
        }
        .padding(.vertical)
    }

    // Regrouper les congés par type
    private func groupedByType() -> [(key: String, value: [LeaveRequest])] {
        Dictionary(grouping: requests, by: { $0.type.capitalized })
            .sorted { $0.key < $1.key }
    }
}
