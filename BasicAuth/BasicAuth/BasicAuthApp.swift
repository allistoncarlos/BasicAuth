//
//  BasicAuthApp.swift
//  BasicAuth
//
//  Created by Alliston Aleixo on 24/10/25.
//

import SwiftUI
import GoogleSignIn

@main
struct BasicAuthApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel())
                .onOpenURL { url in
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
