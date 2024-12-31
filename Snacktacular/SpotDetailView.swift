//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Emerald on 29/12/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SpotDetailView: View {
	
	@FirestoreQuery(collectionPath: "spots") var fsPhotos : [Photo]
	@State var spot: Spot //pass in value from Listview
	@State private var photoSheetIsPresented = false
	@State private var showingAlert = false //Alert User if they need to save Spot before adding a photo
	@State private var alertMessage = "Cannot find a photo until you save the spot."
	@Environment(\.dismiss) private var dismiss
	
	private var photos:[Photo] {
		//If running in preview then show mock data
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
			return [Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview]
		}else{
			return fsPhotos
		}
	}
	
    var body: some View {
			VStack {
				Group {
					TextField("Name", text: $spot.name)
						.font(.title)
					TextField("Location", text: $spot.location)
						.font(.title2)
					TextField("Address", text: $spot.address)
						.font(.title3)
					
				}.textFieldStyle(.roundedBorder)
					.autocorrectionDisabled()
					.overlay {
						RoundedRectangle(cornerRadius: 5)
							.stroke(.gray.opacity(0.5), lineWidth: 1.0)
					}.padding(.horizontal)
				Button{
					if spot.id == nil {
						showingAlert.toggle()
					}else{
						photoSheetIsPresented.toggle()
					}
				} label: {
					Image(systemName: "camera.fill")
					Text("Photo")
				}.bold()
					.buttonStyle(.borderedProminent)
					.tint(.snack)

				ScrollView(.horizontal){
					HStack {
						ForEach(photos) { photo in
							let url = URL(string: photo.imageURLString)
							AsyncImage(url: url) { image in
								image
									.resizable()
									.scaledToFill()
									.frame(width: 80,height: 80)
									.clipped()
							} placeholder: {
								ProgressView()
							}
						}
					}
				}
				
				
				
				Spacer()
			}
			.navigationBarBackButtonHidden()
			.task {
				$fsPhotos.path = "spots/\(spot.id ?? "")/photos"
			}
			.toolbar{
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel"){
						dismiss()
					}
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save"){
					saveSpot()
					}
				}
			}
			.alert(alertMessage, isPresented:$showingAlert) {
				Button("Cancel", role: .cancel) {}
				Button("Save"){
					//We want to return spot.id after saving new spot. Right now it's nil
					Task{
						guard let id = await SpotViewModel.saveSpot(spot: spot) else{
							print("ERROR: Saving spot in alert returned nil")
							return
						}
						spot.id = id
						print("Spot Id: \(id)")
						photoSheetIsPresented.toggle() // Now present sheet of photoview
					}
				}
			}
			.fullScreenCover(isPresented: $photoSheetIsPresented, content: {
				PhotoView(spot: spot)
			})
    }
	func saveSpot() {
		Task {
			guard let id = await SpotViewModel.saveSpot(spot: spot) else {
				print("ERROR: Saving spot in alert returned nil")
				return
			}
			spot.id = id
			print("Spot Id: \(id)")
			photoSheetIsPresented.toggle() // Now present sheet of photoview
		}
	}
}

#Preview {
	NavigationStack{
		SpotDetailView(spot: Spot(id: "1", name: "Boston Public Market", location: "Boston", address: "Boston,MA")) //create new Spot
	}
}
