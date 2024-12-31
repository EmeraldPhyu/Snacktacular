//
//  Photo.swift
//  Snacktacular
//
//  Created by Emerald on 30/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Photo: Identifiable, Codable {
	@DocumentID var id: String?
	var imageURLString = "" // This will hold the URL for loading the image
	var description = ""
	var reviewer: String = Auth.auth().currentUser?.email ?? ""
	var postedOn = Date() //current date/time
	init(id: String? = nil, imageURLString: String = "", description: String = "", reviewer: String = (Auth.auth().currentUser?.email ?? ""), postedOn: Date = Date()) {
		self.id = id
		self.imageURLString = imageURLString
		self.description = description
		self.reviewer = reviewer
		self.postedOn = postedOn
	}
}
//Mock Data
extension Photo {
	static var preview: Photo {
		let newPhoto = Photo(
			id: "1",
			imageURLString: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/2014_0531_Cr%C3%A8me_br%C3%BBl%C3%A9e_Doi_Mae_Salong_%28cropped%29.jpg/1024px-2014_0531_Cr%C3%A8me_br%C3%BBl%C3%A9e_Doi_Mae_Salong_%28cropped%29.jpg", description: "Cream Brulee",
			reviewer: "jojo@kissyface.com",
			postedOn: Date())
		return newPhoto
	}
}
