//
//  Card.swift
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

struct Card: View {
    @ObservedObject var list = getData()
    @State private var translation: CGSize = .zero
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                    .opacity(0.7)
                    .frame(width: 135, height: 100)
                NavigationLink(destination:
                    webView(url: list.datas[0].url)
                    .navigationBarTitle("", displayMode: .inline)) {
                    Text(list.datas[0].title)
                }
            }
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card()
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

class getData: ObservableObject {

    @Published var datas = [dataType]()

    init() {
        let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?_fields=mv,id,excerpt,title,date,link&_envelope"

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
