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
    static let text1Key = "Text1Key.txt"
    static let text2Key = "Text2Key.txt"

    var rootNode: TreeNode<FileSystemItem>
    
    init() {
        OSLog.log.debug(#function)
        
        rootNode = TreeNode(value: .init(directory: "root"))
        rootNode.initRootDirAsFileSystemItem("root")
        rootNode.addTextFile(fileName: Self.text1Key, text: "HelloText1")
        rootNode.addTextFile(fileName: Self.text2Key, text: "WorldText2")
    }

    required init(configuration: ReadConfiguration) throws {
        OSLog.log.debug(#function)
        
        // care root
        let rootFileWrapper = configuration.file
        guard rootFileWrapper.isDirectory else { fatalError("unknown document struct, root should be directory") }

        rootNode = TreeNode(value: .init(directory: "root"))
        rootNode.initRootDirAsFileSystemItem("root")
        
        guard let childFileWrappers = rootFileWrapper.fileWrappers else { return } // only top directory
        
        for key in childFileWrappers.keys {
            guard let childFileWrapper = childFileWrappers[key] else { continue }
            if key.hasSuffix(".txt"),
               let textData = childFileWrapper.regularFileContents,
               let text = String(data: textData, encoding: .utf8) {
                rootNode.addTextFile(fileName: key, text: text)
            }
        }
    }

    func snapshot(contentType: UTType) throws -> TreeNode<FileSystemItem> {
        OSLog.log.debug(#function)
        return rootNode
    }
    
    func fileWrapper(snapshot: TreeNode<FileSystemItem>, configuration: WriteConfiguration) throws -> FileWrapper {
        OSLog.log.debug(#function)
        
        rootNode.updateFileWrapper()
        
        let rootFileWrapper = rootNode.fileWrapper

        return rootFileWrapper
    }
}
