//
//  AvailabilityView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-23.
//
import SwiftUI

struct AvailabilityView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("📅 Disponibilités")
                    .font(.title)
                    .padding()

                Spacer()
                Text("Fonctionnalité à venir")
                    .foregroundColor(.gray)
                Spacer()
            }
            .navigationTitle("Availability")
        }
    }
}

