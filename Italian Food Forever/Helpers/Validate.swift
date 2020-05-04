//
//  Validate.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 5/2/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

class Validate {
	func validateArray(get: String, detail: dataType) -> [String] {
		switch get {
		case "steps":
			do {
				let steps: [String] = try utils().formatSteps(str: detail.content)
				return steps
			} catch {
				return [""]
			}
		case "ingredients":
			do {
				let ingredients: [String] = try utils().formatIngredients(str: detail.content)
				return ingredients
			} catch {
				return [""]
			}
		default:
			return [""]
		}
	}
	func errorTest(get: String, detail: dataType) -> String {
		switch get {
		case "title":
			do {
				let title = try utils().formatTitle(str: detail.title).removingHTMLEntities
				return title
			} catch {
				return ""
			}
		case "yield":
			do {
				let yield = try utils().formatYield(str: detail.content, title: detail.title)
				return yield
			} catch {
				return ""
			}
		case "date":
			do {
				let date = try utils().formatDate(posted: detail.date)
				return date
			} catch {
				return ""
			}
		case "html":
			do {
				let html = try utils().stripHTML(str: detail.content).removingHTMLEntities
				return html
			} catch {
				return ""
			}
		case "time":
			do {
				let time = try utils().formatTime(str: detail.content, title: detail.title)
				return time
			} catch {
				return ""
			}
		default:
			return ""
		}
	}
}
