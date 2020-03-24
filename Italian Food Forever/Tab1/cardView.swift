//
//  cardView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/19/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString


struct dataType: Identifiable {

    var id: String
    var url: String
    var date: String
    var title: String
    var excerpt: String
    var image: String
    var content: String

}


struct MySubview: View {
    let size: CGSize
    var detail: dataType

    @EnvironmentObject var spark: Spark

    @State private var show_signinModal: Bool = false
    @State private var show_signBackinModal: Bool = false
    @State private var heartSelect: Bool = false

    func stripHTML(str: String) -> String {
        let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
        let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        //print(str)
        let brokenString = str.components(separatedBy: "{\"@context")


        return brokenString[0].removingHTMLEntities
    }
    var body: some View {
        NavigationView {
            VStack {
                WebImage(url: URL(string: detail.image), options: .highPriority)
                    .renderingMode(.original)
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 500, height: 300)
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .edgesIgnoringSafeArea(.bottom)
                        .cornerRadius(20)
                        .frame(width: 0.95 * size.width, height: 600)
                        .shadow(color: .black, radius: 10, x: 1, y: 1)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            HStack{
                                Text(detail.title)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 10.0)
                                Spacer()
                            }
                            HStack{
                                Text("Deborah Mele")
                                    .fontWeight(.thin)
                                    .padding(.leading, 15)
                                Spacer()
                                Button(action: {
                                    Text("HI")
                                }) {
                                    ZStack{
                                        Rectangle()
                                            .frame(width: 200, height: 40)
                                            .cornerRadius(40)
                                            .foregroundColor(.black)
                                        HStack{
                                            Text("Instructions")
                                                .foregroundColor(.white)
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }.padding(.top, 10)
                            Rectangle()
                                .frame(height: 2.0)
                                .padding([.leading, .trailing], 20)
                            Text(stripHTML(str: detail.content))
                                .padding(.horizontal, 15.0)
                                .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }.padding([.leading, .trailing], 5)
                    }.frame(width: 0.95 * size.width, height: 500)
                     .padding(.top, -60)
                    Spacer()
                }.padding(.top, -40)
            }.padding(.top, -40)
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                    if self.spark.isUserAuthenticated == .undefined {
                        self.show_signinModal = true
                    } else if self.spark.isUserAuthenticated == .signedIn {
                        if self.heartSelect == false {
                            self.heartSelect = true

                            print("Before: \(self.spark.profile.saved)")
                            var savedP: [String] = self.spark.profile.saved
                            print("SavedP: \(savedP)")
                            savedP.append(self.detail.id)
                            print("New SavedP: \(savedP)")


                            SparkFirestore.mergeProfile(["saved": savedP], uid: self.spark.profile.uid) { (err) in
                                switch err {
                                case .success:
                                    print("Added \(self.detail.id) to saved array -> \(self.spark.profile.saved)")
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                            self.spark.configureFirebaseStateDidChange()

                        } else if self.heartSelect == true {
                            self.heartSelect = false
                            var savedP = self.spark.profile.saved
                            if let index = savedP.firstIndex(of: "\(self.detail.id)") {
                                savedP.remove(at: index)
                            }
                            self.spark.configureFirebaseStateDidChange()
                            SparkFirestore.mergeProfile(["saved": savedP], uid: self.spark.profile.uid) { (err) in
                                switch err {
                                case .success:
                                    print("Removed \(self.detail.id) from \(self.spark.profile.saved).")
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                            self.spark.configureFirebaseStateDidChange()
                        }
                    } else if self.spark.isUserAuthenticated == .signedOut {
                        self.show_signBackinModal = true
                    }
            }, label: {
                    if heartSelect == false {
                        Image(systemName: "heart")
                    } else if heartSelect == true {
                        Image(systemName: "heart.fill").foregroundColor(.red)
                    }
            }
                ).sheet(isPresented: self.$show_signinModal) {
                signInModal()
                }.scaleEffect(/*@START_MENU_TOKEN@*/1.4/*@END_MENU_TOKEN@*/))
            .edgesIgnoringSafeArea(.top)
            .padding(.top, 10)
            .onAppear() {
                self.spark.configureFirebaseStateDidChange()

                print(self.spark.profile.saved)

                UINavigationBar.appearance().isOpaque = true
                UINavigationBar.appearance().isTranslucent = true

                for id in self.spark.profile.saved
                {
                    if id == self.detail.id {
                        self.heartSelect = true
                        break
                    }
                }


        }
    }
}


struct DetailView: View {

    var detail: dataType
    var body: some View {
        GeometryReader { geometry in
            MySubview(size: geometry.size, detail: self.detail)
        }
    }
}

struct cardView: View {
    @Binding public var PostID: Int
    @State var list = [dataType]()

    var body: some View {
        VStack {
            Spacer()
            ForEach(list) { i in
                VStack {
                    HStack {
                        Text(i.title)
                            .font(.title)
                            .padding([.top, .leading], 15.0)
                        Spacer()
                    }
                    Spacer()
                }
            }.onAppear {
                self.list.removeAll()
                let source = "https://italianfoodforever.com/wp-json/wp/v2/posts?_envelope&_fields=id,excerpt,titlecontent,,mv,%20date,link,content,author&include=\(self.$PostID)"
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
                        let content = i.1["content"]["rendered"].stringValue.removingHTMLEntities
                        DispatchQueue.main.async {
                            self.list.append(dataType(id: id, url: url, date: date, title: title, excerpt: excerpt, image: image, content: content))
                        }
                    }
                }.resume()
            }
        }
    }
}
struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(PostID: Binding.constant(0))
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
