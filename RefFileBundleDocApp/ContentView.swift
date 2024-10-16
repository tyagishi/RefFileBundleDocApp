//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSDataStructure

struct ContentView: View {
    @ObservedObject var document: RefFileBundleDocument
    let path: URL?
    @State private var selectedNodeID: TreeNode<FileSystemItem>.ID?

    init(document: RefFileBundleDocument, path: URL?) {
        self.document = document
        self.path = path
        self.document.fileURL = path
    }
    
    var body: some View {
        NavigationSplitView(sidebar: {
            SidebarView(document: document, selectedNodeID: $selectedNodeID)
        }, detail: {
            if let selectedNodeID = selectedNodeID,
               let node = document.rootNode.search(match: { $0.id == selectedNodeID }) {
                DetailView(node: node)
            } else {
                Text("No selection")
            }
        })
    }
}

#Preview {
    ContentView(document: RefFileBundleDocument(), path: nil)
}
