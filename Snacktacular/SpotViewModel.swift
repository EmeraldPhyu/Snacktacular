//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Emerald on 29/12/24.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel {
	static func saveSpot(spot:Spot) async -> String? { // nil if effor failed, otherwise return spot.id
		let db = Firestore.firestore()
		if let id = spot.id { //spot must already exist, so save
			do {
				try db.collection("spots").document(id).setData(from:spot)
				print("Data is updated successfully!")
				return id
			} catch {
				print("Error: Could not update data in 'Spots\(error.localizedDescription)'")
				return id
			}
		}else {
			do{
				let docRef = try db.collection("spots").addDocument(from: spot)
				print("Data added successfully!")
				return docRef.documentID
			} catch {
				print("Error: Could not add data in 'Spots\(error.localizedDescription)'")
				return nil
			}
		}
	}
//Static ~ so can refer by type name, not by creating an instance of the type
static func deleteSpot(spot: Spot) {
		let db = Firestore.firestore()
		guard let id = spot.id else{
			print("No spot.id")
			return
		}
		Task{ //asynchronous
			do{
				try await db.collection("spots").document(id).delete()
			}catch{
				print("ERROR: cannot delete the spot \( id).\(error.localizedDescription)")
			}
		}
	}
}
