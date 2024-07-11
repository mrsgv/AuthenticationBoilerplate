//
//  AuthenticationBoilerplateApp.swift
//  AuthenticationBoilerplate
//
//  Created by sgv on 11/07/24.
//

import SwiftUI
import Firebase

@main
struct AuthenticationBoilerplateApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
