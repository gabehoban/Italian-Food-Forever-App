//
//  Featured.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import DSSwiftUIKit
import HTMLString
import SDWebImageSwiftUI
import SwiftUI
import SwiftyJSON
import WebKit

struct InfoView: Identifiable {
	var id: Int
	var title: String
	var image: String
}

struct subFeatured: View {
	let size: CGSize
	func formatTitle(str: String) -> String {
		if str.contains("{") {
			let str1 = (str.replacingOccurrences(of: "{", with: "(")
				.replacingOccurrences(of: "}", with: ")"))
			return str1
		} else {
			return str
		}
	}

	@ObservedObject private var list = getData(newUrl: "per_page=1&categories_exclude=7&_fields=id,excerpt,title,content,mv,%20date,link&_envelope", offset: 0, delay: 0.0)

	var body: some View {
		VStack {
			ForEach(list.datas) { i in
				NavigationLink(destination: DetailView(detail: i)) {
					ZStack {

						WebImage(url: URL(string: i.image), options: .highPriority)
							.renderingMode(.original)
							.resizable()
							.frame(width: self.size.width, height: 380)
							.blur(radius: 12)
							.opacity(0.4)
							.padding(.top, 60)

						WebImage(url: URL(string: i.image), options: .highPriority)
							.renderingMode(.original)
							.resizable()
							.frame(width: self.size.width * 0.93, height: 350)
							.blur(.regular)
							.cornerRadius(8)
							.padding(.top, 60)

						Rectangle()
							.frame(width: self.size.width * 0.93, height: 350)
							.cornerRadius(8)
							.foregroundColor(.white)
							.padding(.top, 60)
							.shadow(color: Color.black.opacity(0.2), radius: 8, x: 3, y: 3)
							.opacity(0.8)

						WebImage(url: URL(string: i.image), options: .highPriority)
							.renderingMode(.original)
							.resizable()
							.placeholder {
								Rectangle().foregroundColor(.gray)
							}
							.indicator(.activity)
							.animation(.easeInOut(duration: 0.5))
							.frame(width: self.size.width * 0.93, height: 270)
							.padding(.top, -20)

						HStack {
							Text(self.formatTitle(str: i.title).removingHTMLEntities)
								.font(.system(size: 24))
								.fontWeight(.semibold)
								.foregroundColor(Color.black)
								.multilineTextAlignment(.leading)
								.padding(.horizontal, 32)
								.lineLimit(3)
								.accessibility(label: Text("Box1"))
							Spacer()
						}.padding(.top, 325)
					}
				}
			}
		}.padding(.top, -45)
	}
}

struct Featured: View {
	var body: some View {
		GeometryReader { geometry in
			subFeatured(size: geometry.size)
		}
	}
}
