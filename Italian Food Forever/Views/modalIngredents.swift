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
			HStack{
				Text("Ingredients")
				Spacer()
				HStack{
					Button(action: {
						print("PRINT")
					}) {
						Image(systemName: "printer")
					}
					Button(action: {
						self.onDismiss()
					}) {
						Text("Done")
					}
				}
			}.padding(.top, -75)
			ForEach(utils().formatIngredients(str: content), id: \.self) { datum in
				HStack {
					CheckView(title: datum)
					Spacer()
				}
			}
		}.padding(.horizontal, 10)
    }
}
