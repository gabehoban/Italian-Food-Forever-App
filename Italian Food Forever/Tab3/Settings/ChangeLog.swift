//
//  ChangeLog.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 4/9/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct ChangeLog: View {
	init() {
		UITableView.appearance().separatorStyle = .none
	}
	var body: some View {
		VStack {
			List {
				// MARK: - 2020.4.1
				Section(header: label(version: "2020.4.1", date: "April 9, 2020")) {
					Text("What's New").fontWeight(.medium)
					changes(detail: [
						"Adjusted spacing between the featured recipie and the Recent Posts row.",
						"Rebuild the settings page.",
						"Added mail to self feature to ingredients list.",
						"Changed search results into box with image instead of only a list."
					]).padding(.top, -10)
				}

				// MARK: - 2020.4.0
				Section(header: label(version: "2020.4.0", date: "April 8, 2020")) {
					Text("What's New").fontWeight(.medium)
					changes(detail: ["First Build"]).padding(.top, -10)
				}
			}
			Spacer()
		}
	}
}
struct changes: View {
	let detail: [String]
	var body: some View {
		ForEach(detail, id: \.self) { change in
			HStack {
				Text("\u{2022} ")
				+ Text(change)
			}
		}
	}
}
struct label: View {
	let version: String
	let date: String
	var body: some View {
		HStack {
			Text(version)
				.font(.system(size: 35, weight: .heavy, design: .rounded))
				.foregroundColor(.black)
			Spacer()
			Text(date)
		}
	}
}
struct ChangeLog_Previews: PreviewProvider {
	static var previews: some View {
		ChangeLog()
	}
}
