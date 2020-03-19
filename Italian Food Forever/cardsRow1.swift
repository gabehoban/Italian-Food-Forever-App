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

    @State var OffsetNum = 0
    @ObservedObject var list = getcardData()


//Mark: - BODY
    var body: some View {
        HStack {
            HStack {
                ForEach(list.datas) { i in
                    NavigationLink(destination:
                        webView(url: i.url)) {
                        VStack(alignment: .leading) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 150.0, height: 185)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: .black, radius: 10, x: 7, y: 7)

                                Spacer()
                                VStack {
                                    WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 150, height: 105)
                                        .cornerRadius(20)

                                    Text((i.title)
                                        .removingHTMLEntities)
                                        .font(.subheadline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.black)
                                        .frame(width: 135.0)
                                        .lineLimit(3)
                                        .padding(.leading, 4)
                                        .padding(.bottom, 15)
                                    Spacer()
                                }
                            }
                        }
                    }
                }.scaledToFit()
            }
        }
    }
}

struct cardsRow1_Previews: PreviewProvider {
    static var previews: some View {
        cardsRow1()
    }
}

struct dataType: Identifiable {

    var id: String
    var url: String
    var date: String
    var title: String
    var excerpt: String
    var image: String

}

class getcardData: ObservableObject {

    @Published var datas = [dataType]()

    init() {
        load()
    }
    func load() {
        let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?per_page=6&offset=1&_fields=id,excerpt,title,mv,%20date,link&_envelope"

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
                let title = i.1["title"]["rendered"].stringValue
                let excerpt = i.1["excerpt"]["rendered"].stringValue
                let image = i.1["mv"]["thumbnail_uri"].stringValue
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image))
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


