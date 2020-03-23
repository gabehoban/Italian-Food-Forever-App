//
//  Query.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/20/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import SwiftyJSON

class Query: ObservableObject {
    
    private final var urlBase = "https://italianfoodforever.com/wp-json/wp/v2/search?search="
    
    // List for news articles
    @Published var datas = [dataType]()
    
    // Needed for loading data
    var querySearch = ""
    var doneLoading = false
    var currentlyLoading = false
    
    init() {
        getQuerydata()
    }
    
    func getQuerydata() {
        
        let urlString = "\(urlBase)\(querySearch)"
        let url = URL(string: urlString)!
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
