//
//  About.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 4/9/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct About: View {
	var body: some View {
		VStack {
			Section {
				HStack {
					Spacer()
					Image("appicon")
						.resizable()
						.frame(width: 150, height: 150)

					Spacer()
				}
				HStack {
					Spacer()
					Text("App Version: \(UIApplication.appVersion ?? "")")
						.font(.system(size: 22, weight: .semibold, design: .rounded))
					Spacer()
				}.padding(.vertical, 15)
				HStack {
					Spacer()
					NavigationLink(destination: privacyPolicy()) {
						Text("Privacy Policy")
							.foregroundColor(.red)
					}
					Spacer()
					NavigationLink(destination: termsUse()) {
						Text("Terms of Use")
							.foregroundColor(.red)
					}
					Spacer()
				}
				HStack {
					Spacer()
					Text("Copyright © Gabriel Hoban 2020")
					Spacer()
				}.padding(.vertical, 15)
			}
			Section {
				HStack {
					Spacer()
					Text("This app uses the following open source software:")
					Spacer()
				}
				HStack {
					Spacer()
					NavigationLink(destination: acknowledges()) {
						Text("Attributions")
							.underline()
							.foregroundColor(.blue)
					}
					Spacer()
				}
				Spacer()
			}
		}
	}
}
struct About_Previews: PreviewProvider {
	static var previews: some View {
		About()
	}
}
