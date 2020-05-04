//
//  Spark.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import FirebaseAuth

enum SparkAuthState {
    case undefined, signedOut, signedIn
}

class Spark: ObservableObject {
    
    @Published var isUserAuthenticated: SparkAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", email: "", saved: [])
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Auth
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ _, user in
            guard let user = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
            SparkFirestore.retreiveProfile(uid: user.uid) { result in
                switch result {
                case .success(let profile):
                    self.profile = profile
                case .failure(let err):
					utils().LOG(error: err.localizedDescription, value: "", title: "Spark // configureFirebaseState")
                }
            }
        })
    }
}
