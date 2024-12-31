//
//  PhotoView.swift
//  Snacktacular
//
//  Created by Emerald on 29/12/24.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
	@State var spot: Spot //passed in from SpotDetailView
	@State private var photo = Photo()
	@State private var data = Data() // we need to take image & convert it to data to save it
	@State private var selectedPhoto: PhotosPickerItem?
	@State private var pickerIsPresented = true // TODO: Switch to true
	@State private var selectedImage = Image(systemName: "photo")
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack{
			selectedImage
				.resizable()
				.scaledToFit()
			
			Spacer()
			TextField("Description", text: $photo.description).textFieldStyle(.roundedBorder)
			Text("by: \(photo.reviewer), on:\(photo.postedOn.formatted(date: .numeric, time: .omitted))")
			
				.toolbar{
					ToolbarItem(placement: .topBarLeading) {
						Button("Cancel") {
							dismiss()
						}
					}
					ToolbarItem(placement: .topBarTrailing) {
						Button("Save") {
							Task {
								await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
								dismiss()
							}
						}
					}
				}
				.photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
				.onChange(of: selectedPhoto) {
					//turn selectedPhoto into a useableImageView
					Task{
						do{
							if let image = try await selectedPhoto?.loadTransferable(type: Image.self){
								selectedImage = image
							}
							//Get raw date from image so we can save it to Firebase Storage
							guard let transferredData = try await
											selectedPhoto?.loadTransferable(type: Data.self)
							else {
								print("ERROR: Could not convert data from selectedPhoto.")
								return
							}
							data = transferredData
						}catch{
							print("ERROR: cannot create image from selected photo\(error.localizedDescription)")
						}
					}
				}
		}.padding()
	}
}

#Preview {
	PhotoView(spot: Spot())
}
