//
//  SettingsView.swift
//  SwiftFirebase
//
//  Created by sgv on 04/07/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders(){
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers 
        }
    }
    
    func loadAuthUser(){
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "hello123@gmail.com"
        let password = "Hello123"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task{
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            
            Button(role: .destructive) {
                Task{
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Delete Account")
            }

            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSettings
            }
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack{
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task{
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset!")
                        showSignInView = true
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Update Password") {
                Task{
                    do {
                        try await viewModel.updatePassword()
                        print("Password Updated!")
                        showSignInView = true
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        } header: {
            Text("Email functions")
        }
    }
}



extension SettingsView {
    private var anonymousSettings : some View {
        Section {
            Button("Link Google Account") {
                Task{
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Google linked!")
                        showSignInView = false
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Link Email Account") {
                Task{
                    do {
                        try await viewModel.linkEmailAccount()
                        print("Email linked!")
                        showSignInView = false
                        viewModel.loadAuthProviders()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        } header: {
            Text("Create Account")
        }
    }
}
