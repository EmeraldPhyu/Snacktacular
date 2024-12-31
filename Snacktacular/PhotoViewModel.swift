//
//  PhotoViewModel.swift
//  Snacktacular
//
//  Created by Emerald on 30/12/24.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import SwiftUI

class PhotoViewModel {
	static func saveImage(spot: Spot, photo: Photo, data: Data) async {
		guard let id = spot.id else {
			print("Error: Should never have been called without a valid spot id")
			return
		}
		let storage = Storage.storage().reference()
		let metadata = StorageMetadata()
		let photoName = UUID().uuidString // create a unique filename for the photo about to be saved
		metadata.contentType = "image/jpeg" //will allow image to be viewed in the browser from Firestore console
		let path = "\(id)/\(photoName)" //id is the name of spot doc. All photos for a spot will be saved in a "folder" with its spot doc name.
		do {
			let storageReference = storage.child(path)
			let returnedMetaData = try await storageReference.putDataAsync(data, metadata: metadata)
			print("\(returnedMetaData)")
			//get url that we will use to load the image
			guard let url = try? await storageReference.downloadURL() else {
				print("ERROR: Could download the image")
				return
			}
			photo.imageURLString = url.absoluteString
			print("photo.imageURLString: \(photo.imageURLString)")
			
			//Now that photo file is saved to Storage, save a photo document to the spot.id's "photos" collection
			let db = Firestore.firestore()
			do{
				try db.collection("spots").document(id).collection("photos").document(photoName).setData(from: photo)
			}catch{
				print("ERROR: could not update data in spots/\(id)/photos/\(photo.id ?? "n/a").\(error.localizedDescription)")
			}
			
		}catch{
			print("ERROR: cannot save photo to storage\(error.localizedDescription)")
		}
		
	}
}
