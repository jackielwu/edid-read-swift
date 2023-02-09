//
//  BaseBlock.swift
//  edid-read
//
//  Created by Jackie Wu on 2/8/23.
//

import Foundation

enum InitializationError: Error {
    case invalidSize
    case invalidHeader
}

class BaseBlock {
    // Header
    var header: [UInt8]
    // Vendor & Product Identification
    var id_manufacturer_name: [UInt8]
    var id_product_code: [UInt8]
    var id_serial_number: [UInt8]
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
        self.id_manufacturer_name = Array(block[8...9])
        self.id_product_code = Array(block[10...11])
        self.id_serial_number = Array(block[12...15])
        self.week_of_manufacture = block[16]
        self.year_of_manufacture = block[17]
        
        self.version_number = block[18]
        self.revision_number = block[19]
        
        self.video_input_definition = block[20]
        self.horizontal_screen_size = block[21]
        self.vertical_screen_size = block[22]
        self.display_transfer_characteristic = block[23]
        self.feature_support = block[24]
    }
}
