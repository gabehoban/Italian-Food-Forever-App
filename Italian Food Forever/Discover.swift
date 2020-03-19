//
//  Discover.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/17/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//
import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import HTMLString

struct Discover: View {

    //@ObservedObject var list = getData()
    @State private var translation: CGSize = .zero

    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .center) {
                    Image("Banner")
                        .resizable()
                        .frame(width: 300, height: 80.0)
                        //.padding(.bottom, 90)
                    Spacer()
                    Featured()
                        .frame(width: 200, height: 30.0)
                        //.padding(.bottom, 70)
                }
            }
            Spacer()
            VStack {
                Spacer()
                 cardsRow1()
                    .edgesIgnoringSafeArea(.all)
            }
            Spacer()
        }
    }
}
struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
    }
}
