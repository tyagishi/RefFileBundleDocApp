//
//  FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSMacros
import SDSDataStructure
import SDSStringExtension
import UniformTypeIdentifiers
import Combine

public enum FileSystemItemChange {
    case filenameChanged(String)
    case contentChanged(Data)
    case textChagned(String)
}

@DidChangeObject<FileSystemItemChange>
public class FileSystemItem: Identifiable, ObservableObject { // Equatable?
    public let id = UUID()
    public var filename: String {
        didSet { self.objectDidChange.send(.filenameChanged(oldValue)) }
    }

    @IsCheckEnum
    @AssociatedValueEnum
    public enum FileContent {
        case directory, txtFile(String, Data), binFile(Data)
    }
    
    public private(set) var content: FileContent

    public init(directory dirname: String) {
        self.content = .directory
        self.filename = dirname
    }

    public init(filename: String, text: String) {
        self.filename = filename
        self.content = .txtFile(text, text.data(using: .utf8)!)
    }
    
    public init(filename: String, data: Data) {
        self.filename = filename
        self.content = .binFile(data)
    }

    // init with file type detection
    public convenience init?(filename: String, fileWrapper: FileWrapper, extraTextSuffixes: [String] = []) {
        guard let fileData = fileWrapper.regularFileContents else { return nil }
        if let subSuffix = filename.dotSuffix {
            let suffix = String(subSuffix)

            // try to check whether file can be handled as text file
            if extraTextSuffixes.contains(suffix),
                      let text = String(data: fileData, encoding: .utf8) {
                self.init(filename: filename, text: text)
                return
            } else if let utType = UTType(filenameExtension: suffix) {
                if utType.conforms(to: .plainText),
                   let text = String(data: fileData, encoding: .utf8) {
                    self.init(filename: filename, text: text)
                    return
                }
            }

            // not text file, so handle it as binday file
        }

        // no way to detect file type without suffix
        self.init(filename: filename, data: fileData)
        return
    }
}

extension FileSystemItem {
    public func setText(_ newText: String) {
        self.content = .txtFile(newText, newText.data(using: .utf8)!)
        self.objectDidChange.send(.textChagned(newText))
    }
    public func setData(_ newData: Data) {
        self.content = .binFile(newData)
        self.objectDidChange.send(.contentChanged(newData))
    }
}
