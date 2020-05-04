//
//  privacyTerms.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/26/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import FirebaseAuth
import SwiftUI

struct privacyTerms: View {
	@EnvironmentObject var spark: Spark
	@State private var showingAlert = false
	var body: some View {
		Form {
			Section {
				HStack {
					NavigationLink(destination: termsUse()) {
						Text("Terms of Use")
							.foregroundColor(.blue)
					}
					Spacer()
				}
				HStack {
					NavigationLink(destination: privacyPolicy()) {
						Text("Privacy Policy")
							.foregroundColor(.blue)
					}
					Spacer()
				}
			}
			Section {
				HStack {
					Button(action: {
						self.showingAlert = true
					}, label: {
						Text("Delete Server-Side Data")
					}).alert(isPresented: $showingAlert) {
						Alert(title: Text("ALERT_001"), message: Text("Are you sure you want to delete all your data from the servers?\n\nThis will disable the syncronization of your saved recipies."), primaryButton: .destructive(Text("Delete Data")) {
							let user = Auth.auth().currentUser
							user?.delete { error in
								if let error = error {
									utils().LOG(error: error.localizedDescription, value: "", title: "privacyTerms")
								} else {
									print("Account deleted")
								}
							}

						}, secondaryButton: .cancel())
					}
					Spacer()
				}
			}
		}
	}
}

struct privacyTerms_Previews: PreviewProvider {
	static var previews: some View {
		privacyTerms()
	}
}
