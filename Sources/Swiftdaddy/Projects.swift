import Foundation

struct Project {
    let name: String
    let code: String
    let subheader: String // The header under the app's name
    let status: String // In Progress or Published
    let status_css: String // Class name for the CSS style to be applied to the status
    let appIcon: String // Filename of the app's icon
    let videoFile: String
    let role: String // My Role
    let appStore_link: [String]
    let gitHub_link: String
    let technologies: [String]
    let paragraphs: [String] // Description
}

struct Projects {
    let items: [Project]
}

let projects = Projects(items: [
//        .init(name: "Departures - Switzerland",
//              code: "departures",
//              subheader: "Swiss transit departures",
//              status: "Published",
//              status_css: "published",
//              appIcon: "/images/projects/departures/departures_image.png",
//              videoFile: "departures.mp4",
//              role: "Developer in a team with Vikram Kriplaney at iPhonso GmbH",
//              appStore_link: ["https://apps.apple.com/ch/app/departures-switzerland/id976203194"],
//              gitHub_link: "",
//              technologies: ["WatchKit", "UIKit", "MapKit"],
//              paragraphs: ["Departures does one thing and it does it well: tells you about trains, trams and buses departing near where you are, right now. It shows delays and platform changes as they happen, keeping you up-to-date with all the information you need for your daily (or not-so-daily) commute."]),
])
