//
//  Login.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/22/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import Firebase
import AudioToolbox

struct Login: View {

	@EnvironmentObject var spark: Spark

	var body: some View {
		GeometryReader { geo in
			ZStack {
				if self.spark.isUserAuthenticated == .undefined {
					LaunchScreenView()
				} else if self.spark.isUserAuthenticated == .signedOut {
					SignInView()
				} else if self.spark.isUserAuthenticated == .signedIn {
					ProfileView()
				}
			}.onAppear {
				UINavigationBar.appearance().isOpaque = true
				UINavigationBar.appearance().isTranslucent = true
				self.spark.configureFirebaseStateDidChange()
			}
		}
	}
}

struct Login_Previews: PreviewProvider {
	static var previews: some View {
		Login()
	}
}
