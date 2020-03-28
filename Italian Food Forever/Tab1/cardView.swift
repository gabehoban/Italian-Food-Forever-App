//
//  cardView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/19/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString


struct dataType: Identifiable {
	var id: String
	var url: String
	var date: String
	var title: String
	var excerpt: String
	var image: String
	var content: String
}

struct MySubview: View {
	let size: CGSize
	var detail: dataType

	@EnvironmentObject var spark: Spark

	@State private var show_signinModal: Bool = false
	@State private var show_signBackinModal: Bool = false

	@State private var heartSelect: Bool = false
	@State private var ALERT: Bool = false
	@State private var isSharePresented: Bool = false
	@State private var instructionPage: Bool = false
	@State private var ingredients: Bool = false
	@State private var ingredientSymbol: String = "chevron.right"

	func stripHTML(str: String) -> String {
		let str = ((((str.replacingOccurrences(of: "\n", with: "", options: .regularExpression, range: nil)
			.replacingOccurrences(of: "</p>", with: "\n\n"))
			.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
			.replacingOccurrences(of: "Deborah Mele", with: "\nDeborah Mele\n{ENDME}", options: .regularExpression, range: nil))
			.replacingOccurrences(of: "Debrah Mele", with: "\nDeborah Mele\n{ENDME}", options: .regularExpression, range: nil))
		let brokenString = str.components(separatedBy: "{ENDME}")
		let brokenString1 = brokenString[0].components(separatedBy: "{\"@context")
		return brokenString1[0].removingHTMLEntities
	}

	func formatYield(str: String) -> String {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: detail.title.removingHTMLEntities)
			let frontYield = datePublished[1].components(separatedBy: "Prep Time")
			let sanitizedY = ((frontYield[0].replacingOccurrences(of: "\n", with: ""))
				.replacingOccurrences(of: "\t", with: ""))
			let yield = sanitizedY.components(separatedBy: "Yield:")
			return yield[1]
		} else {
			let nothtml = notHTML[1]
			let frontYield = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: "\",\"description"))
			let yield = frontYield[0].components(separatedBy: "recipeYield\":\"")
			return yield[1]
		}

	}
	func formatIngredients(str: String) -> [String] {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: "Ingredients")
			let Ingredients = datePublished[1].components(separatedBy: "Instructions")
			let sanitizedY = (((Ingredients[0].replacingOccurrences(of: "", with: ""))
				.replacingOccurrences(of: "\\t", with: ""))
				.replacingOccurrences(of: "\r", with: ""))
			let toArray4 = sanitizedY.replacingOccurrences(of: "\t", with: "")
			var toReturn = toArray4.components(separatedBy: "\n")
			toReturn.removeAll { $0 == "" }
			return toReturn

		} else {
			let nothtml = notHTML[1]
			let frontIngredients = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: ",\"recipeInstructions"))
			let Ingredients = frontIngredients[0].components(separatedBy: "recipeIngredient\":")
			let toArray1 = Ingredients[1].replacingOccurrences(of: "\\/", with: "/")
			let toArray2 = toArray1.replacingOccurrences(of: "\\", with: "")
			let toArray3 = toArray2.replacingOccurrences(of: ",", with: ", ")
			let toArray4 = ((toArray3
				.replacingOccurrences(of: "[\"", with: "")
				.replacingOccurrences(of: "\"]", with: ""))
				.replacingOccurrences(of: "\"\"]", with: ""))

			var toReturn = toArray4.components(separatedBy: "\", \"")
			toReturn.removeAll { $0 == "" }
			return toReturn
		}
	}
	func formatSteps(str: String) -> [String] {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {

			let datePublished = notHTML[0].components(separatedBy: "Instructions")
			let frontIngredients = datePublished[1].components(separatedBy: "Nutrition Information:")
			let Ingredients = frontIngredients[0].components(separatedBy: "recipeInstructions\":")
			let sanitizedY = (((Ingredients[0].replacingOccurrences(of: "\n", with: ""))
				.replacingOccurrences(of: "\t", with: ""))
				.replacingOccurrences(of: "\r", with: ""))
			let toArray4 = (sanitizedY.replacingOccurrences(of: " \t", with: "")
				.replacingOccurrences(of: "F.", with: "F"))
			let toReturn = toArray4.components(separatedBy: ".")
			return toReturn

		} else {
			let nothtml = notHTML[1]
			var frontIngredients = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: ",\"url"))
			if frontIngredients[0].contains("keywords") {
				frontIngredients = frontIngredients[0].components(separatedBy: ",\"keywords")
			}
			let Ingredients = frontIngredients[0].components(separatedBy: "recipeInstructions\":")
			let toArray1 = Ingredients[1].replacingOccurrences(of: "\\/", with: "/")
			let toArray2 = toArray1.replacingOccurrences(of: "\\", with: "")
			let toArray3 = toArray2.replacingOccurrences(of: "{\"@type\":\"HowToStep\",\"text\":\"", with: "")
			let toArray4 = (((toArray3
				.replacingOccurrences(of: "\"}", with: "")
				.replacingOccurrences(of: "[", with: ""))
				.replacingOccurrences(of: "]", with: ""))
				.replacingOccurrences(of: "..", with: "."))

			let toReturn = toArray4.components(separatedBy: ".,")
			return toReturn
		}
	}
	func formatDate(posted: String) -> String {
		let formatter1 = DateFormatter()
		let formatter2 = DateFormatter()
		formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let s = formatter1.date(from: posted)!
		formatter2.dateStyle = .short
		let date = formatter2.string(from: s)
		return date
	}

	var body: some View {
		VStack {
			NavigationLink(destination: Login(), isActive: $show_signinModal) {
				EmptyView()
					.navigationBarHidden(true)
			}
			NavigationLink(destination: Login(), isActive: $show_signBackinModal) {
				EmptyView()
					.navigationBarHidden(true)
			}
			NavigationView {
				VStack {
					WebImage(url: URL(string: detail.image), options: .highPriority)
						.renderingMode(.original)
						.resizable()
						.cornerRadius(10)
						.frame(width: 500, height: 300)
					ZStack {
						Rectangle()
							.foregroundColor(.white)
							.edgesIgnoringSafeArea(.bottom)
							.cornerRadius(20)
							.frame(width: 0.95 * size.width, height: 600)
							.shadow(color: .black, radius: 10, x: 1, y: 1)
						VStack {
							HStack {
								Text(detail.title.removingHTMLEntities)
									.font(.headline)
									.multilineTextAlignment(.leading)
									.padding(.leading, -15.0)

								Spacer()
							}.frame(width: 0.8 * size.width, height: 50)
							HStack {
								VStack {
									HStack {
										Text("Deborah Mele")
											.fontWeight(.thin)
											.padding(.leading, 18)
										Spacer()
									}.padding(.bottom, 5)
									HStack {
										Text("Posted: \(formatDate(posted: detail.date))")
											.font(.footnote)
											.padding(.leading, 18)
										Spacer()
									}
								}
								Spacer()
								if detail.content.contains("\"@type\":\"Recipe\"") || detail.content.contains("mv-recipe-card") {
									Button(action: {
										if self.instructionPage == false {
											self.instructionPage = true
										} else if self.instructionPage == true {
											self.instructionPage = false
										}

									}) {
										ZStack {
											Rectangle()
												.frame(width: 150, height: 30)
												.cornerRadius(40)
												.foregroundColor(Color(UIColor.brown))
												.shadow(color: .gray, radius: 10, x: 1, y: 1)
											HStack {
												Text("Recipe")
													.foregroundColor(.white)
												if instructionPage == false {
													Image(systemName: "chevron.right")
														.foregroundColor(.white)
												} else if instructionPage == true {
													Image(systemName: "chevron.down")
														.foregroundColor(.white)
												}

											}
										}
									}.padding(.trailing, 15)
								}
							}.padding(.top, -15)
							Rectangle()
								.frame(height: 2.0)
								.padding([.leading, .trailing], 20)
								.padding(.bottom, 10)
							Spacer()
						}.frame(width: 0.95 * size.width, height: 500)
							.padding(.top, -60)
						ScrollView(.vertical, showsIndicators: false) {
							VStack {
								if instructionPage == false {
									Text(stripHTML(str: detail.content).removingHTMLEntities)
										.padding(.horizontal, 15.0)
										.lineSpacing(5)
								} else {
									VStack {
										HStack {
											Spacer()
											Button(action: {
												if self.ingredients == false {
													self.ingredients = true
													self.ingredientSymbol = "chevron.down"
												} else if self.ingredients == true {
													self.ingredients = false
													self.ingredientSymbol = "chevron.right"
												}
											}, label: {
												ZStack {
													Rectangle()
														.frame(width: 150, height: 30)
														.cornerRadius(40)
														.foregroundColor(Color(red: 248 / 255, green: 242 / 255, blue: 219 / 255))
														.shadow(color: .gray, radius: 10, x: 1, y: 1)
													HStack {
														Text("Ingredients ")
															.foregroundColor(.black)
														Image(systemName: "\(ingredientSymbol)")
															.foregroundColor(.black)
													}
												}
											}).padding(.leading, -25)
											Spacer()
											Text("Yield: \(formatYield(str: detail.content.removingHTMLEntities))")
											Spacer()
										}.padding([.top, .bottom], 5)

										if ingredients == true {
											VStack {
												ForEach(formatIngredients(str: detail.content), id: \.self) { datum in
													HStack {
														Image(systemName: "circle.fill") .foregroundColor(Color.black)
															.scaleEffect(0.4)
														Text(datum.removingHTMLEntities)
															.lineLimit(3)
															.font(.body)
														Spacer()
													}

												}
											}
										}
										VStack {
											ForEach(0..<formatSteps(str: detail.content).count, id: \.self) { i in
												HStack {
													Text("\(i + 1). ")
														.foregroundColor(Color.black)
														.font(.body)
													Text("\(self.formatSteps(str: self.detail.content)[i]).")
														.font(.body)
													Spacer()
												}.padding(.top, 18)
											}
										}
									}.padding(.leading, 5)
								}
								Spacer()
							}.padding([.leading, .trailing], 10)
								.padding(.top, 10)
						}.padding(.top, 35) //Scrollview top padding
						.frame(width: 0.95 * size.width, height: 430)
						Spacer()
					}.padding(.top, -60) //Rectangle offset
				}.padding(.top, -40)
			}.navigationBarTitle("", displayMode: .inline)
				.navigationBarItems(trailing:
					HStack {
						Spacer()
						Button(action: {
							self.isSharePresented = true
						}, label: {
							Image(systemName: "square.and.arrow.up")
						}).padding(.bottom, 5)
							.padding(.trailing, 8)
							.sheet(isPresented: $isSharePresented, onDismiss: {
								print("Dismiss")
							}, content: {
								ActivityViewController(activityItems: [URL(string: self.detail.url)!])
							})
						Button(action: {
							if self.spark.isUserAuthenticated == .undefined {
								self.show_signinModal = true
							} else if self.spark.isUserAuthenticated == .signedIn {
								if self.heartSelect == false {
									self.heartSelect = true

									var savedP: [String] = self.spark.profile.saved
									savedP.append(self.detail.id)


									SparkFirestore.mergeProfile(["saved": savedP], uid: self.spark.profile.uid) { (err) in
										switch err {
										case .success:
											print("Added \(self.detail.id) to saved array -> \(self.spark.profile.saved)")
										case .failure(let error):
											print(error.localizedDescription)
										}
									}
									self.spark.configureFirebaseStateDidChange()

								} else if self.heartSelect == true {
									self.heartSelect = false
									var savedP = self.spark.profile.saved
									if let index = savedP.firstIndex(of: "\(self.detail.id)") {
										savedP.remove(at: index)
									}
									self.spark.configureFirebaseStateDidChange()
									SparkFirestore.mergeProfile(["saved": savedP], uid: self.spark.profile.uid) { (err) in
										switch err {
										case .success:
											print("Removed \(self.detail.id) from \(self.spark.profile.saved).")
										case .failure(let error):
											print(error.localizedDescription)
										}
									}
									self.spark.configureFirebaseStateDidChange()
								}
							} else if self.spark.isUserAuthenticated == .signedOut {
								self.show_signBackinModal = true
							}
						}, label: {
							if heartSelect == false {
								Image(systemName: "heart")
							} else if heartSelect == true {
								Image(systemName: "heart.fill").foregroundColor(.red)
							}
						}
						)
					}.scaleEffect(/*@START_MENU_TOKEN@*/1.4/*@END_MENU_TOKEN@*/))
				.edgesIgnoringSafeArea(.top)
				.padding(.top, 10)
				.onAppear() {
					self.spark.configureFirebaseStateDidChange()

					print(self.spark.profile.saved)

					UINavigationBar.appearance().isOpaque = true
					UINavigationBar.appearance().isTranslucent = true

					for id in self.spark.profile.saved
					{
						if id == self.detail.id {
							self.heartSelect = true
							break
						}
					}


			}
		}
	}
}


struct DetailView: View {

	var detail: dataType
	var body: some View {
		GeometryReader { geometry in
			MySubview(size: geometry.size, detail: self.detail)
		}
	}
}

struct ActivityViewController: UIViewControllerRepresentable {

	var activityItems: [Any]
	var applicationActivities: [UIActivity]? = nil

	func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
		let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
		return controller
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) { }

}

struct cardView: View {
	@Binding public var PostID: Int
	@State var list = [dataType]()

	var body: some View {
		VStack {
			Spacer()
			ForEach(list) { i in
				VStack {
					HStack {
						Text(i.title)
							.font(.title)
							.padding([.top, .leading], 15.0)
						Spacer()
					}
					Spacer()
				}
			}.onAppear {
				self.list.removeAll()
				let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,titlecontent,,mv,%20date,link,content,author&include=\(self.$PostID)"
				let url = URL(string: source)!
				let session = URLSession(configuration: .default)
				session.dataTask(with: url) { (data, _, err) in

					if err != nil {
						print((err?.localizedDescription)!)
						return
					}
					let json = try! JSON(data: data!)
					for i in json["body"] {
						let id = i.1["id"].stringValue
						let url = i.1["link"].stringValue
						let date = i.1["date"].stringValue
						let title = i.1["title"]["rendered"].stringValue.removingHTMLEntities
						let excerpt = i.1["excerpt"]["rendered"].stringValue
						let image = i.1["mv"]["thumbnail_uri"].stringValue
						let content = i.1["content"]["rendered"].stringValue
						DispatchQueue.main.async {
							self.list.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
						}
					}
				}.resume()
			}
		}
	}
}
struct cardView_Previews: PreviewProvider {
	static var previews: some View {
		cardView(PostID: Binding.constant(0))
	}
}
