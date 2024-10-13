//
//  FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSMacros
import SDSDataStructure

public class FileSystemItem: Identifiable, ObservableObject { // Equatable?
    enum NodeType {
        case directory, txtFile, binFile
    }
    public let id = UUID()
    let type: NodeType
    var filename: String

    @IsCheckEnum
    @AssociatedValueEnum
    public enum FileData {
        case directory, txtFile(String, Data), binFile(Data)
    }
    
    var content: FileData
    var fileWrapper: FileWrapper

    init(directory dirname: String,_ fileWrapper: FileWrapper?) {
        self.type = .directory
        self.content = .directory
        self.filename = dirname
        if let fileWrapper = fileWrapper {
            self.fileWrapper =  fileWrapper
        } else {
            self.fileWrapper = FileWrapper(directoryWithFileWrappers: [:])
            self.fileWrapper.preferredFilename = dirname
        }
    }

    init(filename: String, text: String,_ fileWrapper: FileWrapper?) {
        self.type = .txtFile
        self.filename = filename
        self.content = .txtFile(text, text.data(using: .utf8)!)
        if let fileWrapper = fileWrapper {
            self.fileWrapper =  fileWrapper
        } else {
            self.fileWrapper = FileWrapper(regularFileWithContents: text.data(using: .utf8)!)
            self.fileWrapper.preferredFilename = filename
        }
    }
    
    init(filename: String, data: Data,_ fileWrapper: FileWrapper?) {
        self.type = .binFile
        self.filename = filename
        self.content = .binFile(data)
        if let fileWrapper = fileWrapper {
            self.fileWrapper =  fileWrapper
        } else {
            self.fileWrapper = FileWrapper(regularFileWithContents: data)
            self.fileWrapper.preferredFilename = filename
        }
    }
    
//    var newFileWrapper: FileWrapper {
//        switch self.content {
//        case .directory: return FileWrapper(directoryWithFileWrappers: [:])
//        case .txtFile(_, let data), .binFile(let data):
//            return FileWrapper(regularFileWithContents: data)
//        }
//    }
    
    func setText(_ newText: String) {
        self.content = .txtFile(newText, newText.data(using: .utf8)!)
    }
}

