//
//  onboarding.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/27/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Firebase

struct onboarding: View {
	@State private var text = ""
	@State private var save: Bool = false
	@EnvironmentObject var spark: Spark
	@Environment(\.presentationMode) var presentation
	@ObservedObject var status = Status()
	
	var body: some View {
		VStack {
			if save {
				
			} else {
				HStack {
					Text("Phone Verification Successful")
					Image(systemName: "checkmark.circle.fill")
						.foregroundColor(.green)
						.padding(.leading, 8)
					Spacer()
				}
				Spacer()
				HStack {
					Spacer()
					VStack {
						HStack {
							Text("Enter your first name below:")
								.font(.headline)
								.padding(.leading, 15.0)
							Spacer()
						}
						TextField("John", text: $text).textFieldStyle(RoundedBorderTextFieldStyle())
							.padding([.leading, .trailing], 15)
						Button(action: {
							print(Auth.auth().currentUser!.uid)
							print(self.text)
							let data = [
								SparkKeys.Profile.uid: Auth.auth().currentUser!.uid,
								SparkKeys.Profile.name: self.text,
								SparkKeys.Profile.email: ""]
							SparkFirestore.mergeProfile(data, uid: Auth.auth().currentUser!.uid) { (result) in
								print(result)
							}
							self.status.end = true
							UserDefaults.standard.set(true, forKey: "status")
							self.presentation.wrappedValue.dismiss()
						}, label: {
							ZStack {
								Rectangle()
									.foregroundColor(.red)
									.cornerRadius(8)
									.shadow(color: .black, radius: 4, x: 2, y: 2)
									.frame(width: 350,
									       height: 50)
								Text("Continue")
									.foregroundColor(.black)
									.font(.system(size: 19))
									.fontWeight(.semibold)
							}
						}).padding(.top, 20)
					}.padding(.bottom, 100)

					Spacer()
				}
				Spacer()
			}
		}
	}
}


struct onboarding_Previews: PreviewProvider {
	static var previews: some View {
		onboarding()
	}
}
