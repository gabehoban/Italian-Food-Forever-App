//
//  Profile.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import Foundation

struct Profile: Identifiable {
    
    let id = UUID()
    let uid: String
    let name: String
    let email: String
    let saved: [String]
}
