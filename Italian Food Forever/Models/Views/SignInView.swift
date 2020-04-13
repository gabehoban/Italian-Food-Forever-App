//
//  SignInView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct SignInView: View {
	var body: some View {
		VStack {
			Spacer()
			HStack {
				Text("Sign In to Save Recipies")
					.font(.largeTitle)
					.fontWeight(.heavy)
					.foregroundColor(.white)
					.multilineTextAlignment(.leading)
					.lineLimit(2)
					.padding(.top, 10.0)
					.padding(.leading, 10)
					.frame(width: 300.0)
					.shadow(color: .black, radius: 6, x: 4, y: 4)
				Spacer()
			}
			//Spacer()
			ActivityIndicatorView(isPresented: $activityIndicatorInfo.isPresented, message: activityIndicatorInfo.message) {
				VStack {
					Spacer()
					SignInWithAppleView(activityIndicatorInfo: self.$activityIndicatorInfo, alertInfo: self.$alertInfo)
						.frame(width: 350, height: 50)
					NavigationLink(destination: phoneAuth()) {
						HStack {
							Spacer()
							Text("Continue with Phone")
								.foregroundColor(.white)
								.font(.system(size: 16))
								.underline()
							Spacer()
						}
					}.padding(.bottom, 25)
					 .padding(.top, 5)
					HStack {
						Spacer()
						Text("By connecting, you agree to our")
							.foregroundColor(.white)
						Spacer()
					}
					HStack {
						Spacer()
						NavigationLink(destination: privacyPolicy()) {
							Text("Privacy Policy")
								.foregroundColor(.white)
								.underline()
						}
						Text("and")
							.foregroundColor(.white)
						NavigationLink(destination: privacyPolicy()) {
							Text("Terms of Use")
								.foregroundColor(.white)
								.underline()
						}
					Spacer()
					}.padding(.bottom, 20)
				//Spacer()
				}
			}
		}.background(
			Image("pasta")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.padding(.top, -250)
		)
	}

	// MARK: - Activity Indicator
	@State private var activityIndicatorInfo = SparkUIDefault.activityIndicatorInfo

	func startActivityIndicator(message: String) {
		activityIndicatorInfo.message = message
		activityIndicatorInfo.isPresented = true
	}

	func stopActivityIndicator() {
		activityIndicatorInfo.isPresented = false
	}

	func updateActivityIndicator(message: String) {
		stopActivityIndicator()
		startActivityIndicator(message: message)
	}

	// MARK: - Alert
	@State private var alertInfo = SparkUIDefault.alertInfo

	func presentAlert(title: String, message: String, actionText: String = "Ok", actionTag: Int = 0) {
		alertInfo.title = title
		alertInfo.message = message
		alertInfo.actionText = actionText
		alertInfo.actionTag = actionTag
		alertInfo.isPresented = true
	}

	func executeAlertAction() {
		switch alertInfo.actionTag {
		case 0:
			Log.debug("No action alert action")

		default:
			Log.debug("Default alert action")
		}
	}
}

struct SignInView_Previews: PreviewProvider {
	static var previews: some View {
		SignInView()
	}
}
