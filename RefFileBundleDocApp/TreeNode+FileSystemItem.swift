//
//  TreeNode+FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSDataStructure

extension TreeNode where T == FileSystemItem {
    var fileWrapper: FileWrapper {
        get {
            guard let fileWrapper = dic["FileWrapper"] as? FileWrapper else { fatalError("FileSystemItem without FileWrapper") }
            return fileWrapper
        }
        set {
            self.dic["FileWrapper"] = newValue
        }
    }
    
    func initRootDirAsFileSystemItem(_ dirName: String) {
        self.fileWrapper = FileWrapper(directoryWithFileWrappers: [:])
        self.fileWrapper.preferredFilename = dirName
    }
    
    @discardableResult
    func addDirectory(_ dirName: String, index: Int = -1) -> TreeNode<FileSystemItem> {
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
        case .txtFile(let string, let data):
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
    
//    func addChildwithFileWrapper(_ node: TreeNode<T>, index: Int = -1) {
//        addChild(node, index: index)
//        self.value.fileWrapper.addFileWrapper(node.value.fileWrapper)
//    }
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

    var filename: String {
        return self.value.filename
    }
    var text: String? {
        get {
            guard let (text, _) = self.value.content.txtFileValues else { return nil }
            return text
        }
        set {
            guard self.value.content.isTxtFile,
                  let newString = newValue else { return }
            self.value.setText(newString)
        }
    }
}
