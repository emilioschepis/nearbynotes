//
//  ProfileView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import AuthenticationServices
import Factory
import SwiftUI

struct ProfileView: View {
    @InjectedObject(\.authenticationManager) private var authenticationManager
    
    var body: some View {
        VStack {
            if let currentUser = authenticationManager.currentUser {
                Group {
                    Text("Hello, \(currentUser.id)")
                    Button("Sign out") {
                        authenticationManager.signOut()
                    }
                }
            } else {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email]
                } onCompletion: { result in
                    authenticationManager.handleAuthenticationResult(result)
                }
                .fixedSize()
            }
        }
    }
}

#Preview {
    ProfileView()
}
