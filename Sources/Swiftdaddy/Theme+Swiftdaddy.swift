import Publish
import Plot


extension Theme {
    static func swiftdaddyTheme(using navigation: Navigation, with projects: Projects) -> Self {
        Theme(
            htmlFactory: SwiftdaddyHTMLFactory(navigation: navigation, projects: projects),
            resourcePaths: [
                "Theme/styles.css",
                "Theme/fonts/SourceSansPro-Bold.ttf",
                "Theme/fonts/SourceSansPro-Regular.ttf",
                "Theme/fonts/SourceCodePro-Regular.ttf",
            ]
        )
    }
}

private struct SwiftdaddyHTMLFactory<Site: Website>: HTMLFactory {
    let navigation: Navigation
    let projects: Projects
    
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                // Articles
                .div(
                    .class("wrapper content clearfix"),
                    .div(
                        .class("section-header float-container"),
                        .a(
                            .href("/articles"),
                            .h1("💾 Articles")
                        )
                    ),
                    .itemList(
                        for: Array(context.allItems(sortedBy: \.date, order: .descending).filter { $0.sectionID.rawValue == "articles" }.prefix(3)),
                        on: context.site
                    ),
                    .if(context.allItems(sortedBy: \.date, order: .descending).filter { $0.sectionID.rawValue == "articles" }.count > 1,
                        .a(
                            .class("browse-all"),
                            .href("/articles"),
                            .text("Browse all \(context.allItems(sortedBy: \.date, order: .descending).filter { $0.sectionID.rawValue == "articles" }.count) articles")
                        )
                    )
                ),
                
                // Notes
                .div(
                    .class("wrapper content clearfix"),
                    .div(
                        .class("section-header float-container"),
                        .a(
                            .href("/notes"),
                            .h1("📒 Latest notes")
                        )
                    ),
                    .itemList(
                        for: Array(context.allItems(sortedBy: \.date, order: .descending).filter { $0.sectionID.rawValue == "notes" }.prefix(3)),
                        on: context.site
                    ),
                    .a(
                        .class("browse-all"),
                        .href("/notes"),
                        .text("Browse all \(context.allItems(sortedBy: \.date, order: .descending).filter { $0.sectionID.rawValue == "notes" }.count) notes")
                    )
                ),
                
                .br(),
                .br(),
                .br(),
                
                // About section at the end
                .div(
                    .class("wrapper contentFooter clearfix"),
                    .id("aboutMeAnchor"),
                    .img(.class("avatar"), .src("/images/profile.jpg")),
                    .div(
                        .class("introduction"),
                        .contentBody(index.body)
                    ),
                    .navigationMenu(navigation)
                    
                ),
                .br(),
                .br(),
                .footer(for: context.site)
            )
        )
    }
    
    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .h1(.text(section.title)),
                    .if(section.id.rawValue == "articles",
                        .div(
                            .class("introduction"),
                            .text("iOS Development from UIKit to SwiftUI through Swift programming topics")
                        )
                    ),
                    .if(section.id.rawValue == "notes",
                        .div(
                            .class("introduction"),
                            .text("Snippets, tips and tricks, small pieces of code")
                        )
                    ),
                    .taggedIemList(for: section.items.filter { $0.sectionID == section.id }, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        ),
                        .br(),
                        .br(),
                        .p(.text("Published on \(Swiftdaddy.textualDateFormatter.string(from: item.date))")),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .if(page.path != "projects",
                .body(
                    .header(for: context, selectedSection: nil),
                    .wrapper(.contentBody(page.body)),
                    .footer(for: context.site)
                )
            )
        )
        
        
    }
    
    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
    
    private func notSupportedByThisTheme() -> HTML { HTML() }
    private func notSupportedByThisTheme() -> HTML? { nil }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
    
    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases
        
        return .header(
            .div(
                .class("wrapper"),
                //.a(.class("site-name"), .href("/"), .text(context.site.name)),
                .a(.class("site-name"), .href("/"), .img(.class("logo"), .class("logo"))),
                
                .h4(.text(context.site.description)),
                
                //.if(sectionIDs.count > 1,
                .nav(
                    .ul(
                        .forEach(sectionIDs) { section in
                            .li(
                                .class(section == selectedSection ? "selected" : ""),
                                .a(
                                    .href(context.sections[section].path),
                                    .text(context.sections[section].title)
                                ))
                        }
                        //                        .li(
                        //                            //.class(context.site.  page.path == "projects" ? "selected" : ""),
                        //                            .a(
                        //                            .href("/projects"),
                        //                            .text("Projects")
                        //                        )),
                        //                        .li(.a(
                        //                            .href("/#aboutMeAnchor"),
                        //                            .text("About")
                        //                            ))
                    )
                )
                //)
                
            )
        )
    }
    
    static func navigationMenu(_ navigation: Navigation) -> Node {
        return .ul(
            .class("navigation-items-container"),
            .forEach(navigation.items) { navigationItem in
                .li(
                    .class("navigation-item"),
                    .a(
                        .href(navigationItem.destinationURL),
                        .div(
                            .img(.src(navigationItem.iconPath)),
                            .text(navigationItem.caption)
                        )
                    )
                )
            }
        )
    }
    
    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items.sorted(by: {$0.date.compare($1.date) == .orderedDescending})) { item in
                .li(.article(
                    .a(.href(item.path),
                       .h1(.text(item.title)),
                       .p(.text(item.description)))
                    )
                )
            }
        )
    }
    
    static func taggedIemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items.sorted(by: {$0.date.compare($1.date) == .orderedDescending})) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                        )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description)),
                    .br(),
                    .text("Published on \(Swiftdaddy.textualDateFormatter.string(from: item.date))")
                    ))
            }
        )
    }
    
    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
                ))
            })
    }
    
    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("This website was made in Swift thanks to "),
                .a(
                    .text("Ink"),
                    .href("https://github.com/johnsundell/ink")
                ),
                .text(", "),
                .a(
                    .text("Plot"),
                    .href("https://github.com/johnsundell/plot")
                ),
                .text(", "),
                .a(
                    .text("Splash"),
                    .href("https://github.com/johnsundell/splash")
                ),
                .text(" & "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                ),
                .text(" by "),
                .a(
                    .class("rss"),
                    .text("John Sundell"),
                    .href("https://www.swiftbysundell.com")
                )
            ),
            .p(
                .text("©2020 Sebastian Vieira")
            ),
            .p(
                .text("Subscribe via "),
                .a(.class("rss"), .text("RSS"), .href("/feed.rss"))
            )
        )
    }
}
