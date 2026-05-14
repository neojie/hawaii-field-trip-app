import SwiftUI
import UIKit
import Combine
import CoreLocation

final class FieldTripStore: ObservableObject {
    @Published var tripDays: [TripDay] = []
    @Published var notes: [StopNote] = []
    @Published var photos: [StopPhoto] = []
    @Published var profile: StudentProfile = StudentProfile()

    private let daysKey = "fieldtrip.days.v3"
    private let notesKey = "fieldtrip.notes.v3"
    private let photosKey = "fieldtrip.photos.v3"
    private let profileKey = "fieldtrip.profile.v3"

    init() {
        loadAll()
        if tripDays.isEmpty {
            tripDays = Self.defaultTripDays()
            saveDays()
        }
    }

    func resetAgendaToGuidebookVersion() {
        tripDays = Self.defaultTripDays()
        saveDays()
    }

    func coordinateText(latitude: Double?, longitude: Double?) -> String? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return String(format: "%.5f, %.5f", lat, lon)
    }

    static func defaultTripDays() -> [TripDay] {
        [
            TripDay(
                title: "Day 1: Arrival and Orientation",
                date: "Thu May 14, 2026",
                theme: "Travel, logistics, and overview",
                summary: "Depart Philadelphia through Seattle and arrive at Kona. Drive to Kīlauea Military Camp. Introduce the field trip goals, safety expectations, and Hawai‘i as a natural laboratory for volcanism, ocean chemistry, climate, and ecosystems.",
                logistics: "Lodging: Kīlauea Military Camp, 99-252 Crater Rim Drive, Hawai‘i Volcanoes National Park.",
                stops: [
                    TripStop(
                        name: "Kona Airport Arrival",
                        locationHint: "KOA",
                        details: "Arrival on the Big Island. Initial orientation to the island-scale transect from Kona toward Hawai‘i Volcanoes National Park.",
                        activities: ["Record first impressions of island topography and climate.", "Note changes in vegetation and elevation during the drive."],
                        questions: ["How does the island-scale topography reflect construction by shield volcanoes?", "What do you notice about climate gradients from the west side toward Volcano?"]
                    ),
                    TripStop(
                        name: "Kīlauea Military Camp",
                        locationHint: "Hawai‘i Volcanoes National Park",
                        details: "Base for the first part of the trip. Use this stop for safety briefing, project organization, and introduction to the field notebook workflow.",
                        activities: ["Enter student name and project title in the app.", "Review the week’s stops.", "Check that photo, note, and GPS tools work."],
                        questions: ["What kinds of field observations are most useful for connecting surface geology to mantle processes?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 2: Kīlauea Summit and Lower East Rift Zone",
                date: "Fri May 15, 2026",
                theme: "Active volcanism, hazards, monitoring, and rift-zone eruption",
                summary: "Kīlauea summit activity, Halemaʻumaʻu collapse and refilling after 2018, volcano monitoring, and the 2018 Lower East Rift Zone eruption. The guide emphasizes current summit activity, hazards, monitoring, and the LERZ eruption.",
                logistics: "Main region: Kīlauea summit, East Rift Zone, and Lower East Rift Zone where accessible.",
                stops: [
                    TripStop(
                        name: "Kīlauea Visitor Center / Summit Briefing",
                        locationHint: "Hawai‘i Volcanoes National Park",
                        details: "Overview of Kīlauea, current summit activity, hazards, and HVO monitoring. The guide notes recent lava-lake and lava-fountaining episodes after the 2018 collapse.",
                        activities: ["Check current HVO status before field work.", "Identify current closed/open areas.", "Discuss gas, tephra, ground cracking, and lava-flow hazards."],
                        questions: ["What monitoring signals would indicate magma recharge?", "How do hazard maps affect where field work can safely occur?"]
                    ),
                    TripStop(
                        name: "Halemaʻumaʻu / Kīlauea Caldera Viewpoint",
                        locationHint: "Crater Rim area",
                        details: "Observe the summit caldera and Halemaʻumaʻu. Discuss the 2018 collapse, post-2018 crater refilling, lava lake outlines, and the relationship between summit magma storage and rift-zone eruption.",
                        activities: ["Sketch caldera geometry.", "Record evidence for collapse and refilling.", "Compare visible morphology with the guidebook map of recent summit activity."],
                        questions: ["Why did the 2018 LERZ eruption cause summit collapse?", "How is magma storage expressed at the surface?"]
                    ),
                    TripStop(
                        name: "Keanakākoʻi / Crater Rim Area",
                        locationHint: "Near Kīlauea summit",
                        details: "Possible viewpoint for recent summit deposits and crater morphology, depending on access.",
                        activities: ["Observe tephra, lava surfaces, fractures, and viewing geometry.", "Use photos and notes to document summit volcanic landforms."],
                        questions: ["What evidence distinguishes explosive, effusive, and collapse-related processes?"]
                    ),
                    TripStop(
                        name: "Lower East Rift Zone Overview",
                        locationHint: "Pāhoa / Leilani / Pohoiki region if accessible",
                        details: "The 2018 LERZ eruption drained summit magma, produced fissure eruptions and lava flows, and strongly modified coastal landscapes.",
                        activities: ["Map alignment of rift-zone features.", "Look for evidence of fissures, lava channels, and new coastal deposits."],
                        questions: ["Why do eruptions occur along rift zones rather than only at the summit?", "What controls where dikes propagate?"]
                    ),
                    TripStop(
                        name: "Pohoiki / New Black Sand Beach",
                        locationHint: "Lower East Rift Zone coast",
                        details: "Pohoiki is highlighted in the guide as a site where 2018 lava-ocean interaction produced new black sand and cobble deposits.",
                        activities: ["Observe grain size and rounding.", "Discuss rapid coastal sediment generation after lava enters the ocean."],
                        questions: ["How quickly can new volcanic sediment be produced and modified?", "Who owns new land created by lava flows?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 3: South Point, Papakōlea, and Ocean Carbon",
                date: "Sat May 16, 2026",
                theme: "Green sand, olivine weathering, carbonate systems, and marine carbon dioxide removal",
                summary: "South Point and Papakōlea Green Sand Beach connect volcanic mineralogy to ocean alkalinity, natural weathering, and engineered carbon dioxide removal.",
                logistics: "Long field day. Bring water, sun protection, and sturdy shoes.",
                stops: [
                    TripStop(
                        name: "South Point / Ka Lae",
                        locationHint: "Southern tip of Hawai‘i Island",
                        details: "Island-scale viewpoint for winds, waves, coastal processes, young volcanic surfaces, and ocean chemistry sampling.",
                        activities: ["Record wind and wave conditions.", "Observe coastal erosion and sediment transport.", "Collect field notes on ocean-water context if measurements are made."],
                        questions: ["How do wind and wave energy influence sediment transport?", "Why is this region useful for discussing ocean carbon cycling?"]
                    ),
                    TripStop(
                        name: "Papakōlea Green Sand Beach",
                        locationHint: "Near South Point",
                        details: "Green sand derived from olivine-rich material. This stop links mantle-derived minerals, basaltic volcanism, weathering, alkalinity, and potential ocean alkalinity enhancement.",
                        activities: ["Observe grain color, size, and sorting.", "Compare olivine-rich sand with carbonate or basaltic sand.", "Photograph sediment textures."],
                        questions: ["Why does olivine survive here as sand?", "How could olivine weathering affect alkalinity and CO₂ uptake?"]
                    ),
                    TripStop(
                        name: "Coral / Carbonate Sand Stop",
                        locationHint: "South Point region",
                        details: "Contrast carbonate sediment with olivine-rich sand. Connect coral calcification, ocean acidification, and carbonate chemistry.",
                        activities: ["Compare sediment types.", "Record color, grain size, and biological fragments.", "Discuss carbonate saturation and coral growth."],
                        questions: ["How does carbonate sand form differently from olivine sand?", "How does ocean acidification affect carbonate-producing ecosystems?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 4: Kīlauea Iki, Mauna Ulu, and Fumaroles",
                date: "Sun May 17, 2026",
                theme: "Volcanic landforms, lava lake crystallization, magma differentiation, and hydrothermal activity",
                summary: "Kīlauea Iki provides a classic example of a 1959 lava lake, cooling, crystallization, and real-time magma differentiation. Mauna Ulu and fumaroles add lava morphology, degassing, and hydrothermal alteration.",
                logistics: "Main region: Hawai‘i Volcanoes National Park.",
                stops: [
                    TripStop(
                        name: "Kīlauea Iki Overlook",
                        locationHint: "Kīlauea Iki crater",
                        details: "View the 1959 lava lake from above. Discuss lava lake emplacement, cooling, crystallization, and drill-hole studies.",
                        activities: ["Sketch crater geometry.", "Identify lava lake surface features.", "Discuss vertical cooling and differentiation."],
                        questions: ["How does a lava lake crystallize from the margins inward?", "What would you expect in a vertical chemical profile through the lava lake?"]
                    ),
                    TripStop(
                        name: "Kīlauea Iki Crater Floor",
                        locationHint: "Kīlauea Iki trail",
                        details: "Walk across the lava lake surface if access allows. Observe cracks, surface textures, and cooling features.",
                        activities: ["Photograph cracks, inflation features, and surface textures.", "Record evidence for cooling and contraction.", "Relate surface features to thermal evolution."],
                        questions: ["What surface features record cooling and contraction?", "How does this natural lava lake compare with a magma chamber?"]
                    ),
                    TripStop(
                        name: "Mauna Ulu Lava Flows",
                        locationHint: "Chain of Craters Road area",
                        details: "1969–1974 Mauna Ulu eruption deposits provide examples of pāhoehoe, ʻaʻā, lava channels, tree molds, and rift-zone volcanism.",
                        activities: ["Identify pāhoehoe and ʻaʻā.", "Observe flow thickness, vesicles, channels, and surface textures.", "Connect lava morphology to viscosity and eruption conditions."],
                        questions: ["What controls whether lava forms pāhoehoe or ʻaʻā?", "How do rift zones organize magma transport?"]
                    ),
                    TripStop(
                        name: "Fumarole Field",
                        locationHint: "Kīlauea summit region",
                        details: "Fumaroles illustrate degassing, hydrothermal circulation, alteration, and the connection between heat, fluids, and volcanic systems.",
                        activities: ["Observe steam vents and alteration colors.", "Record smell, temperature impression, and mineral/alteration features without unsafe contact."],
                        questions: ["What does fumarolic activity reveal about subsurface heat and permeability?", "How can gases be used for volcano monitoring?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 5: Mauna Kea, Hualālai, Xenoliths, and Weathering",
                date: "Mon May 18, 2026",
                theme: "Glaciation, mantle xenoliths, basalt weathering, and older volcanic landscapes",
                summary: "This day connects volcanic construction to surface modification. The guide includes Mauna Kea glaciation, Hualālai xenoliths, and basalt weathering.",
                logistics: "Move from KMC side toward north/west side lodging at Paniolo Greens.",
                stops: [
                    TripStop(
                        name: "Mauna Kea Glaciation Stop",
                        locationHint: "Mauna Kea / Saddle Road region",
                        details: "Mauna Kea preserves evidence of high-elevation glaciation, showing how climate modifies volcanic landscapes.",
                        activities: ["Observe landforms and deposits that may indicate glacial modification.", "Compare Mauna Kea with younger active shield surfaces."],
                        questions: ["Why is glaciation possible on a tropical island?", "How does glaciation modify volcanic morphology?"]
                    ),
                    TripStop(
                        name: "Saddle Road Transect",
                        locationHint: "Between Mauna Loa and Mauna Kea",
                        details: "Excellent transect for comparing volcano shape, elevation, climate, and lithosphere response. Also useful for the hotspot/plume project.",
                        activities: ["Record elevation and landscape changes.", "Compare slopes and surfaces of Mauna Loa and Mauna Kea.", "Discuss loading and flexure."],
                        questions: ["Why do Hawaiian volcanoes rise and then subside over time?", "What is the balance between construction, erosion, and lithospheric flexure?"]
                    ),
                    TripStop(
                        name: "Hualālai Xenolith Locality",
                        locationHint: "Hualālai region",
                        details: "Xenoliths provide direct samples of deeper lithosphere or mantle carried upward by magma.",
                        activities: ["Observe xenolith textures and host basalt.", "Describe mineral assemblages and grain size.", "Discuss what depth information xenoliths provide."],
                        questions: ["What can xenoliths tell us that lava chemistry alone cannot?", "How do xenoliths connect field geology to mineral physics?"]
                    ),
                    TripStop(
                        name: "Basalt Weathering Stop",
                        locationHint: "North/west Hawai‘i Island",
                        details: "Basalt weathering links volcanic rock, soil formation, climate, and geochemical cycling.",
                        activities: ["Compare fresh and weathered basalt.", "Record color changes, soil development, and alteration features."],
                        questions: ["How does climate affect basalt weathering?", "How does basalt weathering influence ocean alkalinity and CO₂ cycling?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 6: Climate, Orography, and Ocean Productivity",
                date: "Tue May 19, 2026",
                theme: "Climate gradients, orographic precipitation, ecosystems, and phytoplankton carbon cycling",
                summary: "The guide emphasizes climate and orography, plus the role of phytoplankton in carbon dioxide cycling. This day links island topography to atmosphere, hydrology, and marine productivity.",
                logistics: "Likely north/west side base at Paniolo Greens.",
                stops: [
                    TripStop(
                        name: "Orographic Climate Transect",
                        locationHint: "Windward to leeward transition",
                        details: "Hawai‘i has steep rainfall gradients caused by trade winds and topography.",
                        activities: ["Record vegetation, cloud cover, and rainfall differences.", "Relate observations to elevation and prevailing winds."],
                        questions: ["How does volcanic topography control climate?", "How does rainfall affect erosion, soil development, and ecosystems?"]
                    ),
                    TripStop(
                        name: "Waimea / Kohala Landscape Stop",
                        locationHint: "Waimea or Kohala region",
                        details: "Older volcanic landscapes show stronger erosion and soil development than young Kīlauea surfaces.",
                        activities: ["Compare erosional maturity with younger lava fields.", "Observe stream incision, soil cover, and vegetation."],
                        questions: ["How does landscape age affect erosion and soil formation?", "How does island evolution change hydrology?"]
                    ),
                    TripStop(
                        name: "Marine Productivity Discussion Stop",
                        locationHint: "Coastal or classroom setting",
                        details: "Phytoplankton play an important role in carbon dioxide cycling through photosynthesis, export production, and food webs.",
                        activities: ["Discuss ocean color and productivity.", "Connect nutrients, light, circulation, and biological carbon uptake."],
                        questions: ["What limits phytoplankton growth near Hawai‘i?", "How is biological carbon cycling different from mineral weathering or ocean alkalinity enhancement?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 7: Kona Coast, Coral Reefs, and Captura",
                date: "Wed May 20, 2026",
                theme: "Marine ecosystems, coral reefs, carbon capture, and direct ocean capture",
                summary: "Kona coast stops focus on coral reefs, marine ecosystems, carbon capture, and the Captura facility. The guide links ocean chemistry, calcification, and carbon dioxide removal.",
                logistics: "Kona coast / Captura region. Snorkeling if conditions and logistics allow.",
                stops: [
                    TripStop(
                        name: "Kona Coast Reef / Snorkeling Stop",
                        locationHint: "Kona coast",
                        details: "Observe coral reef ecosystems and discuss calcification, ocean acidification, biodiversity, and reef carbon cycling.",
                        activities: ["Record reef observations if snorkeling.", "Identify corals, fish, carbonate sand, and ecosystem structure.", "Discuss safety and reef protection."],
                        questions: ["How do corals build carbonate skeletons?", "How does ocean acidification affect calcification?"]
                    ),
                    TripStop(
                        name: "Puʻuhonua o Hōnaunau / Coastal Cultural-Geology Stop",
                        locationHint: "South Kona coast",
                        details: "A coastal site useful for connecting geology, reef systems, and Hawaiian cultural history.",
                        activities: ["Observe coastal lava-rock setting.", "Connect landforms, ocean access, and human use."],
                        questions: ["How does geology shape coastal settlement and cultural landscapes?"]
                    ),
                    TripStop(
                        name: "Captura / Direct Ocean Capture Discussion",
                        locationHint: "Kona",
                        details: "The guide includes Captura as a direct ocean capture stop, connecting ocean chemistry to engineered carbon dioxide removal.",
                        activities: ["Summarize how direct ocean capture differs from alkalinity enhancement.", "Discuss energy, scale, monitoring, and environmental tradeoffs."],
                        questions: ["What does direct ocean capture remove from seawater?", "How does the ocean then re-equilibrate with atmospheric CO₂?"]
                    )
                ]
            ),

            TripDay(
                title: "Day 8: Departure",
                date: "Thu May 21 – Fri May 22, 2026",
                theme: "Synthesis, report export, and return travel",
                summary: "Depart Kona on May 21 and arrive in Newark on May 22. Students should export their field report before leaving or during travel.",
                logistics: "Flights: Kona to Seattle, then Seattle to Newark.",
                stops: [
                    TripStop(
                        name: "Final Report Export",
                        locationHint: "Before departure",
                        details: "Use the app to export notes, photos, captions, GPS coordinates, and project reflections into a PDF field report.",
                        activities: ["Review all stops.", "Add missing captions.", "Export PDF.", "Share or save the report."],
                        questions: ["What was your strongest field observation?", "How did your interpretation change during the trip?"]
                    )
                ]
            )
        ]
    }

    func addNote(stopID: UUID, text: String, location: CLLocation?) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        notes.append(StopNote(stopID: stopID, text: trimmed, latitude: location?.coordinate.latitude, longitude: location?.coordinate.longitude))
        saveNotes()
    }

    func notesForStop(_ stopID: UUID) -> [StopNote] {
        notes.filter { $0.stopID == stopID }.sorted { $0.date < $1.date }
    }

    func addPhoto(stopID: UUID, image: UIImage, caption: String, location: CLLocation?) {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return }
        let fileName = "\(UUID().uuidString).jpg"
        do {
            try data.write(to: imageURL(for: fileName), options: .atomic)
            photos.append(StopPhoto(stopID: stopID, imageFileName: fileName, caption: caption, latitude: location?.coordinate.latitude, longitude: location?.coordinate.longitude))
            savePhotos()
        } catch {
            print("Failed to save photo: \(error)")
        }
    }

    func photosForStop(_ stopID: UUID) -> [StopPhoto] {
        photos.filter { $0.stopID == stopID }.sorted { $0.date < $1.date }
    }

    func image(for photo: StopPhoto) -> UIImage? {
        guard let data = try? Data(contentsOf: imageURL(for: photo.imageFileName)) else { return nil }
        return UIImage(data: data)
    }

    func saveProfile() {
        save(profile, forKey: profileKey)
    }

    private func loadAll() {
        tripDays = load([TripDay].self, forKey: daysKey) ?? []
        notes = load([StopNote].self, forKey: notesKey) ?? []
        photos = load([StopPhoto].self, forKey: photosKey) ?? []
        profile = load(StudentProfile.self, forKey: profileKey) ?? StudentProfile()
    }

    func saveDays() { save(tripDays, forKey: daysKey) }
    func saveNotes() { save(notes, forKey: notesKey) }
    func savePhotos() { save(photos, forKey: photosKey) }

    private func save<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func imageURL(for fileName: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
}
