//
//  ProfileView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import FirebaseAuth
import SDWebImageSwiftUI
import SwiftUI
import SwiftyJSON
import UIKit

struct ProfileView: View {
	@EnvironmentObject var spark: Spark
	@State var datasME = [dataType]()
	func stripHTML(str: String) -> String {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		return str
	}

	func sanitizeName(str: String) -> String {
		let str1 = str.components(separatedBy: " ")
		let toReturn = str1[0]
		return toReturn
	}
	@State var gear: Bool = false
	@State var rowLayout = true
	var body: some View {
		VStack {
			NavigationLink(destination: settings(), isActive: $gear) {
				EmptyView()
			}
			HStack {
				VStack {
					Text("\(sanitizeName(str: self.spark.profile.name))")
						.font(.system(size: 35, design: .rounded))
						.fontWeight(.bold)
				}
				Spacer()
			}.padding(.horizontal, 15)
			HStack {
				Text("Your saved posts")
					.font(.headline)
					.fontWeight(.semibold)
					.foregroundColor(Color(UIColor.systemTeal))
					.multilineTextAlignment(.leading)
				Spacer()
				VStack {
					Button(action: {
						self.gear = true
					}, label: {
						ZStack {
							Circle()
								.foregroundColor(.white)
								.shadow(color: Color.gray.opacity(0.4), radius: 10, x: 2, y: 2)
								.frame(width: 50, height: 50)
								.opacity(0.4)
							Image(systemName: "gear")
								.scaleEffect(1.6)
								.foregroundColor(.gray)
						}
					}).padding(.trailing, 10)
				}
			}.padding(.horizontal, 15)
				.padding(.top, -25)
				.padding(.bottom, 15)
			ScrollView(.vertical, showsIndicators: false) {
				if spark.profile.saved == [] {
					VStack {
						Spacer()
						HStack {
							Spacer()
							Text("No Saved Posts")
								.font(.subheadline)
								.foregroundColor(.gray)
							Spacer()
						}
					}
				} else {
					VStack {
						ForEach(self.datasME) { i in
							NavigationLink(destination: DetailView(detail: i)) {
								VStack {
									ZStack {
										if i.id != "nil" {
											WebImage(url: URL(string: i.image), options: .highPriority)
												.renderingMode(.original)
												.resizable()
												.indicator(.activity)
												.animation(.easeInOut(duration: 0.5))
												.aspectRatio(contentMode: .fill)
												.clipped()
												.frame(width: 350, height: 150)
												.cornerRadius(15)
											HStack {
												Text(i.title)
													.font(.headline)
													.fontWeight(.bold)
													.foregroundColor(Color.white)
													.multilineTextAlignment(.leading)
													.padding(.top, 105)
													.padding(.leading, 15)
													.shadow(color: .black, radius: 3, x: 1, y: 1)
												Spacer()
											}
										}
									}
								}
							}
						}
						Spacer()
						// MARK: - Logout
						HStack {
							Spacer()
							Button(action: {
								SparkAuth.logout { err in
									switch err {
									case .success:
										UserDefaults.standard.set(false, forKey: "status")
									case .failure(let error):
										utils().LOG(error: error.localizedDescription, value: "", title: "profileView")
										utils().LOG(error: error.localizedDescription, value: "", title: "ProfileView")
									}
								}
							}) {
								Text("Logout")
									.foregroundColor(.red)
							}
						}
					}.onAppear {
						self.datasME.removeAll()
						func load() {
							self.spark.configureFirebaseStateDidChange()
							if self.spark.profile.saved.isEmpty != true {
								let toStringList = (self.spark.profile.saved)
									.reversed()
									.joined(separator: ",")

								let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,title,mv,date,link,content,author&include=\(toStringList)"

								let url = URL(string: source)!

								let session = URLSession(configuration: .default)

								session.dataTask(with: url) { data, _, err in

									if err != nil {
										utils().LOG(error: err!.localizedDescription, value: "", title: "ProfileView")
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
											self.datasME.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
										}
									}
								}.resume()
							} else {
								self.datasME.append(dataType(id: "nil", url: "nil", date: "nil", title: "No Saved Posts", excerpt: "nil", image: "pasta", content: "nil"))
							}
						}
						load()
					}.frame(width: 350)
					Spacer()
				}
			}
			Spacer()
		}.onAppear {
			UserDefaults.standard.set(false, forKey: "status")
			UINavigationBar.appearance().isOpaque = true
			UINavigationBar.appearance().isTranslucent = true
		}
			.padding(.top, -65)
			.navigationBarItems(trailing: Text("Test"))
	}
}
struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView()
	}
}
