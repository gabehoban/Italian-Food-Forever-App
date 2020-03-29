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
		print(str)
		let brokenString = str.components(separatedBy: "{ENDME}")
		let brokenString1 = brokenString[0].components(separatedBy: "{\"@context")
		print(brokenString1[0])
		return brokenString1[0].removingHTMLEntities
	}
	
	func formatYield(str: String, title: String) -> String {
		let str1 = str.replacingOccurrences(of: "</p>", with: "\n")
		let str = str1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
		let notHTML = str.components(separatedBy: "context")
		if notHTML.count == 1 {
			let datePublished = notHTML[0].components(separatedBy: title.removingHTMLEntities)
			let frontYield = datePublished[1].components(separatedBy: "Prep Time")
			let sanitizedY = ((frontYield[0].replacingOccurrences(of: "\n", with: ""))
				.replacingOccurrences(of: "\t", with: ""))
			let yield = sanitizedY.components(separatedBy: "Yield:")
			return yield[1]
		} else {
			let nothtml = notHTML[1]
			let frontYield = (nothtml.replacingOccurrences(of: "\\", with: "")
				.components(separatedBy: "\",\"description"))
			let yield = frontYield[0].components(separatedBy: "recipeYield\":\"")
			return yield[1]
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
			let toArray4 = sanitizedY.replacingOccurrences(of: "\t", with: "")
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
			let toArray4 = ((toArray3
				.replacingOccurrences(of: "[\"", with: "")
				.replacingOccurrences(of: "\"]", with: ""))
				.replacingOccurrences(of: "\"\"]", with: ""))
			
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
			let toReturn = toArray4.components(separatedBy: ".")
			return toReturn
			
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
				.replacingOccurrences(of: "..", with: "."))
			
			let toReturn = toArray4.components(separatedBy: ".,")
			return toReturn
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
