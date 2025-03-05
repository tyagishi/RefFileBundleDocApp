//
//  RefFileBundleDocAppDocument.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog
import SDSDataStructure
import GRDB

extension OSLog {
    fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.reffilebundoedocapp", category: "refdoc")
    // fileprivate static var log = Logger(.disabled)
}

extension UTType {
    static var refFileBundle: UTType {
        UTType(exportedAs: "com.smalldesksoftware.ref-file-bundle", conformingTo: .package)
    }
}

class RefFileBundleDocument: ReferenceFileDocument {
    static var readableContentTypes: [UTType] { [.refFileBundle] }
    typealias Snapshot = TreeNode<FileSystemItem>

    var fileURL: URL? = nil
    var rootNode: TreeNode<FileSystemItem>
    let databaseQueue: DatabaseQueue = try! DatabaseQueue(named: "onMemoryDatabase")
    
    init() {
        OSLog.log.debug(#function)
        
        rootNode = TreeNode(preferredFilename: "root", FileWrapper(directoryWithFileWrappers: [:]))
        // initial document content
        rootNode.addTextFile(fileName: "Text1Key.txt", text: "HelloText1")
        rootNode.addTextFile(fileName: "Text2Key.txt", text: "WorldText2")
        
        let sqliteFW = GRDBFileWrapper(fromDatabaseQueue: self.databaseQueue)
        rootNode.addPathDirectFile(fileName: "grdb.sqlite", path: nil, fileWrapper: sqliteFW)
        initDatabase()
    }

    required init(configuration: ReadConfiguration) throws {
        OSLog.log.debug(#function)
        
        // care root
        let rootFileWrapper = configuration.file
        guard rootFileWrapper.isDirectory else { fatalError("unknown document struct, root should be directory") }

        rootNode = TreeNode(preferredFilename: "root", rootFileWrapper)

        rootNode.setupTreeAlongFileWrappers(itemContentProvider: { (name, fw) in
            // "grdb.sqlite" file is the file for GRDB
            guard name == "grdb.sqlite" else { return nil }
            let sqliteFW = GRDBFileWrapper(fromDatabaseQueue: self.databaseQueue)
            sqliteFW.preferredFilename = name
            sqliteFW.filename = name
            return (FileSystemItem(pathFilename: name), sqliteFW)
        })
    }

    func snapshot(contentType: UTType) throws -> TreeNode<FileSystemItem> {
        OSLog.log.debug(#function)
        self.rootNode.updateFileWrapper()
        return try rootNode.snapshot(contentType: contentType)
    }
    
    func fileWrapper(snapshot: TreeNode<FileSystemItem>, configuration: WriteConfiguration) throws -> FileWrapper {
        OSLog.log.debug(#function)
        return snapshot.fileWrapper
    }
    
    func initDatabase() {
        try? databaseQueue.write { db in
            try? db.create(table: "grdbLog", body: { table in
                table.primaryKey("id", .text)
                table.column("date", .date).notNull()
                table.column("log", .text).notNull()
            })
        }
    }
    
    func readSQLite(_ rootURL: URL) {
        guard let sqliteNode = rootNode.search(match: { $0.value.content.isPathDirectFile }) else { print("no sqlite node"); return }
        let sqlitePath = rootURL.appending(path: "grdb.sqlite")
        guard let sqliteFW = sqliteNode.fileWrapper as? GRDBFileWrapper else { return }
        sqliteFW.readSQLite(sqlitePath)
    }

    public func updateFileWrapper(with fileURL: URL) {
        rootNode.updatePathDirectFile(with: fileURL)
    }
}

