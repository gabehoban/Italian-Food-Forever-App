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
						.frame(width: 220, height: 80)
					Spacer()
				}.padding(.top, -10)
				VStack {
					Spacer()
					ZStack {
						VStack(alignment: .center) {
							Spacer()
							Featured()
								.padding(.top, -150)
								.padding(.bottom, 50)
							Spacer()
						}
					}
					Spacer()
					VStack {
						Spacer()
						cardsRow1()
					}.padding(.top, 125)
				}.padding(.top, 135)//100
			}.animation(.easeInOut)
		}.padding(.bottom, -80)
	}
}
struct Discover_Previews: PreviewProvider {
	static var previews: some View {
		Discover()
			.previewLayout(.sizeThatFits)
	}
}
