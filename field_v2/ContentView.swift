import SwiftUI
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var store: FieldTripStore
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        NavigationStack {
            List {
                Section("Student Information") {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.profile.studentName.isEmpty ? "Enter your name" : store.profile.studentName)
                                .font(.headline)
                            Text(store.profile.projectTitle.isEmpty ? "Enter your project title" : store.profile.projectTitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Location") {
                    Button("Allow / Refresh Location") {
                        locationManager.requestPermission()
                        locationManager.requestLocation()
                    }

                    if let location = locationManager.lastLocation {
                        Text("Current location: \(location.coordinate.latitude, specifier: "%.5f"), \(location.coordinate.longitude, specifier: "%.5f")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No location captured yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Trip Overview") {
                    Text("Princeton Geosciences Hawai‘i Field Trip")
                        .font(.headline)
                    Text("May 14–22, 2026. Use this app to review stops, take notes/photos, save GPS coordinates, and export a field report.")
                        .foregroundStyle(.secondary)
                }

                Section("Agenda") {
                    ForEach(store.tripDays) { day in
                        NavigationLink(value: day) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(day.title)
                                    .font(.headline)
                                Text(day.date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(day.theme)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Export") {
                    NavigationLink {
                        ReportView()
                    } label: {
                        Label("Preview / Export Field Report", systemImage: "square.and.arrow.up")
                    }
                }

                Section("Admin") {
                    Button("Reset agenda to guidebook version") {
                        store.resetAgendaToGuidebookVersion()
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Hawai‘i Field Trip")
            .navigationDestination(for: TripDay.self) { day in
                DayDetailView(day: day)
            }
            .onAppear {
                locationManager.requestPermission()
                locationManager.requestLocation()
            }
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var store: FieldTripStore
    @State private var studentName: String = ""
    @State private var projectTitle: String = ""

    var body: some View {
        Form {
            Section("Student") {
                TextField("Student Name", text: $studentName)
                TextField("Project Title", text: $projectTitle)
            }

            Section {
                Button("Save") {
                    store.profile.studentName = studentName
                    store.profile.projectTitle = projectTitle
                    store.saveProfile()
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            studentName = store.profile.studentName
            projectTitle = store.profile.projectTitle
        }
    }
}
