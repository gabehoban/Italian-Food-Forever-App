//
//  Featured.swift
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
	
    @ObservedObject private var list = getData(newUrl: "posts?per_page=1&categories_exclude=7&_fields=id,excerpt,title,content,mv,%20date,link&_envelope")

	var body: some View {
        VStack {
            ForEach(list.datas) { i in
                NavigationLink(destination: DetailView(detail: i)) {
                    ZStack {
						Rectangle()
							.frame(width: self.size.width * 0.93, height: 330)
							.cornerRadius(5)
							.foregroundColor(.white)
							.padding(.top, 60)
							.shadow(color: Color.black.opacity(0.2), radius: 8, x: 3, y: 3)
							
                        WebImage(url: URL(string: i.image), options: .highPriority)
                            .renderingMode(.original)
                            .resizable()
							.indicator(.activity)
							.animation(.easeInOut(duration: 0.5))
							.frame(width: self.size.width * 0.93, height: 270)
						
                        HStack {
							Text(self.formatTitle(str: i.title)
                                .removingHTMLEntities)
								.font(.system(size: 24))
								.fontWeight(.semibold)
								.frame(width: 300)
								.foregroundColor(Color.black)
								.multilineTextAlignment(.leading)
								.padding(.leading, 20)
								.lineLimit(3)
                            Spacer()
                        }.padding(.top, 325)
                    }
                }
            }
		}.padding(.top, -30)
    }
}

struct Featured: View {
	var body: some View {
		GeometryReader { geometry in
			subFeatured(size: geometry.size)
		}
	}
}
