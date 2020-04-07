//
//  Utils.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Foundation


class utils {
	func formatTitle(str: String) -> String {
		if str.contains("{") {
			let str1 = (str.replacingOccurrences(of: "{", with: "(")
				.replacingOccurrences(of: "}", with: ")"))
			return str1
		} else {
			return str
		}
	}

	func stripHTML(str: String) -> String {
		let str = (((((str.replacingOccurrences(of: "\n", with: "", options: .regularExpression, range: nil)
			.replacingOccurrences(of: "></p>", with: ""))
			.replacingOccurrences(of: "</p>", with: "\n\n"))
			.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
			.replacingOccurrences(of: "Deborah Mele", with: "\nDeborah Mele\n{ENDME}", options: .regularExpression, range: nil))
			.replacingOccurrences(of: "Debrah Mele", with: "\nDeborah Mele\n{ENDME}", options: .regularExpression, range: nil))

		let brokenString = str.components(separatedBy: "{ENDME}")
		let brokenString1 = brokenString[0].components(separatedBy: "{\"@context")

		return brokenString1[0].removingHTMLEntities
	}

	func formatYield(str: String, title: String) -> String {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: title.removingHTMLEntities)
			print(datePublished)
			print(datePublished.count)
			if datePublished[0].contains("Yield:") {
				let frontYield = datePublished[0].components(separatedBy: "Prep Time:")
				let sanitizedY = ((frontYield[0].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "Yield:")
				return yield[1]
			} else if datePublished[1].contains("Yield:") {
				let frontYield = datePublished[1].components(separatedBy: "Prep Time:")
				let sanitizedY = ((frontYield[0].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "Yield:")
				return yield[1]
			} else if datePublished[2].contains("Yield:") {
				let frontYield = datePublished[2].components(separatedBy: "Prep Time:")
				let sanitizedY = ((frontYield[0].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "Yield:")
				return yield[1]
			} else if datePublished[3].contains("Yield:") {
				let frontYield = datePublished[3].components(separatedBy: "Prep Time:")
				let sanitizedY = ((frontYield[0].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "Yield:")
				return yield[1]
			} else {
				return ""
			}
		} else {
			let nothtml = notHTML[1]
			let frontYield = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: "\",\"description"))
			let yield = frontYield[0].components(separatedBy: "recipeYield\":\"")
			print(yield[1])
			if yield[1].contains("image") {
				let returnYield = yield[1].components(separatedBy: "\",")
				return returnYield[0]
			} else {
				let returnYield = yield[1]
				return returnYield
			}
		}

	}

	func formatTime(str: String, title: String) -> String {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		print(notHTML)
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: title.removingHTMLEntities)
			if datePublished.firstIndex(of: "Total Time:") != nil {
				if datePublished[1].contains("Cook Time:") {
					let frontYield = datePublished[1].components(separatedBy: "Cook Time:")
					let sanitizedY = ((frontYield[1].replacingOccurrences(of: "\n", with: ""))
						.replacingOccurrences(of: "\t", with: ""))
					// print(sanitizedY)
					let yield = sanitizedY.components(separatedBy: "minutes")
					let toReturn = yield[0] + " min"
					print(toReturn)
					return toReturn
				}
			}
			if datePublished[0].contains("Total Time:") {
				let frontYield = datePublished[0].components(separatedBy: "Total Time:")
				let sanitizedY = ((frontYield[1].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "minutes")
				let toReturn = yield[0] + " min"
				print(toReturn)
				return toReturn
			} else if datePublished[1].contains("Total Time:") {
				let frontYield = datePublished[1].components(separatedBy: "Total Time:")
				let sanitizedY = ((frontYield[1].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "minutes")
				let toReturn = yield[0] + " min"
				return toReturn
			} else if datePublished[2].contains("Total Time:") {
				let frontYield = datePublished[2].components(separatedBy: "Total Time:")
				let sanitizedY = ((frontYield[1].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "minutes")
				let toReturn = yield[0] + " min"
				return toReturn
			} else if datePublished[3].contains("Total Time:") {
				let frontYield = datePublished[3].components(separatedBy: "Total Time:")
				let sanitizedY = ((frontYield[1].replacingOccurrences(of: "\n", with: ""))
					.replacingOccurrences(of: "\t", with: ""))
				let yield = sanitizedY.components(separatedBy: "minutes")
				let toReturn = yield[0] + " min"
				return toReturn
			} else {
				return ""
			}
		} else {
			let nothtml = notHTML[1]
			let frontYield = ((((nothtml.replacingOccurrences(of: "\\", with: ""))
				.replacingOccurrences(of: "PT", with: ""))
				.replacingOccurrences(of: "M", with: " min"))
				.components(separatedBy: "\",\"recipeIngredient"))
			let yield = frontYield[0].components(separatedBy: "totalTime\":\"")
			print(yield[1])
			if yield[1].contains("image") {
				let returnYield = yield[1].components(separatedBy: "\",")
				return returnYield[0]
			} else {
				let returnYield = yield[1]
				print(returnYield)
				return returnYield
			}
		}

	}


	func formatIngredients(str: String) -> [String] {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: "Ingredients")
			let Ingredients = datePublished[1].components(separatedBy: "Instructions")
			let sanitizedY = (((Ingredients[0].replacingOccurrences(of: "", with: ""))
				.replacingOccurrences(of: "\\t", with: ""))
				.replacingOccurrences(of: "\r", with: ""))
			let toArray4 = (sanitizedY.replacingOccurrences(of: "\t", with: "").removingHTMLEntities)
			var toReturn = toArray4.components(separatedBy: "\n")
			toReturn.removeAll { $0 == "" }
			return toReturn

		} else {
			let nothtml = notHTML[1]
			let frontIngredients = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: ",\"recipeInstructions"))
			let Ingredients = frontIngredients[0].components(separatedBy: "recipeIngredient\":")
			let toArray1 = Ingredients[1].replacingOccurrences(of: "\\/", with: "/")
			let toArray2 = toArray1.replacingOccurrences(of: "\\", with: "")
			let toArray3 = toArray2.replacingOccurrences(of: ",", with: ", ")
			let toArray4 = (((toArray3
				.replacingOccurrences(of: "[\"", with: "")
				.replacingOccurrences(of: "\"]", with: ""))
				.replacingOccurrences(of: "\"\"]", with: ""))
				.removingHTMLEntities)

			var toReturn = toArray4.components(separatedBy: "\", \"")
			toReturn.removeAll { $0 == "" }
			return toReturn
		}
	}
	func formatSteps(str: String) -> [String] {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: "Instructions")
			let frontIngredients = datePublished[1].components(separatedBy: "Nutrition Information:")
			let Ingredients = frontIngredients[0].components(separatedBy: "recipeInstructions\":")
			let sanitizedY = (((Ingredients[0].replacingOccurrences(of: "\n", with: ""))
				.replacingOccurrences(of: "\t", with: ""))
				.replacingOccurrences(of: "\r", with: ""))
			let toArray4 = (sanitizedY.replacingOccurrences(of: " \t", with: "")
				.replacingOccurrences(of: "F.", with: "F"))
			if toArray4.contains("&copy") {
				let array5 = toArray4.components(separatedBy: "&copy")
				if array5[0].contains("Recommended Products") {
					let array6 = array5[0].components(separatedBy: "Recommended Products")
					var toReturn = array6[0].components(separatedBy: ".")
					toReturn.removeAll { $0 == "" }
					return toReturn
				}
				var toReturn = array5[0].components(separatedBy: ".")
				toReturn.removeAll { $0 == "" }
				return toReturn
			} else {
				if toArray4.contains("Recommended Products") {
					let array5 = toArray4.components(separatedBy: "Recommended Products")
					let toReturn = array5[0].components(separatedBy: ".")
					return toReturn
				} else {
					let toReturn = toArray4.components(separatedBy: ".")
					return toReturn
				}
			}


		} else {
			let nothtml = notHTML[1]
			var frontIngredients = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: ",\"url"))
			if frontIngredients[0].contains("keywords") {
				frontIngredients = frontIngredients[0].components(separatedBy: ",\"keywords")
			}
			let Ingredients = frontIngredients[0].components(separatedBy: "recipeInstructions\":")
			let toArray1 = Ingredients[1].replacingOccurrences(of: "\\/", with: "/")
			let toArray2 = toArray1.replacingOccurrences(of: "\\", with: "")
			let toArray3 = toArray2.replacingOccurrences(of: "{\"@type\":\"HowToStep\",\"text\":\"", with: "")
			let toArray4 = (((toArray3
				.replacingOccurrences(of: "\"}", with: "")
				.replacingOccurrences(of: "[", with: ""))
				.replacingOccurrences(of: "]", with: ""))
				.replacingOccurrences(of: "..", with: ""))
			if toArray4.contains("Recommended Products") {
				let five = toArray4.components(separatedBy: "Recommended Products")
				let toReturn = five[0].components(separatedBy: ".,")
				return toReturn
			} else {
				let five = toArray4
				let toReturn = five.components(separatedBy: ".,")
				return toReturn
			}

		}
	}
	func formatDate(posted: String) -> String {
		let formatter1 = DateFormatter()
		let formatter2 = DateFormatter()
		formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let s = formatter1.date(from: posted)!
		formatter2.dateStyle = .short
		let date = formatter2.string(from: s)
		return date
	}
}
