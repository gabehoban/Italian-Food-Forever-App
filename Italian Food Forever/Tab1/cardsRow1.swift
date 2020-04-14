//
//  cardsRow.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString

struct cardsRow1: View {
	@ObservedObject private var list = getData(newUrl: "posts?per_page=6&offset=1&categories_exclude=7&_fields=id,excerpt,content,title,mv,date,link&_envelope")
	func formatTitle(str: String) -> String {
		if str.contains("{") {
			let str1 = (str.replacingOccurrences(of: "{", with: "(")
				.replacingOccurrences(of: "}", with: ")"))
			return str1
		} else {
			return str
		}
	}

// MARK: - BODY
	var body: some View {
		VStack {
			Spacer()
			HStack {
				Text("Recent Posts")
					.font(.title)
					.multilineTextAlignment(.leading)
					.padding(.leading, 20)
				Spacer()
			}
			Rectangle()
				.frame(height: 2.0)
				.padding([.leading, .trailing], 20)
				.padding(.top, -9)
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					Spacer()
					ForEach(self.list.datas) { i in
						NavigationLink(destination:
							DetailView(detail: i)) {
							ZStack {
								Rectangle()
									.frame(width: 150.0, height: 140)
									.foregroundColor(Color.white)
									.cornerRadius(12)
									.shadow(color: Color.black.opacity(0.4), radius: 8, x: 3, y: 3)
									.opacity(0.5)
									.animation(.easeIn)

								Spacer()
								VStack {
									WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
										.renderingMode(.original)
										.resizable()
										.indicator(.activity)
										//.animation(.easeInOut(duration: 0.5))
										.frame(width: 150, height: 105)
									HStack {
										Text(self.formatTitle(str: i.title)
											.removingHTMLEntities)
											.font(.subheadline)
											.fontWeight(.semibold)
											.foregroundColor(Color.black)
											.lineLimit(3)
											.padding(.bottom, 10)
											.padding(.leading, 9)
										Spacer()
									}
									Spacer()
								}
							}.padding(.bottom, 100)
						}
					}
				}.frame(width: 950.0, height: 350.0)
			}.padding(.leading, 10)
			Spacer()
		}.padding(.top, 55)
	}
}

struct cardsRow1_Previews: PreviewProvider {
	static var previews: some View {
		cardsRow1()
			.previewLayout(.sizeThatFits)
	}
}
