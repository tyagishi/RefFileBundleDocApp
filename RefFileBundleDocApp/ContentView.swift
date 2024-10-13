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

    var body: some View {
        VStack {
            TextField(text: Binding<String>(get: {
                document.text1
            }, set: {
                document.text1 = $0
            }), label: {
                Text("Text1: ")
            })
//            TextField(text: $document.text2, label: {
//                Text("Text2: ")
//            })
        }
    }
}

#Preview {
    ContentView(document: RefFileBundleDocument())
}

extension RefFileBundleDocument {
    var node1: TreeNode<FileSystemItem>? {
        rootNode.search(match: { $0.filename == Self.text1Key })
    }
    var text1: String {
        get {
            node1?.text ?? "No Node1"
        }
        set(newValue) {
            guard let node1 = node1 else { return }
            node1.value.setText(newValue)
        }
    }
}
