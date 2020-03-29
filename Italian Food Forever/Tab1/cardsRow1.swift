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
    @ObservedObject var list = getcardData()
	func formatTitle(str: String) -> String {
		if str.contains("{"){
			let str1 = (str.replacingOccurrences(of: "{", with: "(")
				.replacingOccurrences(of: "}", with: ")"))
			return str1
		} else {
			return str
		}
	}

//Mark: - BODY
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Recent Posts")
                    .font(.title)
                    .fontWeight(.medium)
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
                                    .frame(width: 150.0, height: 165)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(12)
									.shadow(color: Color.black.opacity(0.4), radius: 8, x: 3, y: 3)
                                    .opacity(0.4)

                                Spacer()
                                VStack {
                                    WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
                                        .renderingMode(.original)
                                        .resizable()
										.indicator(.activity)
										.animation(.easeInOut(duration: 0.5))
										.frame(width: 150, height: 105)
                                        .cornerRadius(12)
                                    
									Text(self.formatTitle(str: i.title)
                                        .removingHTMLEntities)
                                        .font(.subheadline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 125.0)
                                        .lineLimit(3)
                                        .padding(.leading, -15)
                                        .padding(.bottom, 15)
                                    Spacer()
								}
                            }.padding(.bottom, 100)
						}.animation(.spring())
                    }
                }.frame(width: 950.0, height: 300.0)
            }
            Spacer()
        }.padding(.top,20)
    }
}



struct cardsRow1_Previews: PreviewProvider {
    static var previews: some View {
        cardsRow1()
            .previewLayout(.sizeThatFits)
    }
}

class getcardData: ObservableObject {
    @Published var datas = [dataType]()
	let defaults = UserDefaults.standard

    init() {
        load()
    }
	func load() {

		let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?per_page=6&offset=1&_fields=id,excerpt,content,title,mv,date,link&_envelope"

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
					self.datas.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
				}
			}
		}.resume()
    }
}

struct webView: UIViewRepresentable {
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>) {
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
    }

    var url: String

    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView {

        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }

}


