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
                        .edgesIgnoringSafeArea(.top)
                        .frame(width: 300, height: 80.0)
                    //.padding(.bottom,100)
                    Spacer()
                    Featured()
                        .frame(width: 200, height: 30.0)
                    Spacer()
                }
            }
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Text("New Posts")
                        .font(.largeTitle)
                        .padding(.leading, 25)
                        .padding(.bottom, -180)
                    Spacer()
                }
                 cardsRow1()//.padding(.bottom, 40)
                
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
