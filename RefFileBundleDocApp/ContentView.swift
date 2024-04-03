//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI

struct ContentView: View {
    @Binding var document: RefFileBundleDocAppDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(RefFileBundleDocAppDocument()))
}
