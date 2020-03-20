//
//  NetworkingManager.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/19/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import SwiftyJSON


struct cardType: Identifiable {

    var id: String
    var url: String
    var date: String
    var title: String
    var excerpt: String
    var image: String

}

class NetworkingManager: ObservableObject {
    var didChange = PassthroughSubject<NetworkingManager, Never>()
    var datas = [cardType]() {
        didSet {
            didChange.send(self)
        }
    }

    init(count: Int = 34852) {
        let urlString = "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,title,mv,%20date,link,content,author&include=\(count)"
        guard let url = URL(string: urlString) else { return }

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
                    self.datas.append(cardType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image))
                }
            }
        }.resume()
    }
}
