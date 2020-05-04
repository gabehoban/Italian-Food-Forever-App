//
//  Utils.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Foundation
import Bugsnag

class utils {
	// MARK: - Title Formatter (Removes "{" and "}")
	func formatTitle(str: String) throws -> String {
		if str.contains("{") {
			let str1 = (str.replacingOccurrences(of: "{", with: "(")
				.replacingOccurrences(of: "}", with: ")"))
			return str1
		} else {
			return str
		}
	}

	func stripHTML(str: String) throws -> String {
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

	func formatYield(str: String, title: String) throws -> String {
		var toReturn = ""
		let strippedStr = (((str.replacingOccurrences(of: "</p>", with: "")
			.replacingOccurrences(of: "\n", with: ""))
			.replacingOccurrences(of: "\t", with: ""))
			.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
		if strippedStr.contains("Serves ") {
			let brokenStr = strippedStr.components(separatedBy: "Serves ")
			if brokenStr[1].contains("Prep Time") {
				let yield = brokenStr[1].components(separatedBy: "Prep Time")
				let fullYield = "Serves \(yield[0])"
				toReturn = fullYield
			} else if brokenStr[1].contains("Cook Time") {
				let yield = brokenStr[1].components(separatedBy: "Cook Time")
				let fullYield = "Serves \(yield[0])"
				toReturn = fullYield
			} else if brokenStr[1].contains("\",\"") {
				let yield = brokenStr[1].components(separatedBy: "\",\"")
				let fullYield = "Serves \(yield[0])"
				toReturn = fullYield
			} else {
				//ERROR
				let tmp = brokenStr.joined(separator: ", ")
				LOG(error: "Yield Error", value: tmp, title: title)
				return "N/A"
			}
		} else if strippedStr.contains("Yield: ") {
			let brokenStr = strippedStr.components(separatedBy: "Yield: ")
			if brokenStr[1].contains("Prep Time") {
				let yield = brokenStr[1].components(separatedBy: "Prep Time")
				let fullYield = "\(yield[0])"
				toReturn = fullYield
			} else {
				//ERROR
				let tmp = brokenStr.joined(separator: ", ")
				LOG(error: "Yield Error", value: tmp, title: title)
				return "N/A"
			}
		} else {
			//ERROR
			let tmp = strippedStr
			LOG(error: "Yield Error", value: tmp, title: title)
			return "N/A"
		}
		return toReturn

	}

	func formatTime(str: String, title: String) throws -> String {
		var toReturn = ""
		let strippedStr = (((str.replacingOccurrences(of: "</p>", with: "")
			.replacingOccurrences(of: "\n", with: ""))
			.replacingOccurrences(of: "\t", with: ""))
			.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
		if strippedStr.contains("\"totalTime\":\"PT") {
			let brokenStr = strippedStr.components(separatedBy: "\"totalTime\":\"PT")
			let time = brokenStr[1].components(separatedBy: "M")
			if time[0].prefix(3).contains("H") {
				let hour = time[0].components(separatedBy: "H")
				let minutes = hour[1]
				toReturn = ("\(hour[0])H \(minutes)min")
				return toReturn
			}
			// Check if time is valid
			let num = Int(time[0])
			if num != nil { } else if time[0].prefix(1).contains("0") {
				return "N/A"
			} else {
				//ERROR
				let tmp = time.joined(separator: ", ")
				LOG(error: "Time Error", value: tmp, title: title)
				return "N/A"
			}
			let fullTime = time[0] + "min"
			return fullTime
		} else if strippedStr.contains("Total Time: ") {
			let brokenStr = strippedStr.components(separatedBy: "Total Time: ")
			if brokenStr[1].contains("hour") {
				let time = brokenStr[1].components(separatedBy: "hour")
				toReturn = "\(time[0]) Hour"
			} else if brokenStr[1].contains("minutes") {
				let time = brokenStr[1].components(separatedBy: "minutes")
				toReturn = "\(time[0])min"
			} else {
				//ERROR
				let tmp = brokenStr.joined(separator: ", ")
				LOG(error: "Time Error", value: tmp, title: title)
				return "N/A"
			}
		} else {
			// ERROR
			let tmp = strippedStr
			LOG(error: "Time Error", value: tmp, title: title)
			return "N/A"
		}
		return toReturn
	}

	func formatIngredients(str: String) throws -> [String] {
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

	func formatSteps(str: String) throws -> [String] {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = (str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\\u2028", with: ""))
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			// To guard against blog posts
			if !notHTML[0].contains("Nutrition Information:") {
				return []
			}
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

	func formatDate(posted: String) throws -> String {
		let formatter1 = DateFormatter()
		let formatter2 = DateFormatter()
		formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let s = formatter1.date(from: posted)!
		formatter2.dateStyle = .short
		let date = formatter2.string(from: s)
		return date
	}

	func LOG(error: String, value: String, title: String) {
		Bugsnag.notify(NSException(name: NSExceptionName(rawValue: error),
		                           reason: title,
		                           userInfo: nil))
	}
}
