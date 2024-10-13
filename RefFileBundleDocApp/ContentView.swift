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
            TextField(text: Binding<String>(get: {
                document.text2
            }, set: {
                document.text2 = $0
            }), label: {
                Text("Text2: ")
            })
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
    var node2: TreeNode<FileSystemItem>? {
        rootNode.search(match: { $0.filename == Self.text2Key })
    }
    var text1: String {
        get {
            node1?.text ?? "No Node1"
        }
        set(newValue) {
            guard let node1 = node1 else { return }
            node1.text = newValue
        }
    }
    var text2: String {
        get {
            node2?.text ?? "No Node2"
        }
        set(newValue) {
            guard let node2 = node2 else { return }
            node2.text = newValue
        }
    }
}
