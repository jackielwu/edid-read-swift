//
//  BaseBlock.swift
//  edid-read-swift
//
//  Created by Jackie Wu on 2/11/23.
//

import Foundation

enum InitializationError: Error, Equatable {
    case invalidSize
    case invalidHeader
    case reservedField(String)
}

func compressedASCII(number: UInt8) -> Character {
    return Character(UnicodeScalar(UInt8(("A" as UnicodeScalar).value) + number - 1))
}

func convertUInt32(nums: [UInt8]) -> UInt32 {
    var ans: UInt32 = 0
    for index in stride(from: nums.count-1, through: 0, by: -1) {
        ans = (ans << 8) + UInt32(nums[index])
    }
    return ans
}

class BaseBlock {
    // Header
    var header: [UInt8]
    // Vendor & Product Identification
    var id_manufacturer_name: String
    var id_product_code: UInt16
    var id_serial_number: UInt32
    var week_of_manufacture: UInt8
    var year_of_manufacture: UInt8
    // EDID Structure Version & Revision
    var version_number: UInt8
    var revision_number: UInt8
    // Basic Display Parameters & Features
    var video_input_definition: UInt8
    var horizontal_screen_size: UInt8
    var vertical_screen_size: UInt8
    var display_transfer_characteristic: UInt8
    var feature_support: UInt8
    // Color Characteristics
    var red_x: UInt16
    var red_y: UInt16
    var green_x: UInt16
    var green_y: UInt16
    var blue_x: UInt16
    var blue_y: UInt16
    var white_x: UInt16
    var white_y: UInt16
    // Established Timings
    
    
    // Initializer
    init(block: [UInt8]) throws {
        // Check header
        if block.count < 128 {
            throw InitializationError.invalidSize
        }
        if block[...7] == [0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00] {
            self.header = Array(block[...7])
        }
        else {
            throw InitializationError.invalidHeader
        }
        // Check bit 7 reserved
        if block[8] & 0x80 != 0 {
            throw InitializationError.reservedField("ID Manufacturer Name Byte 1 bit 7 reserved!")
        }
        self.id_manufacturer_name = "\(compressedASCII(number: (block[8] & 0x7C) >> 2))\(compressedASCII(number: (block[8] & 0x03) << 3 + (block[9] & 0xE0) >> 5))\(compressedASCII(number: block[9] & 0x1F))"
        self.id_product_code = UInt16(block[11]) << 8 + UInt16(block[10])
        self.id_serial_number = convertUInt32(nums: Array(block[12...15]))
        self.week_of_manufacture = block[16]
        self.year_of_manufacture = block[17]
        
        self.version_number = block[18]
        self.revision_number = block[19]
        
        self.video_input_definition = block[20]
        self.horizontal_screen_size = block[21]
        self.vertical_screen_size = block[22]
        self.display_transfer_characteristic = block[23]
        self.feature_support = block[24]
        
        self.red_x = (UInt16(block[25] & 0xC0) >> 6) + (UInt16(block[27]) << 2)
        self.red_y = (UInt16(block[25] & 0x30) >> 6) + (UInt16(block[28]) << 2)
        self.green_x = (UInt16(block[25] & 0x0C) >> 6) + (UInt16(block[29]) << 2)
        self.green_y = (UInt16(block[25] & 0x03) >> 6) + (UInt16(block[30]) << 2)
        self.blue_x = (UInt16(block[26] & 0xC0) >> 6) + (UInt16(block[31]) << 2)
        self.blue_y = (UInt16(block[26] & 0x30) >> 6) + (UInt16(block[32]) << 2)
        self.white_x = (UInt16(block[26] & 0x0C) >> 6) + (UInt16(block[33]) << 2)
        self.white_y = (UInt16(block[26] & 0x03) >> 6) + (UInt16(block[34]) << 2)
    }
}
