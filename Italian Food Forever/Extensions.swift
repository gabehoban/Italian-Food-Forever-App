//
//  Extensions.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Foundation

extension View {
	func hiddenNavigationBarStyle() -> some View {
		ModifiedContent(content: self, modifier: HiddenNavigationBar())
	}
}

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	static var appVersion: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}
}

extension Profile: DocumentSerializable {
	
	init?(documentData: [String: Any]) {
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
