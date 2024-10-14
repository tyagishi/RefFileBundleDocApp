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

    func setText(_ newText: String) {
        self.content = .txtFile(newText, newText.data(using: .utf8)!)
    }
}

