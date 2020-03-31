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

	@State private var translation: CGSize = .zero

	var body: some View {
		VStack {
			Spacer()
			ScrollView(.vertical, showsIndicators: false) {
				HStack {
					Spacer()
					Image("Banner")
						.resizable()
						.frame(width: 250, height: 100)
					Spacer()
				}.padding(.top, -10)
				VStack {
					Spacer()
					HStack {
						VStack(alignment: .center) {
							Spacer()
							Featured()
								.frame(width: 200, height: 30.0)
								.padding(.top, 10)
								.padding(.bottom, 15)
							Spacer()
						}
					}
					Spacer()
					VStack {
						Spacer()
						cardsRow1()
						regionalRecipies()
							.padding(.top, -100)
						springRow()
							.padding(.top, -100)
					}.padding(.top, 115)
				}.padding(.top, 120)//100
			}
		}.padding(.bottom, -80)
	}
}
struct Discover_Previews: PreviewProvider {
	static var previews: some View {
		Discover()
			.previewLayout(.sizeThatFits)
	}
}
