//
//  acknowledges.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/26/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import Ink
import SwiftUI
import WebKit

struct acknowledges: View {

	var body: some View {
		Webview()
			.edgesIgnoringSafeArea(.top)
	}
}

struct acknowledges_Previews: PreviewProvider {
	static var previews: some View {
		acknowledges()
	}
}
struct Webview: UIViewRepresentable {

	func makeUIView(context: Context) -> WKWebView {
		let parser = MarkdownParser()
		let myFileURL = Bundle.main.url(forResource: "Pods-Italian Food Forever-acknowledgements", withExtension: "markdown")!
		let myText = try! String(contentsOf: myFileURL, encoding: String.Encoding.isoLatin1)
		let html = parser.html(from: myText)
		let webView = WKWebView()
		webView.loadHTMLString(html, baseURL: nil)
		return webView
	}

	func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Webview>) {
	}
}
