//
//  modalIngredents.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/31/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import MessageUI

struct modalIngredents: View {
	@Binding var Presented: Bool
	@Binding var content: String
	@Binding var title: String
	@State var result: Result<MFMailComposeResult, Error>?
	@Binding var email: String
	@State var isShowingMailView = false
	var onDismiss: () -> Void

	var body: some View {
		VStack {
			HStack {
				Text("Ingredients")
					.font(.headline)
				Spacer()
				HStack {
					Button(action: {
						self.onDismiss()
					}) {
						Text("Done")
							.foregroundColor(.black)
					}
				}
			}.padding(.top, 20)
				.padding(.bottom, 25)
			ScrollView(.vertical, showsIndicators: false) {
				VStack {
					ForEach(utils().formatIngredients(str: content), id: \.self) { datum in
						HStack {
							CheckView(title: datum)
							Spacer()
						}
					}
					// MARK: - Mail to self
					HStack {
						Spacer()
						Button(action: {
							self.isShowingMailView.toggle()
						}) {
							HStack {
								Spacer()
								ZStack {
									Rectangle()
										.foregroundColor(.black)
										.frame(width: 300, height: 50)
										.cornerRadius(35)
									Text("Mail to self")
										.foregroundColor(.white)
								}
								Spacer()
							}.padding(.top, 45)
						}.disabled(!MFMailComposeViewController.canSendMail())
							.sheet(isPresented: $isShowingMailView) {
								MailView(result: self.$result, listSubject: utils().formatIngredients(str: self.content), recipie: self.title, email: self.email)
							}
						Spacer()
					}
				}
			}
			Spacer()
		}.padding(.horizontal, 10)
		 .onAppear {
			UINavigationBar.appearance().tintColor = UIColor.black
			
		 }
	}
}
struct MailView: UIViewControllerRepresentable {

	func formatMail(str: [String]) -> String {
		let joiner = ":"
		let joinedStrings = (str.joined(separator: joiner)).replacingOccurrences(of: ":", with: "</li><li>")
		let htmlHeader = "<p>Your ingredients for \(recipie) are: <br></p><ul type=\"Disc\"><li>"
		let message = htmlHeader + joinedStrings + "</li></ul></br><p>Copyright &copy; Deborah Mele 2020</p>"
		return message
	}

	@Environment(\.presentationMode) var presentation
	@Binding var result: Result<MFMailComposeResult, Error>?
	let listSubject: [String]
	let recipie: String
	let email: String

	func machineName() -> String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		return machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
	}
	
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

	func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
		let vc = MFMailComposeViewController()
		vc.setToRecipients(["\(email)"])
		vc.setSubject("Italian Food Forever - \(recipie)")
		vc.setMessageBody("\(formatMail(str: listSubject))", isHTML: true)
		vc.mailComposeDelegate = context.coordinator
		return vc
	}

	func updateUIViewController(_ uiViewController: MFMailComposeViewController,
	                            context: UIViewControllerRepresentableContext<MailView>) {

	}
}
