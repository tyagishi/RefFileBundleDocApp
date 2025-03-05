//
//  DetailView.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/16
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSDataStructure
import GRDB

struct DetailView: View {
    @ObservedObject var node: TreeNode<FileSystemItem>
    @State private var message = "Hello"
    
    var body: some View {
        if node.isDirectory {
            Text("Directory: \(node.filename)")
        } else if let binding = node.textBinding {
            TextEditor(text: binding).padding()
        } else if node.value.content.isPathDirectFile,
                  let fileWrapper = node.fileWrapper as? GRDBFileWrapper {
            VStack {
                HStack {
                    TextField(text: $message, label: { Text("Message" )})
                    Button(action: {
                        node.objectWillChange.send()
                        let saveMessage = message == "" ? "NoMessage" : message
                        fileWrapper.addLog(id: UUID().uuidString, date: Date(), log: saveMessage)
                    }, label: { Text("Add") })
                }
                ForEach(fileWrapper.logs, id: \.self) { log in
                    Text("\(log.log) at \(log.date.formatted(date: .abbreviated, time: .complete))")
                }
                Spacer()
            }
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

extension GRDBFileWrapper {
    var logs: [GRDBLog] {
        try! databaseQueue.read { db in
            try! GRDBLog.fetchAll(db).sorted(by: { $0.date > $1.date})
        }
    }
    
    func addLog(id: String, date: Date, log: String) {
        try! databaseQueue.write { db in
            try! GRDBLog(id: id, date: date, log: log).insert(db)
        }
    }
}
