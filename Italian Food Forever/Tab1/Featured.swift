//
//  Featured.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString
import HTMLReader

struct InfoView: Identifiable {
    var id: Int
    var title: String
    var image: String
}

struct Featured: View {

    @ObservedObject var listF = getfeatureData()

    var body: some View {
        VStack {
            ForEach(listF.datas) { i in
                NavigationLink(destination: DetailView(detail: i)) {
                    ZStack {
                        Rectangle()
                            .padding(.top, 70)
                            .frame(width: 350, height: 360)
                            .foregroundColor(Color(UIColor.systemGray5))
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 10, x: 7, y: 7)
                            .opacity(0.4)
                        WebImage(url: URL(string: i.image), options: .highPriority)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 350, height: 250)
                            .cornerRadius(20)
                        VStack(alignment: .leading) {
                            Text((i.title)
                                .removingHTMLEntities)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.black)
                                .frame(width: 300.0)
                                .lineLimit(3)
                                .padding(.leading, -15)
                                .navigationBarTitle("")
                        }.padding(.top, 303)
                            .padding(.bottom, 15)
                    }
                }
            }
        }
    }
}



struct Featured_Previews: PreviewProvider {
    static var previews: some View {
        Featured()
    }
}

class getfeatureData: ObservableObject {

    @Published var datas = [dataType]()

    init() {
        load()
    }
    func load() {
        let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?per_page=1&_fields=id,excerpt,title,content,mv,%20date,link&_envelope"

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
                let content = i.1["content"]["rendered"].stringValue
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
                }
            }
        }.resume()
    }
}
