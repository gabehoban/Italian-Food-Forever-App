//
//  springRow.swift
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

struct springRow: View {
    
    @ObservedObject var list = getspringRowData()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Spring Recipies")
                    .font(.title)
                    .padding(.leading, 20)
                Spacer()
            }
            Rectangle()
                .frame(height: 2.0)
                .padding([.leading, .trailing], 20)
                .padding(.top, -9)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                    ForEach(self.list.datas) { i in
                        NavigationLink(destination:
                            DetailView(detail: i)) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 150.0, height: 185)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: .black, radius: 5, x: 3, y: 3)
                                    .opacity(0.4)

                                Spacer()
                                VStack {
                                    WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 150, height: 105)
                                        .cornerRadius(20)

                                    Text((i.title)
                                        .removingHTMLEntities)
                                        .font(.subheadline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.black)
                                        .frame(width: 135.0)
                                        .lineLimit(3)
                                        .padding(.leading, -15)
                                        .padding(.bottom, 15)
                                    Spacer()
                                }
                            }.padding(.bottom, 100)
                        }
                    }.scaledToFit()
                }.frame(width: 950.0, height: 300.0)
            }.aspectRatio(contentMode: .fit)
            Spacer()
        }
    }
}

struct springRow_Previews: PreviewProvider {
    static var previews: some View {
        springRow()
    }
}

class getspringRowData: ObservableObject {

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
