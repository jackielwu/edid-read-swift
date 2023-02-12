import XCTest
import ArgumentParser
@testable import edid_read_swift

final class edid_read_swiftTests: XCTestCase {
    func parse<A>(_ type: A.Type, _ arguments: [String]) throws -> A where A: ParsableCommand {
        return try XCTUnwrap(EDIDRead.parseAsRoot(arguments) as? A)
    }
}

extension edid_read_swiftTests {
//    func testParsingDefaults() throws {
//        let edid = try parse(EDIDRead.self, [])
//        XCTAssertThrowsError(edid, "Error: Missing expected argument '<value>'") {error in XCTAssertEqual(error as? ExitCode, ExitCode.validationFailure)}
//    }
    // Should throw CommandError.parsingerror

    func testParsingPingVerbose() throws {
        let value = "Hello, World!"
        let edid = try parse(EDIDRead.self, [
            value
        ])
        XCTAssertEqual(edid.value, value)
    }
}
