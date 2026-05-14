import SwiftUI
import UIKit

struct ReportView: View {
    @EnvironmentObject var store: FieldTripStore
    @State private var showShareSheet = false
    @State private var exportedURL: URL?

    var body: some View {
        List {
            Section("Report Information") {
                Text(store.profile.studentName.isEmpty ? "Student: (not entered)" : "Student: \(store.profile.studentName)")
                Text(store.profile.projectTitle.isEmpty ? "Project: (not entered)" : "Project: \(store.profile.projectTitle)")
            }

            ForEach(store.tripDays) { day in
                Section(day.title) {
                    Text(day.summary)

                    ForEach(day.stops) { stop in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(stop.name).font(.headline)
                            Text(stop.details)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            let stopNotes = store.notesForStop(stop.id)
                            if !stopNotes.isEmpty {
                                Text("Notes").font(.subheadline)
                                ForEach(stopNotes) { note in
                                    Text("• \(note.text)")
                                }
                            }

                            let stopPhotos = store.photosForStop(stop.id)
                            if !stopPhotos.isEmpty {
                                Text("Photos").font(.subheadline)
                                ForEach(stopPhotos) { photo in
                                    if let image = store.image(for: photo) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight: 140)
                                    }
                                    if !photo.caption.isEmpty {
                                        Text(photo.caption).font(.caption)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }

            Section {
                Button("Export PDF") {
                    exportPDF()
                }
            }
        }
        .navigationTitle("Field Report")
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedURL {
                ShareSheet(activityItems: [url])
            } else {
                Text("PDF not found")
            }
        }
    }

    private func exportPDF() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("Hawaii_Field_Trip_Report.pdf")

        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let margin: CGFloat = 36
        let contentWidth = pageRect.width - margin * 2

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        do {
            try renderer.writePDF(to: url) { context in
                var y: CGFloat = margin

                func newPage() {
                    context.beginPage()
                    y = margin
                }

                func drawText(_ text: String, font: UIFont, color: UIColor = .black, spacing: CGFloat = 8) {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineBreakMode = .byWordWrapping

                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: font,
                        .foregroundColor: color,
                        .paragraphStyle: paragraph
                    ]

                    let rect = NSString(string: text).boundingRect(
                        with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                        attributes: attrs,
                        context: nil
                    )

                    if y + rect.height > pageRect.height - margin {
                        newPage()
                    }

                    NSString(string: text).draw(
                        with: CGRect(x: margin, y: y, width: contentWidth, height: rect.height),
                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                        attributes: attrs,
                        context: nil
                    )

                    y += rect.height + spacing
                }

                func drawImage(_ image: UIImage, caption: String?) {
                    let maxHeight: CGFloat = 220
                    let aspect = image.size.width / max(image.size.height, 1)
                    var imageWidth = contentWidth
                    var imageHeight = imageWidth / aspect

                    if imageHeight > maxHeight {
                        imageHeight = maxHeight
                        imageWidth = imageHeight * aspect
                    }

                    if y + imageHeight > pageRect.height - margin {
                        newPage()
                    }

                    let x = margin + (contentWidth - imageWidth) / 2
                    image.draw(in: CGRect(x: x, y: y, width: imageWidth, height: imageHeight))
                    y += imageHeight + 6

                    if let caption = caption, !caption.isEmpty {
                        drawText("Caption: \(caption)", font: .italicSystemFont(ofSize: 11), color: .darkGray, spacing: 10)
                    }
                }

                newPage()

                drawText("Hawai‘i Field Trip Report", font: .boldSystemFont(ofSize: 24), spacing: 12)
                drawText("Student: \(store.profile.studentName.isEmpty ? "Not entered" : store.profile.studentName)", font: .systemFont(ofSize: 13))
                drawText("Project Title: \(store.profile.projectTitle.isEmpty ? "Not entered" : store.profile.projectTitle)", font: .systemFont(ofSize: 13))
                drawText("Generated: \(Date().formatted(date: .abbreviated, time: .shortened))", font: .systemFont(ofSize: 13), color: .darkGray, spacing: 16)

                for day in store.tripDays {
                    drawText(day.title, font: .boldSystemFont(ofSize: 18), spacing: 6)
                    drawText(day.summary, font: .systemFont(ofSize: 12), color: .darkGray, spacing: 10)

                    for stop in day.stops {
                        drawText(stop.name, font: .boldSystemFont(ofSize: 14), spacing: 4)
                        drawText(stop.details, font: .systemFont(ofSize: 11), color: .darkGray, spacing: 6)

                        let stopNotes = store.notesForStop(stop.id)
                        if !stopNotes.isEmpty {
                            drawText("Notes", font: .boldSystemFont(ofSize: 12), spacing: 4)
                            for note in stopNotes {
                                drawText("• \(note.text)", font: .systemFont(ofSize: 11), spacing: 4)

                                if let coord = store.coordinateText(latitude: note.latitude, longitude: note.longitude) {
                                    drawText("Location: \(coord)", font: .systemFont(ofSize: 10), color: .gray, spacing: 6)
                                }
                            }
                        }

                        let stopPhotos = store.photosForStop(stop.id)
                        if !stopPhotos.isEmpty {
                            drawText("Photos", font: .boldSystemFont(ofSize: 12), spacing: 6)

                            for photo in stopPhotos {
                                if let image = store.image(for: photo) {
                                    drawImage(image, caption: photo.caption)

                                    if let coord = store.coordinateText(latitude: photo.latitude, longitude: photo.longitude) {
                                        drawText("Location: \(coord)", font: .systemFont(ofSize: 10), color: .gray, spacing: 6)
                                    }
                                }
                            }
                        }

                        y += 8
                    }

                    y += 12
                }
            }

            exportedURL = url
            showShareSheet = true

        } catch {
            print("PDF export failed: \(error)")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
