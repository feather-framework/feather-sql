// Scenarios adapted from Vapor SQLKit's SQLQueryEncoderTests.swift.
@_spi(CodableUtilities) import FeatherSQL
import Testing

@Suite("SQLKit-derived model encoding")
struct SQLQueryEncodingTests {

    private struct Item: Encodable, Sendable {
        let displayName: String
        let notes: String?
    }

    @Test("encodes model keys as SQL column expressions")
    func encodesModelColumns() throws {
        let encoded = try SQLQueryEncoder(
            keyEncodingStrategy: .convertToSnakeCase
        )
        .encode(Item(displayName: "Feather", notes: "CMS"))

        #expect(encoded.map(\.0) == ["display_name", "notes"])
        #expect(encoded.count == 2)
    }

    @Test("omits nil columns by default and encodes SQL NULL when requested")
    func nilEncodingStrategies() throws {
        let item = Item(displayName: "Feather", notes: nil)

        let omitted = try SQLQueryEncoder().encode(item)
        let explicitNull = try SQLQueryEncoder(
            nilEncodingStrategy: .asNil
        )
        .encode(item)

        #expect(omitted.map(\.0) == ["displayName"])
        #expect(explicitNull.map(\.0) == ["displayName", "notes"])
        #expect(explicitNull.last?.1 is SQLLiteral)
    }

    @Test("rejects top-level scalar and unkeyed values")
    func rejectsUnsupportedTopLevelValues() {
        #expect(throws: SQLCodingError.self) {
            try SQLQueryEncoder().encode("scalar")
        }
        #expect(throws: SQLCodingError.self) {
            try SQLQueryEncoder().encode(["unkeyed"])
        }
    }
}
