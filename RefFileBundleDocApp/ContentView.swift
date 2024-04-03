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
            Text(document.text1)
            Text(document.text2)
        }
    }
}

#Preview {
    ContentView(document: RefFileBundleDocument())
}
