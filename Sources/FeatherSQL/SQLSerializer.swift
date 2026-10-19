/// Serializes SQLKit expressions using a dialect without owning a database connection.
public struct SQLSerializer: Sendable {

    public var sql: String
    public var binds: [any Encodable & Sendable]
    public let dialect: any SQLDialect

    public init(dialect: any SQLDialect) {
        self.sql = ""
        self.binds = []
        self.dialect = dialect
    }

    public mutating func write(bind value: any Encodable & Sendable) {
        binds.append(value)
        dialect.bindPlaceholder(at: binds.count).serialize(to: &self)
    }

    public mutating func write(_ sql: String) {
        self.sql += sql
    }
}
