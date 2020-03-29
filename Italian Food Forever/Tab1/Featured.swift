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
	
    @ObservedObject var listF = getfeatureData()

    var body: some View {
        VStack {
            ForEach(listF.datas) { i in
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

class getfeatureData: ObservableObject {
    @Published var datas = [dataType]()

    init() {
        load()
    }
    func load() {
        let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?per_page=1&_fields=id,excerpt,title,content,mv,%20date,link&_envelope"

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
