//
//  BaseBlockTest.swift
//  edid-read-swiftTests
//
//  Created by Jackie Wu on 2/11/23.
//

@testable import edid_read_swift
import XCTest
import Foundation

final class BaseBlockTest: XCTestCase {
    var baseblock: BaseBlock!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_empty_block() throws {
        let expectedError = InitializationError.invalidSize
        var error: InitializationError?
        
        XCTAssertThrowsError(try baseblock = BaseBlock(block: [])) {
            thrownError in error = thrownError as? InitializationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_wrong_header() throws {
        let expectedError = InitializationError.invalidHeader
        var error: InitializationError?
        
        let edid: [uint8] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x34, 0x38, 0xc2, 0x0b, 0xf1, 0x01, 0x00, 0x00,
                             0x0f, 0x0a, 0x01, 0x00, 0x28, 0x20, 0x18, 0x32, 0xe8, 0x7e, 0x4e, 0x9e, 0x57, 0x45, 0x98, 0x24,
                             0x10, 0x47, 0x4f, 0xa4, 0x42, 0x01, 0x31, 0x59, 0x45, 0x59, 0x61, 0x59, 0x71, 0x4f, 0x81, 0x80,
                             0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0xf9, 0x15, 0x20, 0xf8, 0x30, 0x58, 0x1f, 0x20, 0x20, 0x40,
                             0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0xa4, 0x1a, 0x20, 0x10, 0x31, 0x58, 0x24, 0x20,
                             0x2f, 0x55, 0x33, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0x30, 0x2a, 0x00, 0x98, 0x51, 0x00,
                             0x2a, 0x40, 0x30, 0x70, 0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0xea, 0x24, 0x00, 0x60,
                             0x41, 0x00, 0x28, 0x30, 0x30, 0x60, 0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0x00, 0xfb]
        XCTAssertThrowsError(try baseblock = BaseBlock(block: edid)) {
            thrownError in error = thrownError as? InitializationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_edid_1_0() {
        let edid: [uint8] = [0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x34, 0x38, 0xc2, 0x0b, 0xf1, 0x01, 0x00, 0x00,
                    0x0f, 0x0a, 0x01, 0x00, 0x28, 0x20, 0x18, 0x32, 0xe8, 0x7e, 0x4e, 0x9e, 0x57, 0x45, 0x98, 0x24,
                    0x10, 0x47, 0x4f, 0xa4, 0x42, 0x01, 0x31, 0x59, 0x45, 0x59, 0x61, 0x59, 0x71, 0x4f, 0x81, 0x80,
                    0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0xf9, 0x15, 0x20, 0xf8, 0x30, 0x58, 0x1f, 0x20, 0x20, 0x40,
                    0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0xa4, 0x1a, 0x20, 0x10, 0x31, 0x58, 0x24, 0x20,
                    0x2f, 0x55, 0x33, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0x30, 0x2a, 0x00, 0x98, 0x51, 0x00,
                    0x2a, 0x40, 0x30, 0x70, 0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0xea, 0x24, 0x00, 0x60,
                    0x41, 0x00, 0x28, 0x30, 0x30, 0x60, 0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0x00, 0xfb]
        XCTAssertNoThrow(try baseblock = BaseBlock(block: edid))
        let id_manufacturer_name = "MAX"
        XCTAssertEqual(baseblock.id_manufacturer_name, id_manufacturer_name)
    }
    
    func test_reserve_id_manufacturer() throws {
        let expectedError = InitializationError.reservedField("ID Manufacturer Name Byte 1 bit 7 reserved!")
        var error: InitializationError?
        let edid: [uint8] = [0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0xB4, 0x38, 0xc2, 0x0b, 0xf1, 0x01, 0x00, 0x00,
                    0x0f, 0x0a, 0x01, 0x00, 0x28, 0x20, 0x18, 0x32, 0xe8, 0x7e, 0x4e, 0x9e, 0x57, 0x45, 0x98, 0x24,
                    0x10, 0x47, 0x4f, 0xa4, 0x42, 0x01, 0x31, 0x59, 0x45, 0x59, 0x61, 0x59, 0x71, 0x4f, 0x81, 0x80,
                    0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0xf9, 0x15, 0x20, 0xf8, 0x30, 0x58, 0x1f, 0x20, 0x20, 0x40,
                    0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0xa4, 0x1a, 0x20, 0x10, 0x31, 0x58, 0x24, 0x20,
                    0x2f, 0x55, 0x33, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0x30, 0x2a, 0x00, 0x98, 0x51, 0x00,
                    0x2a, 0x40, 0x30, 0x70, 0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0xea, 0x24, 0x00, 0x60,
                    0x41, 0x00, 0x28, 0x30, 0x30, 0x60, 0x13, 0x00, 0x40, 0xf0, 0x10, 0x00, 0x00, 0x1e, 0x00, 0xfb]
        XCTAssertThrowsError(try baseblock = BaseBlock(block: edid)) {
            thrownError in error = thrownError as? InitializationError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    func testCompressedASCII() {
        let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        for index in 1...26 {
            XCTAssertEqual(compressedASCII(number: UInt8(index)), alphabet[index - 1])
        }
    }
}
