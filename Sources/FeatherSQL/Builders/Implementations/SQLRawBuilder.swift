/// Builds raw SQL queries.
public struct SQLRawBuilder: SQLQueryBuilder {
    /// Raw query being built.
    @usableFromInline
    var sql: SQLQueryString

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.sql
    }

    /// Create a new ``SQLRawBuilder``.
    @inlinable
    public init(_ sql: SQLQueryString, on builder: SQLBuilder) {
        self.builder = builder
        self.sql = sql
    }
}

extension SQLBuilder {
    /// Create a new ``SQLRawBuilder``.
    @inlinable
    public func raw(_ sql: SQLQueryString) -> SQLRawBuilder {
        .init(sql, on: self)
    }
}
