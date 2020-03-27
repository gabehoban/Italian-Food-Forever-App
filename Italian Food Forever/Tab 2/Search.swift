//
//  Search.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/25/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Combine
import SwiftyJSON
import Foundation

struct searchType: Identifiable {
	var id: String
	var title: String
}

struct Search: View {
	@State public var text = ""
	@ObservedObject var fetcher = recipeFetcher(search: "")

	var body: some View {
		Form {
			Section {
				TextField("Search for recipies...",
				          text: $text, onEditingChanged: { _ in
					          self.fetcher.getJsonData(string: self.text)
				          })
			}
			Section(header: Text("Result")) {
				List {
					ForEach(fetcher.recipies) { i in
						Text(i.title)
							.font(.subheadline)
							.lineLimit(1)
					}
				}
			}
		}
	}

}

struct Search_Previews: PreviewProvider {
	static var previews: some View {
		Search()
	}
}

public class recipeFetcher: ObservableObject {

	@Published var recipies = [searchType]()


	init(search: String) {
		getJsonData(string: search)
	}

	func getJsonData(string: String) {
		recipies.removeAll(keepingCapacity: false)
		let url = URL(string: "https://italianfoodforever.com/wp-json/wp/v2/search?_envelope&_fields=id,title&search=" + string.replacingOccurrences(of: " ", with: "%20"))
		//string is the initial string of the station name
		let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
			if error != nil {
				print((error?.localizedDescription)!)
				return
			}
			
			let json = try! JSON(data: data!)
			for i in json["body"] {
				let id = i.1["id"].stringValue
				let title = i.1["title"].stringValue.removingHTMLEntities
				DispatchQueue.main.async {
					self.recipies.append(searchType(id: id, title: title))
				}
			}
		}
		task.resume()
	}
}
