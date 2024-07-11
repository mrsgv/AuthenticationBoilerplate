//
//  RootView.swift
//  SwiftFirebase
//
//  Created by sgv on 04/07/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView : Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack{
                    SettingsView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear{
            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authuser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
