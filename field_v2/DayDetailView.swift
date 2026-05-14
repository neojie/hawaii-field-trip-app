import SwiftUI

struct DayDetailView: View {
    let day: TripDay

    var body: some View {
        List {
            Section("Theme") {
                Text(day.theme)
                    .font(.headline)
            }

            Section("Summary") {
                Text(day.summary)
            }

            if !day.logistics.isEmpty {
                Section("Logistics") {
                    Text(day.logistics)
                }
            }

            Section("Stops") {
                ForEach(day.stops) { stop in
                    NavigationLink(value: stop) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(stop.name)
                                .font(.headline)
                            if !stop.locationHint.isEmpty {
                                Text(stop.locationHint)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(stop.details)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(3)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(day.title)
        .navigationDestination(for: TripStop.self) { stop in
            StopDetailView(stop: stop)
        }
    }
}
