//
//  DetailView.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/16
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSDataStructure

struct DetailView: View {
    @ObservedObject var node: TreeNode<FileSystemItem>

    var body: some View {
        if node.isDirectory {
            Text("Directory: \(node.filename)")
        } else if let binding = node.textBinding {
            TextEditor(text: binding).padding()
        }
    }
}

extension TreeNode where T == FileSystemItem {
    @MainActor
    var textBinding: Binding<String>? {
        guard let (text, _) = self.value.content.txtFileValues else { return nil }
        return Binding<String>(get: {
            return text
        }, set: { (newValue) in
            self.objectWillChange.send()
            self.value.setText(newValue)
        })
    }
}
