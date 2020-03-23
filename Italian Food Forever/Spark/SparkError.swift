//
//  SparkError.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import Foundation

struct SparkAuthError: Error {
    static let noAuthDataResult = NSError(domain: "No Auth Data Result", code: 400, userInfo: nil)
    static let noCurrentUser = NSError(domain: "No Current User", code: 401, userInfo: nil)
    static let noDocumentSnapshot = NSError(domain: "No Document Snapshot", code: 402, userInfo: nil)
    static let noSnapshotData = NSError(domain: "No Snapshot Data", code: 403, userInfo: nil)
    static let noProfile = NSError(domain: "No Profile", code: 404, userInfo: nil)
}

struct SignInWithAppleAuthError: Error {
    static let noAuthDataResult = NSError(domain: "No Auth Data Result", code: 300, userInfo: nil)
    static let noIdentityToken = NSError(domain: "Unable to fetch identity token", code: 301, userInfo: nil)
    static let noIdTokenString = NSError(domain: "Unable to serialize token string from data", code: 302, userInfo: nil)
    static let noAppleIDCredential = NSError(domain: "Unable to create Apple ID Credential", code: 303, userInfo: nil)
}
