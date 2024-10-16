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
                .environmentObject(document)
        })
        .listStyle(.sidebar)
    }
}

struct TreeNodeView: View {
    @EnvironmentObject var document: RefFileBundleDocument
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
                    if let filePath = document.fileURL {
                        let nodePath = node.filePath(under: filePath)
                        if let values = try? nodePath.resourceValues(forKeys: [.tagNamesKey]) {
                            print("\(values.tagNames?.description ?? "notag")")
                        }
                    }
                }, label: { Text("Check Tags") })
            })
        }
    }
}

extension TreeNode where T == FileSystemItem {
    func filePath(under: URL) -> URL {
        var filePath = under
        for node in nodesFromRoot {
            guard !node.isRoot else { continue }
            filePath.append(path: node.filename)
        }
        return filePath
    }
}

extension TreeNode {
    var nodesFromRoot: [TreeNode]{
        var result = [self]
        var current = self
        while let parent = current.parent {
            result.insert(parent, at: 0)
            current = parent
        }
        return result
    }
}
