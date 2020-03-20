//
//  cardView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/19/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString


struct dataType: Identifiable {

    var id: String
    var url: String
    var date: String
    var title: String
    var excerpt: String
    var image: String

}

struct cardView: View {
    @Binding public var PostID: Int
    @State var list = [dataType]()
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(list) { i in
                VStack {
                    HStack {
                        Text(i.title)
                            .font(.title)
                            .padding([.top, .leading], 15.0)
                        Spacer()
                    }
                    Spacer()
                }
            }.onAppear {
                self.list.removeAll()
                let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,title,mv,%20date,link,content,author&include=\(self.$PostID)"
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
                        DispatchQueue.main.async {
                            self.list.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image))
                        }
                    }
                }.resume()
            }
        }
    }
}
struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(PostID: Binding.constant(0))
    }
}