//
//  Spot.swift
//  Snacktacular
//
//  Created by Emerald on 29/12/24.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
	@DocumentID var id: String?
	var name = ""
	var location = ""
	var address = ""
}
extension Spot {
	static var previewSpot : Spot {
		let newSpot = Spot(id: "1", name: "Central Mart", location: "Central", address: "Central Area")
		return newSpot
	}
}
