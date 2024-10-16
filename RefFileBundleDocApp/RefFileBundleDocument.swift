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
    
    init() {
        OSLog.log.debug(#function)
        
        rootNode = TreeNode(preferredFilename: "root", FileWrapper(directoryWithFileWrappers: [:]))
        // initial document content
        rootNode.addTextFile(fileName: "Text1Key.txt", text: "HelloText1")
        rootNode.addTextFile(fileName: "Text2Key.txt", text: "WorldText2")
    }

    required init(configuration: ReadConfiguration) throws {
        OSLog.log.debug(#function)
        
        // care root
        let rootFileWrapper = configuration.file
        guard rootFileWrapper.isDirectory else { fatalError("unknown document struct, root should be directory") }

        rootNode = TreeNode(preferredFilename: "root", rootFileWrapper)
    }

    func snapshot(contentType: UTType) throws -> TreeNode<FileSystemItem> {
        OSLog.log.debug(#function)
        return rootNode
    }
    
    func fileWrapper(snapshot: TreeNode<FileSystemItem>, configuration: WriteConfiguration) throws -> FileWrapper {
        OSLog.log.debug(#function)
        
        rootNode.updateFileWrapper()

        return rootNode.fileWrapper
    }
}
