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
	@State var buttonPadding: CGFloat = 1

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
				Form {
					Section(header: Text("Results")) {
						List {
							ForEach(fetcher.recipiesFull) { i in
								NavigationLink(destination: DetailView(detail: i)) {
									Text(i.title)
										.font(.subheadline)
										.lineLimit(2)
										.padding([.top, .bottom], 15)
								}
							}
						}

					}.navigationBarTitle("Test")
				}.padding(.top, 30)
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
					
					// MARK: - First Line
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

					// MARK: - Second Line
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
				}.padding(.top, 5)
			}
		Spacer()
		}
		 .onAppear() {
			self.displayRes = false
		}
	}
}

struct Search_Previews: PreviewProvider {
	static var previews: some View {
		Search()
	}
}
