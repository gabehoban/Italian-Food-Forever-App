//
//  NetworkingManager.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/20/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString

struct NetworkingManager: View {
    @ObservedObject var datas = getData()
    
    var body: some View {
        Text("hi").onAppear {
            func toFirebase() {
                firebaseData.updateData(datas)
            }
        }
    }
}

struct NetworkingManager_Previews: PreviewProvider {
    static var previews: some View {
        NetworkingManager()
    }
}

class getData: ObservableObject {

    @Published var datas = [dataType]()

    init() {
        load()
    }
    func load() {
        let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?per_page=6&categories=863&_fields=id,content,excerpt,title,mv,%20date,link&_envelope"

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
                let content = i.1["content"]["rendered"].stringValue.removingHTMLEntities
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
                }
            }
        }.resume()
    }
}
