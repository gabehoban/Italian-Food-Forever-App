//
//  getJSON.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON

class getData: ObservableObject {
	@Published var datas = [dataType]()
	
	init(newUrl: String) {
		load(partURL: newUrl)
	}
	func load(partURL: String) {
		let source = "https://italianfoodforever.com/wp-json/wp/v2/\(partURL)"
		let url = URL(string: source)!
		let session = URLSession(configuration: .default)
		session.dataTask(with: url) { data, _, err in
			if err != nil {
				Log.error((err?.localizedDescription)!)
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
