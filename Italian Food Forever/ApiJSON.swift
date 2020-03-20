//
//  ApiJSON.swift
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
import Alamofire

struct dataType: Identifiable {

    var id: String
    var url: String
    var date: String
    var title: String
    var excerpt: String
    var image: String

}

func sendRequestRequest(datas: dataType, id: Int!) {
    var Datas = datas
    /**
     Request
     get https://italianfoodforever.com/wp-json/wp/v2/posts
     */

    // Add URL parameters
    let urlParams = [
        "_envelope": "null",
        "_fields": "id,excerpt,title,mv, date,link,content,author",
        "include": "..",
    ]
    // Fetch Request
    AF.request("https://italianfoodforever.com/wp-json/wp/v2/posts",
               method: .get,
               parameters: urlParams)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                print(response.result)

                let json = try! JSON(data: response.data!)
                for i in json["body"] {
                    let id = i.1["id"].stringValue
                    let url = i.1["link"].stringValue
                    let date = i.1["date"].stringValue
                    let title = i.1["title"]["rendered"].stringValue
                    let excerpt = i.1["excerpt"]["rendered"].stringValue
                    let image = i.1["mv"]["thumbnail_uri"].stringValue
                    
                    var Datas = dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image))
                }

            case .failure(error):
                debugPrint(error)
            }
        }
}

