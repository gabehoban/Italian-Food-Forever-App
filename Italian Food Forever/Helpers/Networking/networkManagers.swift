//
//  networkManagers.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON

public class recipeFetcher: ObservableObject {

	@Published var recipies = [searchType]()
	@Published var recipiesFull = [dataType]()

	init(search: String) {
		getJsonData(string: search)
	}

	func getJsonData(string: String) {
		recipies.removeAll(keepingCapacity: false)
		recipiesFull.removeAll(keepingCapacity: false)
		let url = URL(string: "https://italianfoodforever.com/wp-json/wp/v2/search?_envelope&per_page=30&_orderby=relevance&_fields=id,title&search=" + string.replacingOccurrences(of: " ", with: "%20"))
		//string is the initial string of the station name
		let task = URLSession.shared.dataTask(with: url!) { (data, _, error) in
			if error != nil {
				Log.error((error?.localizedDescription)!)
				return
			}

			let json = try! JSON(data: data!)
			for i in json["body"] {
				let id = i.1["id"].stringValue
				let title = i.1["title"].stringValue.removingHTMLEntities
				DispatchQueue.main.async {
					self.recipies.append(searchType(id: id, title: title))
				}
				let urlFull = URL(string: "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&categories_exclude=7&_fields=id,excerpt,title,mv,date,link,content,author&include=" + id)
				//string is the initial string of the station name
				let taskFull = URLSession.shared.dataTask(with: urlFull!) { (data, _, error) in
					if error != nil {
						Log.error((error?.localizedDescription)!)
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
							self.recipiesFull.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
						}
					}
				}
				taskFull.resume()
			}
		}
		task.resume()
	}
}
