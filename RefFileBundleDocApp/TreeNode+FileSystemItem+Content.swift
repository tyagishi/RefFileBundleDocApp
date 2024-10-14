//
//  TreeNode+FileSystemItem+Content.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/14
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSDataStructure

extension TreeNode where T == FileSystemItem {
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
