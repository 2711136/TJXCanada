//
//  LoginView..swift
//  TJXCanada
//
//  Created by Bamba Loum on 2025-03-22.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAuthenticated = false
    @State private var isLoading = false
    @State private var currentUser: User?

    @EnvironmentObject var firestoreService: FirestoreService

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text("TJXCanada")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 40)

                    TextField("Nom d'utilisateur", text: $username)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Mot de passe", text: $password)
                            } else {
                                SecureField("Mot de passe", text: $password)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )

                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }

                    Button(action: login) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                                .shadow(radius: 4)
                        } else {
                            Text("Se connecter")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 4)
                        }
                    }
                    .disabled(isLoading)

                    Button(action: {
                        EmailService.sendEmail(
                            to: "Cheikh Bamba",
                            email: "loumbamba375@gmail.com",
                            status: "Approuvé",
                            startDate: "2025-03-26",
                            endDate: "2025-06-30"
                        )
                    }) {
                        Text("Tester Email")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button("Mot de passe oublié ?") {
                        // Action à implémenter
                    }
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))

                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $isAuthenticated) {
                destinationView()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erreur de connexion"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    func login() {
        isLoading = true
        firestoreService.authenticateUser(username: username, password: password) { user in
            DispatchQueue.main.async {
                isLoading = false
                if let user = user {
                    self.currentUser = user
                    self.isAuthenticated = true
                } else {
                    self.alertMessage = "Nom d'utilisateur ou mot de passe incorrect."
                    self.showAlert = true
                }
            }
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        if let user = currentUser, !user.id.isEmpty {
            switch user.role.lowercased() {
            case "admin":
                AdminDashboardView()
            case "manager":
                ManagerDashboardView()
                    .environmentObject(firestoreService)
            default:
                EmployeeTabView(currentUser: user)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(FirestoreService())
}
