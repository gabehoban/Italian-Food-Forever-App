//
//  dataType.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/29/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct dataType: Identifiable {
	var id: String
	var url: String
	var date: String
	var title: String
	var excerpt: String
	var image: String
	var content: String
}

struct searchType: Identifiable {
	var id: String
	var title: String
}
