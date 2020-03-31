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

struct Featured: View {
	
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
                            .frame(width: 390, height: 270)
                            .cornerRadius(15)
                        Rectangle()
                            .padding(.top, 270)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: .init(colors: [Color.clear, Color.white]), startPoint: .top, endPoint: .bottom).opacity(0.8))
                            .frame(width:390, height: 200)
                        HStack(alignment: .center) {
							Text(self.formatTitle(str: i.title)
                                .removingHTMLEntities)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.leading)
                                .frame(width: 390, height: 400)
                                .padding(.leading, 2.0)
                                .lineLimit(3)
                            Spacer()
                        }.padding(.top, 275)
                    }
                }
            }
		}
    }
}



struct Featured_Previews: PreviewProvider {
    static var previews: some View {
        Featured()
    }
}
