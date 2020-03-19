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
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .center) {
                        Image("Banner")
                            .resizable()
                            .frame(width: 300, height: 80.0)
                            .padding(.bottom, 110)
                        Spacer()
                        Featured()
                            .frame(width: 200, height: 30.0)
                            .padding(.top, 10)
                            .padding(.bottom, 80)
                    }
                }
                Spacer()
                VStack {
                    Spacer()
                     cardsRow1()
                        .edgesIgnoringSafeArea(.all)
                    regionalRecipies()
                        .edgesIgnoringSafeArea(.all)
                        .padding(.top, -90)
                    springRow()
                    .edgesIgnoringSafeArea(.all)
                    .padding(.top, -90)
                }.padding(.top, 70)
                 .edgesIgnoringSafeArea(.bottom)
                Spacer()
            }
        }
    }
}
struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
            .previewLayout(.sizeThatFits)
    }
}
