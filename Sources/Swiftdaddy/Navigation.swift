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
//        .init(
//            iconPath: "/social/github.svg",
//            caption: "See my projects",
//            destinationURL: URL(string: "https://github.com/seviu")!
//        ),
        .init(
            iconPath: "/social/linkedin.svg",
            caption: "Profile",
            destinationURL: URL(string: "https://www.linkedin.com/in/seviu/")!
        )
//		,
//        .init(
//            iconPath: "/social/CV.svg",
//            caption: "Read my CV",
//            destinationURL: URL(string: "/cv_sebastian_vieira.pdf")!
//        ),
    ]
)
