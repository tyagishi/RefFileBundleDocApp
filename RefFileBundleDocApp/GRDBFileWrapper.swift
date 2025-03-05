//
//  SqliteFileWrapper.swift
//  RefFileBundleDocApp
//
//  Created by Tomoaki Yagishita on 2025/03/05.
//

import Foundation
import GRDB
import SDSDataStructure

// based on https://stackoverflow.com/questions/66359387/swiftui-filedocument-using-sqlite-and-grdb
class GRDBFileWrapper: FileWrapper, URLFileWrapper {

    var databaseQueue: DatabaseQueue

    init (fromDatabaseQueue databaseQueue: DatabaseQueue) {
        self.databaseQueue = databaseQueue
        super.init(regularFileWithContents: Data())
    }

    required init?(coder inCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func readPathdirectFile(from path: URL) {
        readSQLite(path)
    }

    func readSQLite(_ url: URL) {
        // Copy the DB from disk to an in-memory database
        guard let onDiskDb = try? DatabaseQueue(path: url.path()) else { return }
        try? onDiskDb.backup(to: self.databaseQueue)
    }
    
    override func write(
        to url: URL,
        options: FileWrapper.WritingOptions = [],
        originalContentsURL: URL?
    ) throws {
        let destination = try DatabaseQueue(path: url.path)
        do {
            try databaseQueue.backup(to: destination)
        } catch {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
}
