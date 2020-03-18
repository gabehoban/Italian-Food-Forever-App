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
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 10) {
                if i.image != "" {
                    
                    WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
                        .resizable()
                        .frame(width: 135, height: 90)
                        .cornerRadius(20)
                    
                }
                Text((i.title)
                    .removingHTMLEntities)
                    .fontWeight(.heavy)
                
                Text((((i.excerpt)
                    .removingHTMLEntities)
                    .replacingOccurrences(of: "<p>", with: "", options: NSString.CompareOptions.literal, range: nil))
                    .replacingOccurrences(of: "</p>", with: "", options: NSString.CompareOptions.literal, range: nil))
                    .lineLimit(3)
                
            }
            
            
        }.padding(.vertical, 15)
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
