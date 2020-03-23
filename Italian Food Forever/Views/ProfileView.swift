//
//  ProfileView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SwiftyJSON
import SDWebImageSwiftUI

struct ProfileView: View {

    @EnvironmentObject var spark: Spark
    @ObservedObject var listS = getfeatureData()

    func stripHTML(str: String) -> String {
        let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
        let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                List {
                    ForEach(listS.datas) { i in
                        NavigationLink(destination: DetailView(detail: i)) {
                            HStack {
                                WebImage(url: URL(string: i.image), options: .highPriority)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 150, height: 90)
                                    .cornerRadius(15)
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading) {
                                    Text(i.title)
                                        .font(.headline)
                                        .padding(.bottom, 5.0)
                                    Text(self.stripHTML(str: i.excerpt))
                                        .lineLimit(2)
                                }
                                Spacer()
                            }.padding([.top, .bottom], 10)
                        }
                    }
                Spacer()
                }
            }.padding(.top, 50)
        }.navigationBarTitle("My Saved Recipies", displayMode: .inline)
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
class getSavedPosts: ObservableObject {

    @EnvironmentObject var spark: Spark
    @Published var datas = [dataType]()

    init() {
        load()
    }
    func load() {
        self.spark.configureFirebaseStateDidChange()

        let toStringList = (self.spark.profile.saved)
            .reversed()
            .joined(separator: ",")

        print("JSON include \(toStringList)")

        let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,title,mv,%20date,link,content,author&include=\(toStringList)"

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
