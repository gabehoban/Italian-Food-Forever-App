//
//  settings.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/25/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct settings: View {
	@State private var firstname = ""
	@EnvironmentObject var spark: Spark

	var body: some View {
		VStack {
			Form {
				Section(header: Text("Account")) {
					HStack {
						Spacer()
						Button(action: {
							print("Clicked")
							SparkAuth.logout { (err) in
								switch err {
								case .success:
									print("\(self.spark.profile.uid) - \(self.spark.profile.name) has Logged Out.")
								case .failure(let error):
									print(error.localizedDescription)
								}
							}
						}) {
							Text("Logout")
								.foregroundColor(.red)
						}
						Spacer()
					}
				}
			}.navigationBarTitle(Text("Preferences"))
			Text("UID: \(self.spark.profile.uid)")
			Text("Version \(UIApplication.appVersion ?? "nil")")
			Spacer()
		}
	}
}

struct settings_Previews: PreviewProvider {
	static var previews: some View {
		settings()
	}
}

extension UIApplication {
	static var appVersion: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}
}
