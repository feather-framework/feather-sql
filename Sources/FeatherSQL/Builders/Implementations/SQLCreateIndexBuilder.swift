/// Builds ``SQLCreateIndex`` queries.
public struct SQLCreateIndexBuilder: SQLQueryBuilder {
    /// ``SQLCreateIndex`` query being built.
    public var createIndex: SQLCreateIndex

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.createIndex
    }

    /// Create a new ``SQLCreateIndexBuilder``.
    @inlinable
    public init(_ createIndex: SQLCreateIndex, on builder: SQLBuilder) {
        self.createIndex = createIndex
        self.builder = builder
    }

    /// Adds `UNIQUE` modifier to the index being created.
    @inlinable
    @discardableResult
    public func unique() -> Self {
        var copy = self
        copy.createIndex.modifier = SQLColumnConstraintAlgorithm.unique
        return copy
    }
    /// Specify a table to operate on.
    @inlinable
    @discardableResult
    public func on(_ table: String) -> Self {
        let copy = self
        return copy.on(SQLIdentifier(table))
    }
    /// Specify a table to operate on.
    @inlinable
    @discardableResult
    public func on(_ table: any SQLExpression) -> Self {
        var copy = self
        copy.createIndex.table = table
        return copy
    }
    /// Specify a column to include in the created index.
    @inlinable
    @discardableResult
    public func column(_ column: String) -> Self {
        let copy = self
        return copy.column(SQLIdentifier(column))
    }
    /// Specify a column to include in the created index.
    @inlinable
    @discardableResult
    public func column(_ column: any SQLExpression) -> Self {
        var copy = self
        copy.createIndex.columns.append(column)
        return copy
    }
}

// MARK: Connection

extension SQLBuilder {
    /// Creates a new ``SQLCreateIndexBuilder``.
    @inlinable
    public func create(index name: String) -> SQLCreateIndexBuilder {
        self.create(index: SQLIdentifier(name))
    }

    /// Creates a new ``SQLCreateIndexBuilder``.
    @inlinable
    public func create(index name: any SQLExpression) -> SQLCreateIndexBuilder {
        .init(.init(name: name), on: self)
    }
}
