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

public class FileSystemItem: Identifiable, ObservableObject { // Equatable?
    public let id = UUID()
    var filename: String

    @IsCheckEnum
    @AssociatedValueEnum
    public enum FileData {
        case directory, txtFile(String, Data), binFile(Data)
    }
    
    var content: FileData

    init(directory dirname: String) {
        self.content = .directory
        self.filename = dirname
    }

    init(filename: String, text: String) {
        self.filename = filename
        self.content = .txtFile(text, text.data(using: .utf8)!)
    }
    
    init(filename: String, data: Data) {
        self.filename = filename
        self.content = .binFile(data)
    }

    // init with file type detection
    convenience init?(filename: String, fileWrapper: FileWrapper, extraTextSuffixes: [String] = []) {
        guard let fileData = fileWrapper.regularFileContents else { return nil }
        if let subSuffix = filename.dotSuffix {
            let suffix = String(subSuffix)

            if let utType = UTType(filenameExtension: suffix),
               utType.conforms(to: .plainText),
               let text = String(data: fileData, encoding: .utf8) {
                self.init(filename: filename, text: text)
                return
            } else if extraTextSuffixes.contains(suffix),
                      let text = String(data: fileData, encoding: .utf8) {
                self.init(filename: filename, text: text)
                return
            }
        }

        // no way to detect file type without suffix
        self.init(filename: filename, data: fileData)
        return
    }
}

extension FileSystemItem {
    func setText(_ newText: String) {
        self.content = .txtFile(newText, newText.data(using: .utf8)!)
    }
}
