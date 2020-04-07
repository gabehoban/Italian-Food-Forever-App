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
import HTMLReader

struct InfoView: Identifiable {
    var id: Int
    var title: String
    var image: String
}

struct subFeatured: View {
	let size: CGSize
	func formatTitle(str: String) -> String {
		if str.contains("{"){
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
                        WebImage(url: URL(string: i.image), options: .highPriority)
                            .renderingMode(.original)
                            .resizable()
							.indicator(.activity)
							.animation(.easeInOut(duration: 0.5))
							.frame(width: self.size.width * 0.95, height: 270)
                            .cornerRadius(15)
                        Rectangle()
                            .padding(.top, 270)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: .init(colors: [Color.clear, Color.white]), startPoint: .top, endPoint: .bottom).opacity(0.8))
                            .frame(width: self.size.width * 0.95, height: 200)
                        HStack {
							Text(self.formatTitle(str: i.title)
                                .removingHTMLEntities)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.leading)
								.fixedSize(horizontal: false, vertical: true)
								.padding(.horizontal, 15)
                                .lineLimit(3)
                            Spacer()
                        }.padding(.top, 275)
                    }
                }
            }
		}
    }
}

struct Featured: View {
	var body: some View {
		GeometryReader { geometry in
			subFeatured(size: geometry.size)
		}
	}
}
