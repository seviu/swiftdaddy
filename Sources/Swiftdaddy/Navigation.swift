import Foundation

struct NavigationItem {
    let iconPath: String
    let caption: String
    let destinationURL: URL
}

struct Navigation {
    let items: [NavigationItem]
}

let navigation = Navigation(
    items: [
        .init(
            iconPath: "/social/twitter.svg",
            caption: "Twitter",
            destinationURL: URL(string: "https://twitter.com/seviu")!
        ),
        .init(
            iconPath: "/social/linkedin.svg",
            caption: "Profile",
            destinationURL: URL(string: "https://www.linkedin.com/in/seviu/")!
        ),
        .init(
            iconPath: "/social/email.svg",
            caption: "Email",
            destinationURL: URL(string: "mailto:vieira+blog@gmail.com")!
        )
    ]
)
