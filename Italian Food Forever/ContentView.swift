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
    @EnvironmentObject var spark: Spark

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                Discover()
                    .padding(.top, 50)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.top)
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    .tag(0)
                Search()
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                            Text("Search")
                        }
                    }
                    .tag(1)
                Login()
                    .tabItem {
                        VStack {
                            Image(systemName: "heart.fill")
                            Text("My Recipes")
                        }
                    }
                    .tag(2)
            }.edgesIgnoringSafeArea(.top)
             .navigationBarHidden(self.isNavigationBarHidden)
        }.onAppear() {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().backgroundColor = .clear
            self.spark.configureFirebaseStateDidChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
