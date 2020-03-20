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

    @State private var selection: Int = 0
    @State var isNavigationBarHidden: Bool = true

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                Discover()
                    .padding(.top, 50)
                    .background(Color(red: 248 / 255, green: 242 / 255, blue: 219 / 255))
                    .edgesIgnoringSafeArea(.top)
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    .tag(0)
                Text("//TODO: page (2)")
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
                            Image(systemName: "heart.fill")
                            Text("My Recipes")
                        }
                    }
                    .tag(2)
            }.edgesIgnoringSafeArea(.top)
                .navigationBarHidden(true)
                .accentColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        }.onAppear() {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().backgroundColor = .clear
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
