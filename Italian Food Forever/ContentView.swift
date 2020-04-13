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
import Log

var Log = Logger(formatter: .minimal, theme: nil, minLevel: .info)

struct ContentView: View {
	@State private var selection: Int = 0
	@State var isNavigationBarHidden: Bool = true
	@EnvironmentObject var spark: Spark

	var body: some View {
		VStack {
			NavigationView {
				TabView(selection: $selection) {
					Discover()
						.padding(.top, -95)
						.background(Color.white) //white
						.tabItem {
							VStack {
								Image(systemName: "house.fill")
								Text("Home")
							}
						}
						.tag(0)
					Search()
						.padding(.top, 1)
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
				}.navigationBarHidden(self.isNavigationBarHidden)
			}.onAppear {
				UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
				UINavigationBar.appearance().shadowImage = UIImage()
				UINavigationBar.appearance().isTranslucent = true
				UINavigationBar.appearance().tintColor = .black
				UINavigationBar.appearance().backgroundColor = .clear
				self.spark.configureFirebaseStateDidChange()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
