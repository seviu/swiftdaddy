import Foundation
import Publish
import Plot
import SplashPublishPlugin


struct Swiftdaddy: Website {
	enum SectionID: String, WebsiteSectionID {
		case articles
        case notes
	}
	
	struct ItemMetadata: WebsiteItemMetadata {
		// Add any site-specific metadata that you want to use here.
	}
	
	// Update these properties to configure your website:
	var url = URL(string: "https://seviu.github.io/")!
	var name = "Swiftdaddy"
	var description = "Blog about App development for iOS"
	var language: Language { .english }
	var imagePath: Path? { nil }
	/// All dates use the same time zone and locale
	static func dateFormatter(with format: String) -> DateFormatter {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(identifier: "Europe/Madrid")
		formatter.locale = Locale(identifier: "en-US")
		formatter.dateFormat = format
		return formatter
	}
	
	/// Formats dates like `2020-02-23`. For `<time>` elements.
	static var htmlDateFormatter = dateFormatter(with: "yyyy-dd-MM")
	
	/// Formats dates like `February 23, 2020`. For posts and post lists.
	static var textualDateFormatter = dateFormatter(with: "MMMM d, yyyy")
}

extension Theme where Site == Swiftdaddy {
	static var SwiftdaddyTheme: Self {
		.swiftdaddyTheme(using: navigation, with: projects)
	}
}

try Swiftdaddy().publish(
	using: [
		.installPlugin(.splash(withClassPrefix: "")),
		.copyResources(),
		.addMarkdownFiles(),
		.generateHTML(withTheme: .SwiftdaddyTheme, indentation: .tabs(1)),
        .generateRSSFeed(including: [.articles, .notes]),
		.generateSiteMap(),
		.deploy(using: .gitHub("seviu/seviu.github.io", useSSH: true))
	]
)
