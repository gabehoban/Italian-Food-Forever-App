//
//  settings.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/25/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//
import FASwiftUI
import MessageUI
import StoreKit
import SwiftUI

struct subSettings: View {
	@State var isLoggedOut: Bool = false
	@State private var firstname = ""
	@EnvironmentObject var spark: Spark
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State var result: Result<MFMailComposeResult, Error>?
	@State var isShowingfeatureMailView = false
	@State var isShowingproblemMailView = false
	let size: CGSize

	var body: some View {
		VStack {
			Form {
				// MARK: - Section One
				Section(footer: Text("If you enjoy Italian Food Forever, please consider rating the app on the App Store.")) {
					HStack {
						FAText(iconName: "info-circle", size: 22)
							.foregroundColor(.red)
							.padding(.trailing, 5)
						// TODO: Add about page
						NavigationLink(destination: About()) {
							Text("About Italian Food Forever")
								.foregroundColor(.black)
						}
						Spacer()
					}
					HStack {
						Image(systemName: "sparkles")
							.foregroundColor(.orange)
							.padding(.trailing, 5)
						// TODO: Add ChangeLog Page
						NavigationLink(destination: ChangeLog()) {
							Text("What's New")
								.foregroundColor(.black)
						}
						Spacer()
					}
					HStack {
						FAText(iconName: "instagram", size: 22)
							.foregroundColor(.purple)
							.padding(.trailing, 5)
						// TODO: Add Link to Instagram
						Button(action: {
							if let requestUrl = URL(string: "https://www.instagram.com/italianfoodforever/") {
								UIApplication.shared.open(requestUrl)
							}
						}, label: {
							Text("Follow me on Instagram")
								.foregroundColor(.black)
						})
						Spacer()
					}
					HStack {
						Image(systemName: "heart.fill")
							.foregroundColor(.red)
							.padding(.trailing, 5)
						// TODO: Add Link to Instagram
						Button(action: {
							SKStoreReviewController.requestReview()
						}, label: {
							Text("Rate Italian Food Forever")
								.foregroundColor(.black)
						})
						Spacer()
					}
				}

				Section(footer: Text("Feature requests are always appreciated. Please let us know if you have any trouble with the app.")) {
					HStack {
						Button(action: {
							self.isShowingfeatureMailView.toggle()
						}) {
							Text("Request a New Feature")
								.foregroundColor(.black)
						}.disabled(!MFMailComposeViewController.canSendMail())
							.sheet(isPresented: $isShowingfeatureMailView) {
								featureMailView(result: self.$result, userInfo: "\(self.spark.profile.uid)")
							}
						Spacer()
					}
					HStack {
						Button(action: {
							self.isShowingproblemMailView.toggle()
						}) {
							Text("Report a Problem")
								.foregroundColor(.black)
						}.disabled(!MFMailComposeViewController.canSendMail())
							.sheet(isPresented: $isShowingproblemMailView) {
								featureMailView(result: self.$result, userInfo: "\(self.spark.profile.uid)")
							}
						Spacer()
					}
				}
				Section {
					// MARK: - Logout
					HStack {
						Spacer()
						Button(action: {
							SparkAuth.logout { err in
								switch err {
								case .success:
									print(" \(self.spark.profile.name) has Logged Out.")
									UserDefaults.standard.set(false, forKey: "status")
								case .failure(let error):
									utils().LOG(error: error.localizedDescription, value: "", title: "sparkAuth Logout")
								}
							}
						}) {
							Text("Logout")
								.foregroundColor(.red)
						}
						Spacer()
					}
				}
			}.listStyle(GroupedListStyle())
				.environment(\.horizontalSizeClass, .regular)
				.navigationBarTitle(Text("Settings"))
			Spacer()
			footer()
				.background(Color(UIColor.systemGray6))
		}.background(Color(UIColor.systemGray6))
	}
}

struct settings: View {
	@EnvironmentObject var spark: Spark
	var body: some View {
		GeometryReader { geo in
			subSettings(size: geo.size)
		}
	}
}
struct footer: View {
	var body: some View {
		VStack {
			HStack {
				Spacer()
				Image("banner-1")
					.resizable()
					.frame(width: 300, height: 130)
					.padding(.top, 25)
				Spacer()
			}
			HStack {
				Spacer()
				Text("App Version: \(UIApplication.appVersion ?? "")")
					.font(.system(size: 22, weight: .semibold, design: .rounded))
				Spacer()
			}
		}
	}
}
struct featureMailView: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentation
	@Binding var result: Result<MFMailComposeResult, Error>?
	func machineName() -> String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		return machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
	}
	let userInfo: String
	class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

		@Binding var presentation: PresentationMode
		@Binding var result: Result<MFMailComposeResult, Error>?

		init(presentation: Binding<PresentationMode>,
		     result: Binding<Result<MFMailComposeResult, Error>?>) {
			_presentation = presentation
			_result = result
		}

		func mailComposeController(_ controller: MFMailComposeViewController,
		                           didFinishWith result: MFMailComposeResult,
		                           error: Error?) {
			defer {
				$presentation.wrappedValue.dismiss()
			}
			guard error == nil else {
				self.result = .failure(error!)
				return
			}
			self.result = .success(result)
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(presentation: presentation,
		            result: $result)
	}

	func makeUIViewController(context: UIViewControllerRepresentableContext<featureMailView>) -> MFMailComposeViewController {
		let vc = MFMailComposeViewController()
		vc.setToRecipients(["feedback@gabehoban.com"])
		vc.setSubject("Support Request - IFF")
		vc.setMessageBody("""
			<p>Version: \(UIApplication.appVersion ?? "")<br>
			Device: \(machineName())<br>
			OS: \(UIDevice.current.systemVersion)<br>
			Region: \(NSLocale.current.regionCode ?? "null")<br>
			Preferred Language: \(NSLocale.current.languageCode ?? "null")<br>
			User ID: \(userInfo)
			</p>
			""", isHTML: true)
		vc.mailComposeDelegate = context.coordinator
		return vc
	}

	func updateUIViewController(_ uiViewController: MFMailComposeViewController,
	                            context: UIViewControllerRepresentableContext<featureMailView>) {

	}
}

struct problemMailView: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentation
	@Binding var result: Result<MFMailComposeResult, Error>?
	func machineName() -> String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		return machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
	}
	let userInfo: String
	class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

		@Binding var presentation: PresentationMode
		@Binding var result: Result<MFMailComposeResult, Error>?

		init(presentation: Binding<PresentationMode>,
		     result: Binding<Result<MFMailComposeResult, Error>?>) {
			_presentation = presentation
			_result = result
		}

		func mailComposeController(_ controller: MFMailComposeViewController,
		                           didFinishWith result: MFMailComposeResult,
		                           error: Error?) {
			defer {
				$presentation.wrappedValue.dismiss()
			}
			guard error == nil else {
				self.result = .failure(error!)
				return
			}
			self.result = .success(result)
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(presentation: presentation,
		            result: $result)
	}

	func makeUIViewController(context: UIViewControllerRepresentableContext<problemMailView>) -> MFMailComposeViewController {
		let vc = MFMailComposeViewController()
		vc.setToRecipients(["feedback@gabehoban.com"])
		vc.setSubject("Feature Request - IFF")
		vc.setMessageBody("""
			<p>Version: \(UIApplication.appVersion ?? "")<br>
			Device: \(machineName())<br>
			OS: \(UIDevice.current.systemVersion)<br>
			Region: \(NSLocale.current.regionCode ?? "null")<br>
			Preferred Language: \(NSLocale.current.languageCode ?? "null")<br>
			User ID: \(userInfo)
			</p>
			""", isHTML: true)
		vc.mailComposeDelegate = context.coordinator
		return vc
	}

	func updateUIViewController(_ uiViewController: MFMailComposeViewController,
	                            context: UIViewControllerRepresentableContext<problemMailView>) {

	}
}
