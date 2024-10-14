//
//  TreeNode+FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSDataStructure

extension TreeNode where T == FileSystemItem {
    var isDirectory: Bool { self.value.content.isDirectory }
    var isTextFile: Bool { self.value.content.isTxtFile }

    convenience init(preferredFilename: String,_ fileWrapper: FileWrapper, extraTextSuffixes: [String] = []) {
        if fileWrapper.isDirectory {
            self.init(value: .init(directory: preferredFilename))
            self.fileWrapper = fileWrapper
            
            guard let childFileWrappers = fileWrapper.fileWrappers else { return }
            for key in childFileWrappers.keys {
                guard let childFileWrapper = childFileWrappers[key] else { continue }
                let childNode = TreeNode.init(preferredFilename: key, childFileWrapper)
                addChildwithFileWrapper(childNode)
            }
            return
        } else if fileWrapper.isRegularFile {
            if let content = FileSystemItem(filename: preferredFilename, fileWrapper: fileWrapper, extraTextSuffixes: extraTextSuffixes) {
                self.init(value: content)
                self.fileWrapper = fileWrapper
                return
            }
        }
        fatalError("unsupported fileWrapper type")
    }
    
    var fileWrapper: FileWrapper {
        get {
            guard let fileWrapper = dic["FileWrapper"] as? FileWrapper else { fatalError("FileSystemItem without FileWrapper") }
            return fileWrapper
        }
        set { self.dic["FileWrapper"] = newValue }
    }
    
    @discardableResult
    func addDirectory(dirName: String, index: Int = -1) -> TreeNode<FileSystemItem> {
        let dirItem = FileSystemItem(directory: dirName)
        let dirNode = TreeNode(value: dirItem)
        dirNode.fileWrapper = FileWrapper(directoryWithFileWrappers: [:])
        dirNode.fileWrapper.preferredFilename = dirName
        addChild(dirNode, index: index)
        fileWrapper.addFileWrapper(dirNode.fileWrapper)
        return dirNode
    }
    
    @discardableResult
    func addTextFile(fileName: String, text: String, index: Int = -1) -> TreeNode<FileSystemItem> {
        let textItem = FileSystemItem(filename: fileName, text: text)
        let textNode = TreeNode(value: textItem)
        textNode.fileWrapper = FileWrapper(regularFileWithContents: text.data(using: .utf8)!)
        textNode.fileWrapper.preferredFilename = fileName
        addChild(textNode, index: index)
        fileWrapper.addFileWrapper(textNode.fileWrapper)
        return textNode
    }
    
    func updateFileWrapper() {
        switch self.value.content {
        case .directory:
            for child in children {
                child.updateFileWrapper()
            }
        case .txtFile(_, let data):
            if let fwData = self.fileWrapper.regularFileContents,
               data != fwData {
                let fileWrapper = FileWrapper(regularFileWithContents: data)
                fileWrapper.preferredFilename = filename
                replaceFileWrapper(fileWrapper)
            }
        case .binFile(let data):
            if let fwData = self.fileWrapper.regularFileContents,
               data != fwData {
                let fileWrapper = FileWrapper(regularFileWithContents: data)
                fileWrapper.preferredFilename = filename
                replaceFileWrapper(fileWrapper)
            }
        }
    }
    
    func addChildwithFileWrapper(_ node: TreeNode<T>, index: Int = -1) {
        addChild(node, index: index)
        self.fileWrapper.addFileWrapper(node.fileWrapper)
    }
//
//    func removeChildwithFileWrapper(_ node: TreeNode<T>) {
//        removeChild(node)
//        self.value.fileWrapper.removeFileWrapper(node.value.fileWrapper)
//    }
    
    func replaceFileWrapper(_ newFileWapper: FileWrapper) {
        if let parent = self.parent?.fileWrapper {
            parent.removeFileWrapper(self.fileWrapper)
            parent.addFileWrapper(newFileWapper)
        }
        self.fileWrapper = newFileWapper
    }
}
