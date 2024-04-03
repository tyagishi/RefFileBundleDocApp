//
//  RefFileBundleDocAppApp.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI

@main
struct RefFileBundleDocAppApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: RefFileBundleDocAppDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
