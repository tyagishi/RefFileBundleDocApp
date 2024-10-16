//
//  SidebarView.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/15
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSDataStructure

struct SidebarView: View {
    @ObservedObject var document: RefFileBundleDocument
    @Binding var selectedNodeID: TreeNode<FileSystemItem>.ID?
    var body: some View {
        List(selection: $selectedNodeID, content: {
            TreeNodeView(node: document.rootNode)
        })
        .listStyle(.sidebar)
        .contextMenu(menuItems: {
            Button(action: {
                document.objectWillChange.send()
                document.rootNode.addDirectory(dirName: Date().description)
            }, label: { Text("Add Directory") })
        })
    }
}

struct TreeNodeView: View {
    @ObservedObject var node: TreeNode<FileSystemItem>
    
    var body: some View {
        if node.isDirectory {
            DisclosureGroup(content: {
                ForEach(node.children) { child in
                    TreeNodeView(node: child)
                }
            }, label: {
                HStack {
                    Image(systemName: "folder")
                    Text(node.filename)
                }
                .tag(node.id)
                .contextMenu(menuItems: {
                    Button(action: {
                        node.addDirectory(dirName: Date().description)
                    }, label: { Text("Add Directory") })
                    Button(action: {
                        node.addTextFile(fileName: "Hello"+Date().description, text: "Hello")
                    }, label: { Text("Add File") })
                })
            })
        } else {
            HStack {
                Image(systemName: "document")
                Text(node.filename)
            }.tag(node.id)
            .contextMenu(menuItems: {
                Button(action: {
                    let attrs = node.fileWrapper.fileAttributes
                    print(attrs)
                }, label: { Text("Add Gray") })
            })
        }
    }
}

