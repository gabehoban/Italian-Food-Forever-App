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
	@Environment(\.presentationMode) var presentation
	
	var body: some View {
		VStack {
			NavigationView {
				TabView(selection: $selection) {
					Discover()
						.padding(.top, -95)
						.background(Color(hex: "fbfbfb").opacity(0.5)) //white
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
				let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
				if launchedBefore {
					if UserDefaults.standard.string(forKey: "version") != UIApplication.appVersion! {
						print("\n\n\nApp updated to \(UIApplication.appVersion!)\n\n\n")
						// Show Whats New
					} else {
						print("\n\n\nNo Update")
						#if targetEnvironment(simulator)
						// Show Whats New
						#endif
					}
				} else {
					print("\n\n\nFirst launch, setting UserDefault.\n\n\n")
					UserDefaults.standard.set(true, forKey: "launchedBefore")
					UserDefaults.standard.set(UIApplication.appVersion!, forKey: "version")
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
