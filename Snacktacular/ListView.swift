//
//  ListView.swift
//  Snacktacular
//
//  Created by Emerald on 29/12/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ListView: View {
	@FirestoreQuery(collectionPath: "spots") var spots : [Spot] //loads all "spots" documents into the array variables named spots
	@Environment(\.dismiss) private var dismiss
	@State private var sheetIsPresented = false
    var body: some View {
			NavigationStack {
				List(spots) { spot in
					NavigationLink {
						SpotDetailView(spot: spot)
					} label: {
						HStack{
							Text(spot.name)
								.font(.title2)
							Spacer()
							Text("@\(spot.location)")
								.font(.caption)
						}
					}.swipeActions{
						Button("Delete", role: .destructive){
						 SpotViewModel.deleteSpot(spot: spot)
					 }
				 }
				}
				.listStyle(.plain)
				.navigationTitle("Snack Spots:")
				.toolbar{
					ToolbarItem(placement: .topBarLeading) {
						Button("Sign Out") {
							do {
								try Auth.auth().signOut()
								dismiss()
								print("LOG OUT Successful!")
							} catch {
								print("ERROR: Could not sign out!")
							}
						}
					}
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							sheetIsPresented = true
						}label: {
							Image(systemName: "plus")
						}
					}
				}
				.sheet(isPresented: $sheetIsPresented, content: {
					NavigationStack {
						SpotDetailView(spot: Spot())
					}
				})
			}
    }
}

#Preview {
    ListView()
}
