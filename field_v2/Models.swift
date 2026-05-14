import Foundation

struct TripDay: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var date: String
    var theme: String
    var summary: String
    var logistics: String
    var stops: [TripStop]

    init(id: UUID = UUID(), title: String, date: String, theme: String, summary: String, logistics: String = "", stops: [TripStop]) {
        self.id = id
        self.title = title
        self.date = date
        self.theme = theme
        self.summary = summary
        self.logistics = logistics
        self.stops = stops
    }
}

struct TripStop: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var locationHint: String
    var details: String
    var activities: [String]
    var questions: [String]

    init(id: UUID = UUID(), name: String, locationHint: String = "", details: String, activities: [String] = [], questions: [String] = []) {
        self.id = id
        self.name = name
        self.locationHint = locationHint
        self.details = details
        self.activities = activities
        self.questions = questions
    }
}

struct StudentProfile: Codable {
    var studentName: String = ""
    var projectTitle: String = ""
}

struct StopNote: Identifiable, Codable, Hashable {
    let id: UUID
    var stopID: UUID
    var text: String
    var date: Date
    var latitude: Double?
    var longitude: Double?

    init(id: UUID = UUID(), stopID: UUID, text: String, date: Date = Date(), latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.stopID = stopID
        self.text = text
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct StopPhoto: Identifiable, Codable, Hashable {
    let id: UUID
    var stopID: UUID
    var imageFileName: String
    var caption: String
    var date: Date
    var latitude: Double?
    var longitude: Double?

    init(id: UUID = UUID(), stopID: UUID, imageFileName: String, caption: String, date: Date = Date(), latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.stopID = stopID
        self.imageFileName = imageFileName
        self.caption = caption
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}
