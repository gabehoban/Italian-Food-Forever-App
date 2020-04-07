//
//  modalIngredents.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/31/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct modalIngredents: View {
	@Binding var Presented: Bool
	@Binding var content: String
	var onDismiss: () -> ()

	var body: some View {
		VStack {
			HStack {
				Text("Ingredients")
					.font(.headline)
				Spacer()
				HStack {
					Button(action: {
						self.onDismiss()
					}) {
						Text("Done")
							.foregroundColor(.black)
					}
				}
			}.padding(.top, 20)
			 .padding(.bottom, 25)
			ScrollView(.vertical, showsIndicators: false) {
				VStack {
					ForEach(utils().formatIngredients(str: content), id: \.self) { datum in
						HStack {
							CheckView(title: datum)
							Spacer()
						}
					}
				}
			}
			Spacer()
		}.padding(.horizontal, 10)
	}
}
