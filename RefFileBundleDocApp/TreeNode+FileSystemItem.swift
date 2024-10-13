//
//  TreeNode+FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSDataStructure

extension TreeNode where T == FileSystemItem {
    func addChildwithFileWrapper(_ node: TreeNode<T>, index: Int = -1) {
        addChild(node, index: index)
        self.value.fileWrapper.addFileWrapper(node.value.fileWrapper)
    }

    func removeChildwithFileWrapper(_ node: TreeNode<T>) {
        removeChild(node)
        self.value.fileWrapper.removeFileWrapper(node.value.fileWrapper)
    }
    
    func replaceChildFileWrapper(_ node: TreeNode<T>, newFileWrapper: FileWrapper) {
        self.value.fileWrapper.removeFileWrapper(node.value.fileWrapper)
        self.value.fileWrapper.addFileWrapper(newFileWrapper)
        node.value.fileWrapper = newFileWrapper
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
