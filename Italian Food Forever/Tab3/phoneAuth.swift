//
//  phoneAuth.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/27/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Firebase

struct phoneAuth: View {
	@State var status = false
	@State var UID = ""
	@State var refresh: Bool = false

	var body: some View {

		VStack {
			if status {
				onboarding()
			}
			else {

				NavigationView {

					FirstPage()
				}
			}

		}.onAppear {

			NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in

				let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

				self.status = status
			}
		}

	}
}

struct FirstPage: View {
	func sanitizeCC(str: String) -> String {
		if str.contains("+") {
			let newStr = str.components(separatedBy: "+")
			let returnStr = newStr[1]
			return returnStr
		} else if str == "" {
			let returnStr = "1"
			return returnStr
		} else {
			return str
		}
	}
	@State var ccode = ""
	@State var no = ""
	@State var show = false
	@State var msg = ""
	@State var alert = false
	@State var ID = ""

	var body: some View {

		VStack(spacing: 20) {

			Text("Verify Your Number").font(.largeTitle).fontWeight(.heavy)

			Text("Please Enter Your Number To Verify Your Account")
				.font(.body)
				.foregroundColor(.gray)
				.padding(.top, 12)

			HStack {

				TextField("+1", text: $ccode)
					.keyboardType(.numberPad)
					.frame(width: 45)
					.padding()
					.background(Color(UIColor.systemGray6))
					.clipShape(RoundedRectangle(cornerRadius: 10))


				TextField("Number", text: $no)
					.keyboardType(.numberPad)
					.padding()
					.background(Color(UIColor.systemGray6))
					.clipShape(RoundedRectangle(cornerRadius: 10))

			} .padding(.top, 15)

			NavigationLink(destination: ScndPage(show: $show, ID: $ID), isActive: $show) {


				Button(action: {

					PhoneAuthProvider.provider().verifyPhoneNumber("+" + self.sanitizeCC(str: self.ccode) + self.no, uiDelegate: nil) { (ID, err) in

						if err != nil {

							self.msg = (err?.localizedDescription)!
							self.alert.toggle()
							return
						}

						self.ID = ID!
						self.show.toggle()
					}


				}) {

					Text("Send").frame(width: UIScreen.main.bounds.width - 30, height: 50)

				}.foregroundColor(.white)
					.background(Color.orange)
					.cornerRadius(10)
			}

				.navigationBarTitle("")
				.navigationBarHidden(true)
				.navigationBarBackButtonHidden(true)

		}.padding(.bottom, 100)
			.alert(isPresented: $alert) {

				Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
		}
	}
}

struct ScndPage: View {

	@EnvironmentObject var spark: Spark
	@State var code = ""
	@Binding var show: Bool
	@Binding var ID: String
	@State var msg = ""
	@State var alert = false

	var body: some View {

		ZStack(alignment: .topLeading) {

			GeometryReader { _ in

				VStack(spacing: 20) {

					Text("Verification Code").font(.largeTitle).fontWeight(.heavy)

					Text("Please Enter The Verification Code")
						.font(.body)
						.foregroundColor(.gray)
						.padding(.top, 12)

					TextField("Code", text: self.$code)
						.keyboardType(.numberPad)
						.padding()
						.background(Color("Color"))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(.top, 15)


					Button(action: {

						let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)

						Auth.auth().signIn(with: credential) { (res, err) in

							if err != nil {

								self.msg = (err?.localizedDescription)!
								self.alert.toggle()
								return
							}

							UserDefaults.standard.set(true, forKey: "status")
							NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
						}

					}) {

						Text("Verify").frame(width: UIScreen.main.bounds.width - 30, height: 50)

					}.foregroundColor(.white)
						.background(Color.orange)
						.cornerRadius(10)
						.navigationBarTitle("")
						.navigationBarHidden(true)
						.navigationBarBackButtonHidden(true)

				}.padding(.bottom, 200)

			}

			Button(action: {

				self.show.toggle()

			}) {

				Image(systemName: "chevron.left").font(.title)

			}.foregroundColor(.orange)

		}
			.padding()
			.alert(isPresented: $alert) {

				Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
		}
	}
}

struct Home: View {

	var body: some View {

		VStack {

			Text("Home")

			Button(action: {

				try! Auth.auth().signOut()

				UserDefaults.standard.set(false, forKey: "status")

				NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)

			}) {

				Text("Logout")
			}
		}
	}
}

struct phoneAuth_Previews: PreviewProvider {
	static var previews: some View {
		phoneAuth()
	}
}
