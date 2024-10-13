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
        
        rootNode = TreeNode(value: .init(directory: "root", nil))
        rootNode.addChildwithFileWrapper(TreeNode(value: .init(filename: Self.text1Key, text: "HelloText1", nil)))
        rootNode.addChildwithFileWrapper(TreeNode(value: .init(filename: Self.text2Key, text: "WorldText2", nil)))
    }

    required init(configuration: ReadConfiguration) throws {
        OSLog.log.debug(#function)
        
        // care root
        let rootFileWrapper = configuration.file
        guard rootFileWrapper.isDirectory else { fatalError("unknown document struct, root should be directory") }

        rootNode = TreeNode(value: .init(directory: "root", rootFileWrapper))
        
        guard let childFileWrappers = rootFileWrapper.fileWrappers else { return } // only top directory
        
        for key in childFileWrappers.keys {
            guard let childFileWrapper = childFileWrappers[key] else { continue }
            guard let textData = childFileWrapper.regularFileContents,
                  let text = String(data: textData, encoding: .utf8) else { continue }
            rootNode.addChild(TreeNode(value: .init(filename: key, text: text, childFileWrapper)))
        }
    }

    func snapshot(contentType: UTType) throws -> TreeNode<FileSystemItem> {
        OSLog.log.debug(#function)
        return rootNode
    }
    
    func fileWrapper(snapshot: TreeNode<FileSystemItem>, configuration: WriteConfiguration) throws -> FileWrapper {
        OSLog.log.debug(#function)
        let rootFileWrapper = rootNode.value.fileWrapper

        for child in rootNode.children {
            let fileItem = child.value
            
            if case .txtFile(_, let data) = fileItem.content,
               let fwData = fileItem.fileWrapper.regularFileContents,
                   fwData != data {
                let newFileWrapper = FileWrapper(regularFileWithContents: data)
                newFileWrapper.preferredFilename = fileItem.filename
                rootNode.replaceChildFileWrapper(child, newFileWrapper: newFileWrapper)
            }
        }
        return rootFileWrapper
    }
}
