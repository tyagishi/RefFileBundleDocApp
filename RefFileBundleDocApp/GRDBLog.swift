//
//  GRDBLog.swift
//  RefFileBundleDocApp
//
//  Created by Tomoaki Yagishita on 2025/03/04.
//

import Foundation
import GRDB

struct GRDBLog: Codable, FetchableRecord, PersistableRecord, Hashable, Identifiable {
    var id: String
    var date: Date
    var log: String
}
