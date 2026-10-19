/// Builds ``SQLDelete`` queries.
public struct SQLDeleteBuilder: SQLQueryBuilder, SQLPredicateBuilder,
    SQLReturningBuilder, SQLCommonTableExpressionBuilder
{
    /// ``SQLDelete`` query being built.
    public var delete: SQLDelete

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.delete
    }

    // See `SQLPredicateBuilder.predicate`.
    @inlinable
    public var predicate: (any SQLExpression)? {
        get { self.delete.predicate }
        set { self.delete.predicate = newValue }
    }

    // See `SQLReturningBuilder.returning`.
    @inlinable
    public var returning: SQLReturning? {
        get { self.delete.returning }
        set { self.delete.returning = newValue }
    }

    // See `SQLCommonTableExpressionBuilder.tableExpressionGroup`.
    @inlinable
    public var tableExpressionGroup: SQLCommonTableExpressionGroup? {
        get { self.delete.tableExpressionGroup }
        set { self.delete.tableExpressionGroup = newValue }
    }

    /// Create a new ``SQLDeleteBuilder``.
    @inlinable
    public init(_ delete: SQLDelete, on builder: SQLBuilder) {
        self.delete = delete
        self.builder = builder
    }
}

extension SQLBuilder {
    /// Create a new ``SQLDeleteBuilder``.
    @inlinable
    public func delete(from table: String) -> SQLDeleteBuilder {
        self.delete(from: SQLIdentifier(table))
    }

    /// Create a new ``SQLDeleteBuilder``.
    @inlinable
    public func delete(from table: any SQLExpression) -> SQLDeleteBuilder {
        .init(.init(table: table), on: self)
    }
}
