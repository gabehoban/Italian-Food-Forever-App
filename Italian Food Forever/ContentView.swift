//
//  ContentView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/16/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct ContentView: View {

    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Discover()
            }
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Discover")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Search")
                    }
                }
                .tag(1)
            Text("//TODO: page (3)")
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "bookmark.fill")
                    Text("Saved Recipes")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

