//
//  AdminDashboardView.swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI
import Charts

struct AdminDashboardView: View {
    @State private var users: [User] = []
    @State private var showAddUser = false
    @State private var selectedUser: User? = nil
    @State private var searchText: String = ""
    @State private var selectedRoleFilter: String = "Tous"

    let roleFilters = ["Tous", "employe", "manager", "admin"]

    var filteredUsers: [User] {
        users.filter { user in
            (selectedRoleFilter == "Tous" || user.role == selectedRoleFilter) &&
            (searchText.isEmpty || user.username.lowercased().contains(searchText.lowercased()))
        }
    }

    var roleCounts: [String: Int] {
        Dictionary(grouping: users, by: { $0.role })
            .mapValues { $0.count }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                            Text("Tableau RH")
                                .font(.largeTitle).bold()
                                .foregroundColor(.white)
                        }

                        Text("📋 Admin: \(roleCounts["admin"] ?? 0) | Manager: \(roleCounts["manager"] ?? 0) | Employé: \(roleCounts["employe"] ?? 0)")
                            .foregroundColor(.white.opacity(0.9))

                        // 🟠 Diagramme circulaire
                        Chart(roleCounts.sorted(by: { $0.key < $1.key }), id: \.key) { role, count in
                            SectorMark(
                                angle: .value("Count", count),
                                innerRadius: .ratio(0.6),
                                angularInset: 1
                            )
                            .foregroundStyle(by: .value("Role", role.capitalized))
                        }

                        }
                        .frame(height: 200)
                        .padding(.horizontal)

                        HStack {
                            ForEach(roleFilters, id: \.self) { role in
                                Button(action: {
                                    selectedRoleFilter = role
                                }) {
                                    Text(role.capitalized)
                                        .fontWeight(.medium)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                        .background(selectedRoleFilter == role ? Color.white.opacity(0.3) : Color.clear)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                            }

                        }
                        .padding(.horizontal)

                        // 🔍 Recherche
                        TextField("🔍 Rechercher un utilisateur", text: $searchText)
                            .padding(10)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            .padding(.horizontal)

                        // 📋 Liste utilisateurs
                        VStack(spacing: 10) {
                            ForEach(filteredUsers) { user in
                                Button(action: {
                                    selectedUser = user
                                }) {
                                    HStack {
                                        Image(systemName: iconForRole(user.role))
                                            .foregroundColor(colorForRole(user.role))
                                            .font(.system(size: 24))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(user.username)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text("Rôle : \(user.role.capitalized)")
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.7))
                                        }

                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                    .padding(.horizontal)
                                    .transition(.slide)
                                }
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddUser = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showAddUser) {
                AddUserView(users: $users)
            }
            .sheet(item: $selectedUser) { user in
                EditUserView(user: Binding(
                    get: { user },
                    set: { newValue in
                        if let index = users.firstIndex(where: { $0.id == newValue.id }) {
                            users[index] = newValue
                        }
                    })
                )
            }
            .onAppear {
                FirestoreService().fetchUsers { fetched in
                    self.users = fetched
                }
            }
        }
    }

    func iconForRole(_ role: String) -> String {
        switch role {
        case "admin": return "person.crop.circle.badge.checkmark"
        case "manager": return "person.3.fill"
        default: return "person.fill"
        }
    }

    func colorForRole(_ role: String) -> Color {
        switch role {
        case "admin": return .blue
        case "manager": return .orange
        default: return .green
        }
    }

