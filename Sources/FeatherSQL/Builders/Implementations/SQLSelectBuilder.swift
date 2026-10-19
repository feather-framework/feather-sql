/// Builds ``SQLSelect`` queries.
///
/// > Note: This is effectively nothing but a concrete conformance to ``SQLSubqueryClauseBuilder``
/// > which provides storage for the ``SQLSelect`` and adds ``SQLQueryBuilder`` so the query can
/// > actually be executed.
public struct SQLSelectBuilder: SQLQueryBuilder, SQLSubqueryClauseBuilder {
    // See `SQLSubqueryClauseBuilder.select`.
    public var select: SQLSelect

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.select
    }

    /// Create a new ``SQLSelectBuilder``.
    @inlinable
    public init(on builder: SQLBuilder) {
        self.select = .init()
        self.builder = builder
    }
}

extension SQLBuilder {
    /// Create a new ``SQLSelectBuilder``.
    @inlinable
    public func select() -> SQLSelectBuilder {
        .init(on: self)
    }
}
