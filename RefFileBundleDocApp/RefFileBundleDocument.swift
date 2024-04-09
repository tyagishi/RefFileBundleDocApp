//
//  RefFileBundleDocAppDocument.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/03
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog

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
    var text1: String = "Text1"
    var text2: String = "Text2"

    init() {
        OSLog.log.debug(#function)
    }

    static var readableContentTypes: [UTType] { [.refFileBundle] }
    typealias Snapshot = [String]
    static let text1Key = "Text1Key.txt"
    static let text2Key = "Text2Key.txt"

    required init(configuration: ReadConfiguration) throws {
        OSLog.log.debug(#function)
        let rootFileWrapper = configuration.file
        
        // check structure
        guard rootFileWrapper.isDirectory,
              let text1FileWrapper = rootFileWrapper.fileWrappers?[Self.text1Key],
              let text2FileWrapper = rootFileWrapper.fileWrappers?[Self.text2Key] else { fatalError("unknown document") }

        // extract
        guard let text1Data = text1FileWrapper.regularFileContents,
              let text1 = String(data: text1Data, encoding: .utf8),
              let text2Data = text2FileWrapper.regularFileContents,
              let text2 = String(data: text2Data, encoding: .utf8) else { fatalError("strange document content") }
        
        self.text1 = text1
        self.text2 = text2
    }

    func snapshot(contentType: UTType) throws -> [String] {
        OSLog.log.debug(#function)
        return [text1, text2]
    }
    
    func fileWrapper(snapshot: [String], configuration: WriteConfiguration) throws -> FileWrapper {
        OSLog.log.debug(#function)
        guard snapshot.count == 2 else { fatalError("strange snapshot") }

        // prep data
        guard let text1Data = snapshot[0].data(using: .utf8),
              let text2Data = snapshot[1].data(using: .utf8) else { fatalError("failed to generate utf8") }
        
        // prep FileWrapper
        let text1FileWrapper = FileWrapper(regularFileWithContents: text1Data)
        let text2FileWrapper = FileWrapper(regularFileWithContents: text2Data)
        
        // return folder FileWrapper
        return FileWrapper(directoryWithFileWrappers: [Self.text1Key: text1FileWrapper,
                                                       Self.text2Key: text2FileWrapper] )
    }
}
