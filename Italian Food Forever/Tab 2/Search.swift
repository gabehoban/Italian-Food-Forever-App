//
//  Search.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/25/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Combine
import SwiftyJSON
import Foundation
import SDWebImageSwiftUI

struct buttonLabel: View {
	@State var title: String = ""
	func dynLength(title: String) -> CGFloat {
		if title.count > 8 {
			let length: CGFloat = 120
			return length
		} else {
			let length: CGFloat = 95
			return length
		}
	}

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25, style: .continuous)
				.foregroundColor(Color(UIColor.systemTeal))
				.frame(width: dynLength(title: self.title), height: 45)
			Text(self.title)
				.foregroundColor(.white)
				.fontWeight(.bold)
				.font(.headline)
		}
	}
}

struct Search: View {

	@State public var text = ""
	@State var displayRes: Bool = false
	@ObservedObject var fetcher = recipeFetcher(search: "")
	@State var searchID: String = ""
	@State var buttonPadding: CGFloat = 1
	func formatDate(posted: String) -> String {
		let formatter1 = DateFormatter()
		let formatter2 = DateFormatter()
		formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let s = formatter1.date(from: posted)!
		// Return date as [Jan 1, 2020]
		formatter2.dateFormat = "MMM dd, yyyy"
		let date = formatter2.string(from: s)
		return date
	}
	var body: some View {
		VStack {
			HStack {
				Text("Search Italian Food Forever")
					.font(.title)
					.fontWeight(.bold)
					.padding(.top, -50)
					.padding([.leading, .trailing], 35)
				Spacer()
			}
			HStack {
				Image(systemName: "magnifyingglass").foregroundColor(.gray)
					.scaleEffect(1)
					.padding(.trailing, 5)
					.padding(.leading, 15)
				Spacer()
				TextField("Enter search here...",
				          text: $text, onEditingChanged: { _ in
					          self.fetcher.getJsonData(string: self.text)
					          self.displayRes = true
				          }, onCommit: {
					          self.fetcher.getJsonData(string: self.text)
				          }).frame(height: 50.0)
				Spacer()
				Button(action: {
					self.text = ""
					UIApplication.shared.endEditing()
				}, label: {
					Image(systemName: "x.circle.fill")
						.foregroundColor(.gray)
						.padding(.trailing, 20)
				})
			}.overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 1))
				.padding([.leading, .trailing], 20)
			if text != "" {
				VStack {
					Section {
						List {
							ForEach(fetcher.recipiesFull) { i in
								if i.title.contains("Menu") { } else if i.title.contains("Steak Lovers") { } else if i.title.contains("Adventure") { } else if i.title.contains("A Day") { } else if i.title.contains("Photos") { } else {
									NavigationLink(destination: DetailView(detail: i)) {
										HStack {
											WebImage(url: URL(string: i.image), options: .highPriority)
												.renderingMode(.original)
												.resizable()
												.indicator(.activity)
												.cornerRadius(10)
												.frame(width: 130, height: 90)
												.animation(.easeInOut(duration: 0.8))
											VStack {
												HStack{
													Text(i.title)
														.font(.subheadline)
														.fontWeight(.medium)
														.lineLimit(2)
														.padding([.top, .bottom], 15)
													Spacer()
												}
												Spacer()
												HStack{
													Text("Posted: \(self.formatDate(posted: i.date))")
														.font(.subheadline)
														.fontWeight(.light)
														.padding(.bottom, 10)
													Spacer()
												}
											}
											Spacer()
										}
									}
								}
							}
						}.animation(.linear(duration: 0.3))
					}
				}.padding(.top, 30)
					.animation(Animation.easeInOut(duration: 1).delay(0.8))
			} else {
				VStack {
					HStack {
						Text("Categories")
							.font(.headline)
							.fontWeight(.semibold)
							.foregroundColor(Color(UIColor.systemTeal))
							.multilineTextAlignment(.leading)
						Spacer()
					}.padding(.leading, 20)

					// MARK: - First Line of Categories
					HStack {
						Button(action: {
							self.text = "Fresh Pasta "
							self.fetcher.getJsonData(string: self.text)
						}, label: {
							buttonLabel(title: "Fresh Pasta")

						})
						Button(action: {
							self.text = "Seafood "
							self.fetcher.getJsonData(string: self.text)
						}, label: {
							buttonLabel(title: "Seafood")
						}).padding(.leading, buttonPadding)
						Button(action: {
							self.text = "Vegetables "
							self.fetcher.getJsonData(string: self.text)
						}, label: {
							buttonLabel(title: "Vegetables")
						}).padding(.leading, buttonPadding)
						Spacer()
					}.padding(.leading, 20)

					// MARK: - Second Line of Categories
					HStack {
						Button(action: {
							self.text = "Bread "
							self.fetcher.getJsonData(string: self.text)
						}, label: {
							buttonLabel(title: "Bread")

						})
						Button(action: {
							self.text = "Meat"
							self.fetcher.getJsonData(string: self.text)
						}, label: {
							buttonLabel(title: "Meat")
						}).padding(.leading, buttonPadding)
						Button(action: {
							self.text = "Pizza"
							self.fetcher.getJsonData(string: self.text)
						}, label: {
							buttonLabel(title: "Pizza")
						}).padding(.leading, buttonPadding)
						Spacer()
					}.padding(.top, 5)
						.padding(.leading, 20)
				}.padding(.top, 10)
			}
			Spacer()
		}.onAppear {
			if self.text != "" {
				//self.fetcher.getJsonData(string: self.text)
				self.displayRes = true
			} else {
				self.displayRes = false
			}
		}
	}
}

struct Search_Previews: PreviewProvider {
	static var previews: some View {
		Search()
	}
}
