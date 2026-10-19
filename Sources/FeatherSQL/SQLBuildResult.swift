/// The serialized SQL statement and its values, ready for a database adapter to execute.
public struct SQLBuildResult: Sendable {

    public let sql: String
    public let bindings: [any Encodable & Sendable]

    public init(
        sql: String,
        bindings: [any Encodable & Sendable]
    ) {
        self.sql = sql
        self.bindings = bindings
    }
}
