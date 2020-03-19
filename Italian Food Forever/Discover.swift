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
            HStack {
                VStack(alignment: .center) {
                    Featured()
                    Spacer()
                }
            }

            cardsRow1()



        }
    }
}
struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
    }
}
