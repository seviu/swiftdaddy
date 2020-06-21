import Foundation
import Publish
import Plot
import SplashPublishPlugin


struct Swiftdaddy: Website {
	enum SectionID: String, WebsiteSectionID {
		case articles
	}
	
	struct ItemMetadata: WebsiteItemMetadata {
		// Add any site-specific metadata that you want to use here.
	}
	
	// Update these properties to configure your website:
	var url = URL(string: "https://seviu.github.io/")!
	var name = "Swift Blog by Sebastian Vieira"
	var description = "Blog about the Swift programming language"
	var language: Language { .english }
	var imagePath: Path? { nil }
	/// All dates use the same time zone and locale
	static func dateFormatter(with format: String) -> DateFormatter {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(identifier: "Europe/Berlin")
		formatter.locale = Locale(identifier: "en-US")
		formatter.dateFormat = format
		return formatter
	}
	
	/// Formats dates like `2020-02-23`. For `<time>` elements.
	static var htmlDateFormatter = dateFormatter(with: "yyyy-dd-MM")
	
	/// Formats dates like `February 23, 2020`. For posts and post lists.
	static var textualDateFormatter = dateFormatter(with: "MMMM d, yyyy")
}


let colorsReplacement = StringReplace(
	replacements: [
		(source: "website-background-color",         target: "#ffffff"),
		(source: "website-content-background-color", target: "#ececeb"),
		(source: "website-text-color",               target: "#000000"),
		(source: "header-color",                     target: "#2193be"),
		(source: "navigation-items-color",           target: "#103140"),
		(source: "navigation-items-text-color",      target: "#ffffff"),
		(source: "hover-color",                      target: "#e4eaf5"),
		(source: "section-color",   				 target: "#efefef"),
		(source: "section-hover-color",				 target: "#ececeb"),
		(source: "video-color",                      target: "#ffffff"),
		
		// ++++++ DARK MODE
		
		(source: "website-background-color-dark",         target: "#222222"),
		(source: "website-content-background-color-dark", target: "#101010"),
		(source: "website-text-color-dark",               target: "#eeeeee"),
		(source: "header-color-dark",                     target: "#503c52"),
		(source: "navigation-items-color-dark",           target: "#008A90"),
		(source: "navigation-items-text-color-dark",      target: "#eeeeee"),
		(source: "hover-color-dark",                      target: "#6e5773"),
		(source: "section-color-dark",   				  target: "#101010"),
		(source: "section-hover-color-dark",			  target: "#010101"),
		(source: "video-color-dark",                      target: "#ffffff"),
	],
	filePaths: [
		"styles.css",
		"social/github.svg",
		"social/twitter.svg",
		"social/CV.svg",
		"social/linkedin.svg",
	]
)

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
		.stringReplace(colorsReplacement),
		.generateRSSFeed(including: [.articles]),
		.generateSiteMap(),
		.deploy(using: .gitHub("seviu/seviu.github.io", useSSH: true))
	]
)
