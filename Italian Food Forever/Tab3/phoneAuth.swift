//
//  phoneAuth.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/27/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Firebase

class Status: ObservableObject {
	@Published var end: Bool = false
	@Published var doneVerify: Bool = false
}

// MARK: - viewRouter
struct phoneAuth: View {
	@ObservedObject var status = Status()
	@State var UID = ""
	@State var refresh: Bool = false
	@EnvironmentObject var spark: Spark
	var body: some View {
		GeometryReader { _ in
			VStack {
				if UserDefaults.standard.value(forKey: "status") as? Bool ?? false == true {
					if self.status.end == false {
						onboarding()
					} else {
						ProfileView()
					}
				} else {
					FirstPage(done: false)
				}
			}
		}

	}
}

struct phoneAuth_Previews: PreviewProvider {
	static var previews: some View {
		phoneAuth()
	}
}

// MARK: - PhoneAuth getPhoneNumber
struct FirstPage: View {
	
	@EnvironmentObject var spark: Spark
	@Environment(\.presentationMode) var presentation
	@ObservedObject var status = Status()
	
	@State var show = false
	@State var done: Bool
	@State var ccode = ""
	@State var no = ""
	@State var msg = ""
	@State var alert = false
	@State var ID = ""

	var body: some View {
		VStack(spacing: 20) {
			Text("Verify Your Number")
				.font(.largeTitle)
				.fontWeight(.heavy)
			Text("Please Enter Your Number To Verify Your Account")
				.font(.body)
				.foregroundColor(.gray)
				.padding(.top, 12)
			HStack {
				Text("+1")
					.frame(width: 45)
					.padding()
					.background(Color(UIColor.systemGray6))
					.clipShape(RoundedRectangle(cornerRadius: 10))
				TextField("Number", text: $no)
					.keyboardType(.numberPad)
					.padding()
					.background(Color(UIColor.systemGray6))
					.clipShape(RoundedRectangle(cornerRadius: 10))
			}.padding(.top, 15)
				.frame(width: UIScreen.main.bounds.width - 30, height: 50)

			NavigationLink(destination: ScndPage(show: false, ID: $ID), isActive: $show) {
				Button(action: {
					#if targetEnvironment(simulator)
					self.no = "7349042335"
					Auth.auth().settings!.isAppVerificationDisabledForTesting = true
					#endif
					PhoneAuthProvider.provider().verifyPhoneNumber("+1" + self.no, uiDelegate: nil) { ID, err in
						if err != nil {
							self.msg = (err?.localizedDescription)!
							self.alert.toggle()
							return
						}
						self.ID = ID!
						self.show.toggle()
						self.status.doneVerify = true
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
		.onAppear {
			if UserDefaults.standard.value(forKey: "status") as? Bool ?? false == true {
				self.presentation.wrappedValue.dismiss()
			}
		}
	}
}

// MARK: - phoneAuth verifyPin
struct ScndPage: View {
	@Environment(\.presentationMode) var presentation
	@EnvironmentObject var spark: Spark
	@State var code = ""
	@State var show: Bool
	@Binding var ID: String
	@State var msg = ""
	@State var alert = false

	var body: some View {

		ZStack(alignment: .topLeading) {
			NavigationLink(destination: onboarding(), isActive: $show) {
				EmptyView()
			}
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
						#if targetEnvironment(simulator)
						self.code = "123456"
						Auth.auth().settings!.isAppVerificationDisabledForTesting = true
						#endif
						let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
						Auth.auth().signIn(with: credential) { _, err in
							if err != nil {
								self.msg = (err?.localizedDescription)!
								self.alert.toggle()
								return
							}
							self.show = true
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
		}.onAppear {
			if self.show == true {
				self.presentation.wrappedValue.dismiss()
			}
		}
			.padding()
			.alert(isPresented: $alert) {
				Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
			}
	}
}
