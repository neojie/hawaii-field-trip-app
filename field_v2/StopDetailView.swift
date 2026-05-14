import SwiftUI
import PhotosUI
import UIKit
import CoreLocation

struct StopDetailView: View {
    let stop: TripStop
    @EnvironmentObject var store: FieldTripStore
    @EnvironmentObject var locationManager: LocationManager

    @State private var noteText = ""
    @State private var photoCaption = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var libraryImage: UIImage?
    @State private var showCamera = false
    @State private var cameraImage: UIImage?

    var body: some View {
        List {
            Section("Stop Information") {
                Text(stop.name).font(.headline)
                if !stop.locationHint.isEmpty {
                    Text(stop.locationHint)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(stop.details)
            }

            if !stop.activities.isEmpty {
                Section("Activities") {
                    ForEach(stop.activities, id: \.self) { activity in
                        Text("• \(activity)")
                    }
                }
            }

            if !stop.questions.isEmpty {
                Section("Questions") {
                    ForEach(stop.questions, id: \.self) { question in
                        Text(question)
                    }
                }
            }

            Section("Current Location") {
                Button("Refresh Location") {
                    locationManager.requestLocation()
                }

                if let location = locationManager.lastLocation {
                    Text("\(location.coordinate.latitude, specifier: "%.5f"), \(location.coordinate.longitude, specifier: "%.5f")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No location available")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Add Note") {
                TextEditor(text: $noteText)
                    .frame(minHeight: 120)

                Button("Save Note") {
                    store.addNote(stopID: stop.id, text: noteText, location: locationManager.lastLocation)
                    noteText = ""
                }
            }

            Section("Add Photo") {
                Button("Take Photo") {
                    showCamera = true
                }

                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Label("Choose Photo from Library", systemImage: "photo")
                }

                if let image = libraryImage ?? cameraImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 220)
                }

                TextField("Caption", text: $photoCaption)

                Button("Save Photo") {
                    guard let image = libraryImage ?? cameraImage else { return }
                    store.addPhoto(stopID: stop.id, image: image, caption: photoCaption, location: locationManager.lastLocation)
                    libraryImage = nil
                    cameraImage = nil
                    photoCaption = ""
                }
            }

            let savedNotes = store.notesForStop(stop.id)
            if !savedNotes.isEmpty {
                Section("Saved Notes") {
                    ForEach(savedNotes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.text)
                            if let coord = store.coordinateText(latitude: note.latitude, longitude: note.longitude) {
                                Text("Location: \(coord)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            let savedPhotos = store.photosForStop(stop.id)
            if !savedPhotos.isEmpty {
                Section("Saved Photos") {
                    ForEach(savedPhotos) { photo in
                        VStack(alignment: .leading, spacing: 8) {
                            if let image = store.image(for: photo) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 220)
                            }

                            if !photo.caption.isEmpty {
                                Text(photo.caption)
                            }

                            if let coord = store.coordinateText(latitude: photo.latitude, longitude: photo.longitude) {
                                Text("Location: \(coord)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Text(photo.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(stop.name)
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $cameraImage)
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                guard let data = try? await newItem?.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else { return }
                libraryImage = image
            }
        }
    }
}
