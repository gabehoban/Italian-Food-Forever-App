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
extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex: Int) {
		self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
	}
}
extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
			case 3: // RGB (12-bit)
				(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
			case 6: // RGB (24-bit)
				(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
			case 8: // ARGB (32-bit)
				(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
			default:
				(a, r, g, b) = (1, 1, 1, 0)
		}
		
		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue: Double(b) / 255,
			opacity: Double(a) / 255
		)
	}
}
