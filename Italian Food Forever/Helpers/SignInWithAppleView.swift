//
//  SignInWithAppleView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: UIViewRepresentable {
    
    @EnvironmentObject var spark: Spark
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .whiteOutline)
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        let parent: SignInWithAppleView?
        
        // Unhashed nonce.
        var currentNonce: String?
        
        init(_ parent: SignInWithAppleView) {
            self.parent = parent
            super.init()
        }
        
        @objc func didTapButton() {
            #if !targetEnvironment(simulator)
            parent?.startActivityIndicator(message: "Signing up with Apple...")
            let nonce = SparkAuth.randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = SparkAuth.sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            #endif
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            let vc = UIApplication.shared.windows.last?.rootViewController
            return (vc?.view.window!)!
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            guard let parent = parent else {
                fatalError("No parent found")
            }
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
					Log.error("Unable to fetch identity token")
                    parent.stopActivityIndicator()
                    parent.presentAlert(title: "Error", message: "Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
					Log.error("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    parent.stopActivityIndicator()
                    parent.presentAlert(title: "Error", message: "Unable to serialize token string from data")
                    return
                }
                
                parent.updateActivityIndicator(message: "Saving to database...")
                SparkAuth.signIn(providerID: SparkAuth.providerID.apple, idTokenString: idTokenString, nonce: nonce) { result in
                    switch result {
                    case .success(let authDataResult):
                        let signInWithAppleResult = (authDataResult, appleIDCredential)
                        SparkAuth.handle(signInWithAppleResult) { result in
                            switch result {
                            case .success(let profile):
								Log.info("Successfully Signed in with Apple into Firebase: \(profile)")
                                parent.stopActivityIndicator()
                            case .failure(let err):
								Log.error(err.localizedDescription)
                                parent.stopActivityIndicator()
                                parent.presentAlert(title: "Error", message: err.localizedDescription)
                            }
                        }
                    case .failure(let err):
						Log.error(err.localizedDescription)
                        parent.stopActivityIndicator()
                        parent.presentAlert(title: "Error", message: err.localizedDescription)
                    }
                }
                
            } else {
                parent.stopActivityIndicator()
                parent.presentAlert(title: "Error", message: "No Apple ID Credential found")
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            guard let parent = parent else {
                fatalError("No parent found")
            }
            parent.stopActivityIndicator()
            parent.presentAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // MARK: - Activity Indicator
    @Binding var activityIndicatorInfo: ActivityIndicatorInfo
    
    func startActivityIndicator(message: String) {
        activityIndicatorInfo.message = message
        activityIndicatorInfo.isPresented = true
    }
    
    func stopActivityIndicator() {
        activityIndicatorInfo.isPresented = false
    }
    
    func updateActivityIndicator(message: String) {
        stopActivityIndicator()
        startActivityIndicator(message: message)
    }
    
    // MARK: - Alert
    @Binding var alertInfo: AlertInfo
    
    func presentAlert(title: String, message: String, actionText: String = "Ok", actionTag: Int = 0) {
        alertInfo.title = title
        alertInfo.message = message
        alertInfo.actionText = actionText
        alertInfo.actionTag = actionTag
        alertInfo.isPresented = true
    }
    
    func executeAlertAction() {
        switch alertInfo.actionTag {
        case 0:
			Log.error("No action alert action")
            
        default:
			Log.debug("Default alert action")
        }
    }
}
