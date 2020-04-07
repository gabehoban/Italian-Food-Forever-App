//
//  Checklist.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct CheckView: View {
	@State var isChecked: Bool = false
	var title: String
	func toggle() { isChecked = !isChecked }
	var body: some View {
		Button(action: toggle) {
			HStack {
				if !title.contains(":") {
					Image(systemName: isChecked ? "checkmark.square" : "square")
						.scaleEffect(1.4)
						.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
						.padding(.trailing, 5)
					Text(title)
						.strikethrough(isChecked, color: .black)
						.lineLimit(5)
						.lineSpacing(5)
						.fixedSize(horizontal: false, vertical: true)
						.font(.custom("Georgia", size: 18))
						.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
					//Spacer()
				} else {
					Text(title)
						.font(.custom("Georgia", size: 18))
					    .underline()
						.foregroundColor(Color(red: 70 / 255, green: 70 / 255, blue: 70 / 255))
						.lineLimit(2)
						.padding(.trailing, 5)
				}
			}
		}.padding(.bottom, 10)
		 .padding(.horizontal, 20)
	}
}
