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
import SPAlert

struct recipeView: View {
	let recipe: dataType
	@State var max = 0
	func getSteps() -> [String] {
		var array = Validate().validateArray(get: "Ingredients", detail: recipe)
		print(array.count)
		array.insert(" ", at: 0)
		array.insert(" ", at: 0)
		array.append(" ")
		array.append(" ")
		return array
	}
	@State var num: Int = 0
	@State var highlight = 0
	@State var valNum = 0
	var body: some View {
		ZStack {
			Color(hex: "343d46")
				.edgesIgnoringSafeArea(.all)
			VStack {
				ProgressCircle(value: num,
				               maxValue: Double(max),
				               style: .line,
				               foregroundColor: .red,
				               lineWidth: 10)
					.frame(height: 100)
					.padding(.vertical, 40)
				Spacer()
				ForEach(num..<num + 5, id: \.self) { i in
					HStack {
						if (i + -1) > 0 {
							if (i + -1) < self.max + 2 {
								Text("\(self.getSteps()[i]).")
									.font(.system(size: (i == (2 + self.num) ? 30 : 17), weight: .semibold, design: .rounded))
									.fixedSize(horizontal: false, vertical: true)
									.foregroundColor(Color(hex: "f1f0ea"))
							}
						}
						Spacer()
					}.lineSpacing(5)
						.padding(.top, 5)
						.opacity(i == (2 + self.num) ? 1.0 : 0.2)
				}.padding(.vertical, 5)
					.padding(.bottom, 10)
				Spacer()
			}.navigationBarTitle(recipe.title)
				.padding(.horizontal, 15)
		}.gesture(DragGesture().onEnded({ value in
			if value.translation.height < 0 {
				if self.num < self.max {
					self.num += 1
				} else {
					print("max")
				}
			} else {
				if self.num > 0 {
					self.num -= 1
				} else {
					print("min")
				}
			}
		}))
			.onAppear {
				self.max = self.getSteps().count - 5
				print("max: \(self.max)")
		}
	}
}

struct MySubview: View {
	let size: CGSize
	var detail: dataType
	@State private var showingAlert = false
	@EnvironmentObject var spark: Spark
	@Environment(\.presentationMode) var presentation

	var btnBack: some View { Button(action: {
		self.presentation.wrappedValue.dismiss()
	}) {
			HStack {
				Image(systemName: "arrow.left")
					.foregroundColor(.white)
					.scaleEffect(1.4)
			}
		}
	}

	@State private var show_signinModal: Bool = false
	@State private var show_signBackinModal: Bool = false
	@State private var article: Bool = false
	@State private var recipeview: Bool = false
	@State private var heartSelect: Bool = false
	@State private var isSharePresented: Bool = false
	@State private var instructionPage: Bool = false
	@State private var ingredients: Bool = false
	@State private var ingredientSymbol: String = "chevron.right"
	@State var refType: dataType = dataType(id: "", url: "", date: "", title: "", excerpt: "", image: "", content: "")
	@State var title: String = ""
	@State var email: String = ""

	func toggle() { isChecked = !isChecked }
	@State var isChecked: Bool = false
	let pad: CGFloat = 0.93

	var body: some View {
		VStack {
			NavigationLink(destination: SignInView(), isActive: $show_signinModal) {
				EmptyView()
			}
			NavigationLink(destination: recipeView(recipe: detail), isActive: $recipeview) {
				EmptyView()
			}
			NavigationView {
				VStack {
					ScrollView(.vertical, showsIndicators: false) {
						GeometryReader { geo in
							VStack {
								if geo.frame(in: .global).minY <= 0 {
									// MARK: - Image
									WebImage(url: URL(string: self.detail.image), options: .highPriority)
										.renderingMode(.original)
										.resizable()
										.indicator(.activity)
										.aspectRatio(contentMode: .fill)
										.frame(width: geo.size.width, height: geo.size.height)
										.offset(y: geo.frame(in: .global).minY / 9)
										.clipped()
										.animation(.easeInOut(duration: 0.8))
								} else {
									WebImage(url: URL(string: self.detail.image), options: .highPriority)
										.renderingMode(.original)
										.resizable()
										.indicator(.activity)
										.aspectRatio(contentMode: .fill)
										.frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
										.clipped()
										.offset(y: -geo.frame(in: .global).minY)
									//.animation(.easeInOut(duration: 0.8))
								}
							}
						}.frame(height: 300)
						VStack {
							// MARK: - Title
							//TODO: Add custom font
							HStack {
								Text(Validate().errorTest(get: "title", detail: detail))
									.font(.title)
									.fixedSize(horizontal: false, vertical: true)
									.lineLimit(3)
									.multilineTextAlignment(.leading)
									.animation(Animation.easeInOut(duration: 0.6).delay(0.3))
								Spacer()
							}.frame(width: 0.95 * size.width)
							// MARK: - Author & Date
							VStack {
								HStack {
									Image("deb")
										.clipShape(Circle())
										.shadow(radius: 10)
										.overlay(Circle().stroke(Color.black, lineWidth: 5))
										.frame(width: 10, height: 10)
										.scaleEffect(0.06)
										.padding(.leading, 10)
									Text("Deborah Mele")
										.fontWeight(.thin)
										.padding(.leading, 15)
										.animation(Animation.easeInOut(duration: 0.6).delay(0.5))
									Spacer()
									Text("Posted: \(Validate().errorTest(get: "date", detail: detail))")
										.fontWeight(.thin)
										.animation(Animation.easeInOut(duration: 0.6).delay(0.5))
								}
								// MARK: - Seperator
								Rectangle()
									.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255).opacity(0.4))
									.frame(height: 1.0)
									.padding(.vertical, 10)
								// MARK: - Details
								HStack {
									if Validate().errorTest(get: "time", detail: detail).contains("hour") {
										Text("Total \nTime")
											.fontWeight(.bold)
											.fixedSize(horizontal: false, vertical: true)
											.lineLimit(2)
									} else {
										Text("Total Time")
											.fontWeight(.bold)
									}
									Text(Validate().errorTest(get: "time", detail: detail))
										.font(.body)
									Spacer()
									Text("Yield")
										.fontWeight(.bold)
									Text(Validate().errorTest(get: "yield", detail: detail))
										.font(.body)
										.fixedSize(horizontal: false, vertical: true)
								}

								// MARK: - Ingredients
								HStack {
									Button(action: {
										self.ingredients.toggle()
										self.refType = self.detail
										self.title = self.detail.title
										self.email = self.spark.profile.email
									}) {
										Text("View Ingredients")
											.font(.headline)
											.fontWeight(.semibold)
											.foregroundColor(Color(UIColor.systemTeal))
											.multilineTextAlignment(.leading)
											.padding(.top, 15)
									}.sheet(isPresented: $ingredients) {
										modalIngredents(Presented: self.$ingredients, content: self.$refType, title: self.$title, email: self.$email, onDismiss: {
											self.ingredients = false
										})
									}
									Spacer()
								}
							}.padding(.vertical, 10)
								.frame(width: size.width * pad)

							// MARK: - Content
							if article == false {
								Button(action: {
									self.article.toggle()
								}) {
									Text(Validate().errorTest(get: "html", detail: detail))
										.font(.custom("Georgia", size: 18))
										.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
										.padding(.top, 15)
										.lineSpacing(5)
										.lineLimit(5)
										.fixedSize(horizontal: false, vertical: true)
										.frame(width: size.width * pad)
								}

								// MARK: - Directions
								HStack {
									Text("Directions")
										.font(.headline)
										.fontWeight(.bold)
									Spacer()
									Button(action: {
										self.recipeview.toggle()
									}) {
										ZStack {
											Rectangle()
												.frame(width: 100, height: 30)
												.foregroundColor(.black)
												.cornerRadius(20)
											Image(systemName: "arrow.up.left.and.arrow.down.right")
												.foregroundColor(.white)
										}
									}
								}.padding(.top, 25)
									.frame(width: size.width * pad)

								// MARK: - Steps
								ForEach(0..<Validate().validateArray(get: "steps", detail: detail).count, id: \.self) { i in
									HStack {
										Text("\(i + 1) ")
											.font(.custom("Georgia", size: 25))
											.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
											+ Text("\(Validate().validateArray(get: "steps", detail: self.detail)[i]).")
											.font(.custom("Georgia", size: 18))
											.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
										Spacer()
									}.lineSpacing(5)
										.padding(.top, 5)
										.frame(width: self.size.width * self.pad)
								}.padding(.vertical, 5)
									.padding(.bottom, 10)
							} else {
								Text(Validate().errorTest(get: "html", detail: detail))
									.font(.custom("Georgia", size: 18))
									.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
									.padding(.vertical, 15)
									.lineSpacing(5)
									.frame(width: size.width * pad)
								HStack {
									Spacer()
									Button(action: {
										self.article.toggle()
									}) {
										Text("Back to top")
											.padding(.trailing, 85)
											.padding(.bottom, 20)
									}
								}
							}
							Spacer()
						}.padding(.vertical, 5)
							.padding(.bottom, 15)
					}
					Spacer()
				}.alert(isPresented: $showingAlert) {
					Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
				}
			}.padding(.top, -70)
				.onAppear {
					self.spark.configureFirebaseStateDidChange()

					UINavigationBar.appearance().isOpaque = true
					UINavigationBar.appearance().isTranslucent = true
					UINavigationBar.appearance().tintColor = .white
					UINavigationBar.appearance().backgroundColor = .clear
					for id in self.spark.profile.saved {
						if id == self.detail.id {
							self.heartSelect = true
							break
						}
					}
			}
		}.navigationBarTitle("", displayMode: .inline)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: btnBack, trailing:
				HStack {
					Spacer()
					Button(action: {
						self.isSharePresented = true
					}, label: {
						Image(systemName: "square.and.arrow.up")
							.foregroundColor(.white)
					}).padding(.bottom, 5)
						.padding(.trailing, 8)
						.sheet(isPresented: $isSharePresented, content: {
							ActivityViewController(activityItems: [URL(string: self.detail.url)!])
						})
					Button(action: {
						if self.spark.isUserAuthenticated == .undefined {
							self.show_signinModal = true
						} else if self.spark.isUserAuthenticated == .signedIn {
							//SAVING
							if self.heartSelect == false {
								self.heartSelect = true
								SPAlert.present(title: "Saved to Profile", image: (UIImage(systemName: "heart.fill")!))
								var savedP: [String] = self.spark.profile.saved
								savedP.append(self.detail.id)

								SparkFirestore.mergeProfile(["saved": savedP], uid: self.spark.profile.uid) { err in
									switch err {
									case .success:
										Log.debug("Added \(self.detail.id) to saved array -> \(self.spark.profile.saved)")
									case .failure(let error):
										Log.error(error.localizedDescription)
									}
								}
								self.spark.configureFirebaseStateDidChange()
								//REMOVING
							} else if self.heartSelect == true {
								self.heartSelect = false
								SPAlert.present(title: "Removed from Profile", image: (UIImage(systemName: "xmark")!))
								var savedP = self.spark.profile.saved
								if let index = savedP.firstIndex(of: "\(self.detail.id)") {
									savedP.remove(at: index)
								}
								self.spark.configureFirebaseStateDidChange()
								SparkFirestore.mergeProfile(["saved": savedP], uid: self.spark.profile.uid) { err in
									switch err {
									case .success:
										Log.debug("Removed \(self.detail.id) from \(self.spark.profile.saved).")
									case .failure(let error):
										Log.error(error.localizedDescription)
									}
								}
								self.spark.configureFirebaseStateDidChange()
							}
						} else if self.spark.isUserAuthenticated == .signedOut {
							self.show_signinModal = true
						}
					}, label: {
						if heartSelect == false {
							Image(systemName: "heart")
								.foregroundColor(.white)
						} else if heartSelect == true {
							Image(systemName: "heart.fill")
								.foregroundColor(.red)
						}
					}
					)
				}.scaleEffect(/*@START_MENU_TOKEN@*/1.4/*@END_MENU_TOKEN@*/))
			.overlay(
				VStack {
					LinearGradient(gradient: .init(colors: [Color.black.opacity(0.6), .clear]), startPoint: .top, endPoint: .bottom)
					Spacer()
				}.edgesIgnoringSafeArea(.top)
					.offset(x: 0, y: -400)
					.frame(height: 100)
			)
			.edgesIgnoringSafeArea(.top)
			.padding(.top, 10)
	}
}

struct DetailView: View {
	var detail: dataType
	@State var alertUser: Bool = false
	@Environment(\.presentationMode) var presentation
	var body: some View {
		GeometryReader { geometry in
			VStack {
				if !self.alertUser {
					MySubview(size: geometry.size, detail: self.detail)
				} else {
					//TODO: Add funny 404 image
					VStack {
						AnimatedImage(url: URL(string: "https://i.imgur.com/ZlxwqOc.gif"))
							.resizable()
							.indicator(SDWebImageActivityIndicator.medium)
							.transition(.fade)
							.scaledToFit()
						Text("A problem occured while formatting this post.")
							.font(.system(size: 30, weight: .semibold, design: .rounded))
							.foregroundColor(Color.init(hex: "1B263B"))
							.padding(.horizontal, 10)
						Spacer()
						Button(action: {
							if let url = URL(string: self.detail.url) {
								UIApplication.shared.open(url)
							}
						}) {
							Rectangle()
								.frame(width: geometry.size.width * 0.8, height: 45)
								.foregroundColor(Color.init(hex: "41a5f7"))
								.cornerRadius(30)
								.overlay(
									Text("Open in Safari")
										.font(.system(size: 25, weight: .semibold, design: .rounded))
										.foregroundColor(.white)
								)
						}.padding(.bottom,5)
						Button(action: {
							self.presentation.wrappedValue.dismiss()
						}) {
							Rectangle()
								.frame(width: geometry.size.width * 0.8, height: 45)
								.foregroundColor(Color.init(hex: "41a5f7"))
								.cornerRadius(30)
								.overlay(
									Text("Return")
										.font(.system(size: 25, weight: .semibold, design: .rounded))
										.foregroundColor(.white)
								)
						}.padding(.bottom, 35)
					}
				}
			}
		}.onAppear() {
			if (Validate().validateArray(get: "steps", detail: self.detail).count == 0) {
				self.alertUser.toggle()
			}
		}
	}
}
class ViewRouter: ObservableObject {

	@Published var temp: Bool = false

}
struct ActivityViewController: UIViewControllerRepresentable {

	var activityItems: [Any]
	var applicationActivities: [UIActivity]?

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
				session.dataTask(with: url) { data, _, err in

					if err != nil {
						Log.error((err?.localizedDescription)!)
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
struct ProgressCircle: View {
	enum Stroke {
		case line
		case dotted

		func strokeStyle(lineWidth: CGFloat) -> StrokeStyle {
			switch self {
			case .line:
				return StrokeStyle(lineWidth: lineWidth,
				                   lineCap: .round)
			case .dotted:
				return StrokeStyle(lineWidth: lineWidth,
				                   lineCap: .round,
				                   dash: [12])
			}
		}
	}

	private let value: Double
	private let maxValue: Double
	private let style: Stroke
	private let backgroundEnabled: Bool
	private let backgroundColor: Color
	private let foregroundColor: Color
	private let lineWidth: CGFloat

	init(value: Int,
	     maxValue: Double,
	     style: Stroke = .line,
	     backgroundEnabled: Bool = true,
	     backgroundColor: Color = Color(UIColor(red: 245 / 255,
	                                            green: 245 / 255,
	                                            blue: 245 / 255,
	                                            alpha: 1.0)),
	     foregroundColor: Color = Color.black,
	     lineWidth: CGFloat = 10) {
		self.value = Double(value)
		self.maxValue = maxValue
		self.style = style
		self.backgroundEnabled = backgroundEnabled
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
		self.lineWidth = lineWidth
	}
	var body: some View {
		ZStack {
			if self.backgroundEnabled {
				Circle()
					.stroke(lineWidth: self.lineWidth)
					.foregroundColor(self.backgroundColor)
			}
			Text("\(Int(value + 1).description)/\(Int(maxValue).description)")
				.font(.system(size: 23, weight: .bold, design: .rounded))
				.foregroundColor(.white)
			Circle()
				.trim(from: 0, to: CGFloat(self.value / self.maxValue))
				.stroke(style: self.style.strokeStyle(lineWidth: self.lineWidth))
				.foregroundColor(self.foregroundColor)
				.rotationEffect(Angle(degrees: -90))
				.animation(.easeIn)
		}
	}
}
