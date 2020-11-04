import Foundation
import Publish
import Plot
import SplashPublishPlugin


struct Swiftdaddy: Website {
	enum SectionID: String, Publish.WebsiteSectionID {
		case articles
        case notes
	}
	
	struct ItemMetadata: WebsiteItemMetadata {
		// Add any site-specific metadata that you want to use here.
	}
	
	// Update these properties to configure your website:
	let url = URL(string: "https://seviu.github.io/")!
    let name = "Swiftdaddy"
    let description = "Blog about App development for iOS"
	var language: Language { .english }
	var imagePath: Path? { "images/swiftdaddy.png" }
    
	/// All dates use the same time zone and locale
	static func dateFormatter(with format: String) -> DateFormatter {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(identifier: "Europe/Madrid")
		formatter.locale = Locale(identifier: "en-US")
		formatter.dateFormat = format
		return formatter
	}
	
	static var textualDateFormatter = dateFormatter(with: "MMMM d, yyyy")
}

extension Theme where Site == Swiftdaddy {
	static var SwiftdaddyTheme: Self {
		.swiftdaddyTheme(using: navigation)
	}
}

try Swiftdaddy().publish(
	using: [
		.installPlugin(.splash(withClassPrefix: "")),
		.copyResources(),
		.addMarkdownFiles(),
		.generateHTML(withTheme: .SwiftdaddyTheme, indentation: .spaces(2)),
        .generateRSSFeed(including: [.articles, .notes]),
		.generateSiteMap(),
		.deploy(using: .gitHub("seviu/seviu.github.io", useSSH: true))
	]
)
