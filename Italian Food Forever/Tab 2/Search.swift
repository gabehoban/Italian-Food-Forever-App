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
		VStack {
			HStack{
				Text("Search Italian Food Forever")
					.font(.title)
					.fontWeight(.bold)
					.padding(.top, -50)
				.padding([.leading, .trailing], 10)
				Spacer()
			}
			HStack {
				Image(systemName: "magnifyingglass").foregroundColor(.gray)
					.scaleEffect(1)
					.padding(.trailing, 5)
					.padding(.leading, 15)
				Spacer()
				TextField("Enter search here...",
				          text: $text, onEditingChanged: { _ in
					          self.fetcher.getJsonData(string: self.text)
				          }).frame(height: 50.0)
				Spacer()
			}.overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 1))
				.padding([.leading, .trailing], 10)
			Form {
				Section(header: Text("Results")) {
					List {
						ForEach(fetcher.recipiesFull) { i in
							NavigationLink(destination: DetailView(detail: i)) {
								Text(i.title)
									.font(.subheadline)
									.lineLimit(2)
									.padding([.top, .bottom], 15)
							}
						}
					}

				}.navigationBarTitle("Test")
			}.padding(.top, 30)
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
	@Published var recipiesFull = [dataType]()


	init(search: String) {
		getJsonData(string: search)
	}

	func getJsonData(string: String) {
		recipies.removeAll(keepingCapacity: false)
		recipiesFull.removeAll(keepingCapacity: false)
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
				let urlFull = URL(string: "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,title,mv,date,link,content,author&include=" + id)
				//string is the initial string of the station name
				let taskFull = URLSession.shared.dataTask(with: urlFull!) { (data, response, error) in
					if error != nil {
						print((error?.localizedDescription)!)
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
