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

extension Profile: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let uid = documentData[SparkKeys.Profile.uid] as? String ?? ""
        let name = documentData[SparkKeys.Profile.name] as? String ?? ""
        let email = documentData[SparkKeys.Profile.email] as? String ?? ""
        let saved = documentData[SparkKeys.Profile.saved] as? [String] ?? []
        
        self.init(uid: uid,
                  name: name,
                  email: email,
                  saved: saved)
    }
}


