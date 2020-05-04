//
//  cardsRow.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import HTMLString
import Lottie
import SDWebImageSwiftUI
import SwiftUI
import SwiftyJSON
import WebKit

struct cardsRow1: View {
	@ObservedObject private var list = getData(newUrl: "posts?per_page=14&offset=1&categories_exclude=7&_fields=id,excerpt,content,title,mv,date,link&_envelope", offset: 1, delay: 1.0)

	let loadingAnimation1 = AnimationView(name: "loading")

	func formatTitle(str: String) -> String {
		if str.contains("{") {
			let str1 = (str.replacingOccurrences(of: "{", with: "(")
				.replacingOccurrences(of: "}", with: ")"))
			return str1
		} else {
			return str
		}
	}

	@State var loading = true

	func chunked(data: [dataType]) -> [[dataType]] {
		let chunkedRecipe = data.chunked(into: 2)
		return chunkedRecipe
	}
// MARK: - BODY
	var body: some View {
		VStack {
			Spacer()
			if list.datas.count < 10 {
				LottieView()
					.frame(width: 200, height: 100)
			}
			VStack {
				Spacer()
				// Array
				ForEach(0..<chunked(data: list.datas).count, id: \.self) { index in
					HStack {
						ForEach(self.chunked(data: self.list.datas)[index]) { i in
							NavigationLink(destination:
								DetailView(detail: i)) {
								ZStack {
									Rectangle()
										.frame(width: 180.0, height: 180)
										.foregroundColor(Color.white)
										.cornerRadius(12)
										.shadow(color: Color.black.opacity(0.2), radius: 8, x: 3, y: 3)
										.opacity(0.8)
										.animation(.easeIn)
									Spacer()
									VStack {
										WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
											.renderingMode(.original)
											.resizable()
											.placeholder {
												Rectangle().foregroundColor(.gray)
											}
											.indicator(.activity)
											.animation(.easeInOut(duration: 0.5))
											.frame(width: 180, height: 125)
										HStack {
											Text(self.formatTitle(str: i.title)
												.removingHTMLEntities)
												.font(.subheadline)
												.fontWeight(.semibold)
												.fixedSize(horizontal: false, vertical: true)
												.foregroundColor(Color.black)
												.lineLimit(2)
												.padding(.bottom, 10)
												.padding(.leading, 12)
											Spacer()
										}
										Spacer()
									}
								}.padding(.bottom, 5)
							}
						}
					}.padding(.horizontal, 15)
				}
			}
			Spacer()
		}.padding(.vertical, 40)
			.padding(.bottom, 45)
	}
}

struct cardsRow1_Previews: PreviewProvider {
	static var previews: some View {
		cardsRow1()
			.previewLayout(.sizeThatFits)
	}
}

extension Array {
	func chunked(into size: Int) -> [[Element]] {

		var chunkedArray = [[Element]]()

		for index in 0...self.count {
			if index % size == 0 && index != 0 {
				chunkedArray.append(Array(self[(index - size)..<index]))
			} else if index == self.count {
				if index > 0 {
					chunkedArray.append(Array(self[index - 1..<index]))
				}
			}
		}

		return chunkedArray
	}
}
struct LottieView: UIViewRepresentable {
	func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
		let view = UIView(frame: .zero)

		let animationView = AnimationView()
		let animation = Animation.named("loading")
		animationView.animation = animation
		animationView.contentMode = .scaleAspectFit
		animationView.loopMode = LottieLoopMode.loop
		animationView.play()

		animationView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(animationView)

		NSLayoutConstraint.activate([
			animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
			animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
		])
		return view
	}

	func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) { }

	typealias UIViewType = UIView
}
