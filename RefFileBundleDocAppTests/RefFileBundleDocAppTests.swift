//
//  RefFileBundleDocAppTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/14
//  © 2024  SmallDeskSoftware
//

import XCTest
import UniformTypeIdentifiers

final class RefFileBundleDocAppTests: XCTestCase {


    func test_Suffix_md() async throws {
        let utType = try XCTUnwrap(UTType(filenameExtension: "md"))
        XCTAssertEqual(utType.conforms(to: .text), true)
        XCTAssertEqual(utType.isSubtype(of: .text), true)
    }
    func test_Suffix_txt() async throws {
        let utType = try XCTUnwrap(UTType(filenameExtension: "txt"))
        XCTAssertEqual(utType, .plainText)
        XCTAssertEqual(utType.conforms(to: .text), true)
    }

}
