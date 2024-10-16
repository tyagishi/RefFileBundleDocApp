//
//  RefFileBundleDocAppApp.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import OSLog

extension OSLog {
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.reffilebundoedocapp", category: "app")
    // public static var log = Logger(.disabled)
}
@main
struct RefFileBundleDocApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { RefFileBundleDocument.init() } , editor: { config in
            let _ = { OSLog.log.debug("DocumentGroup with \(config.fileURL?.absoluteString ?? "nil")") }()
            ContentView(document: config.document, path: config.fileURL)
        })
    }
}
