//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var document: RefFileBundleDocument

    var body: some View {
        VStack {
            TextField(text: $document.text1, label: {
                Text("Text1: ")
            })
            TextField(text: $document.text2, label: {
                Text("Text2: ")
            })
        }
    }
}

#Preview {
    ContentView(document: RefFileBundleDocument())
}
