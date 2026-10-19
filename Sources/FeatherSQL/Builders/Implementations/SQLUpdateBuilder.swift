/// Builds ``SQLUpdate`` queries.
public struct SQLUpdateBuilder: SQLQueryBuilder, SQLPredicateBuilder,
    SQLReturningBuilder, SQLColumnUpdateBuilder, SQLCommonTableExpressionBuilder
{
    /// An ``SQLUpdate`` containing the complete current state of the builder.
    public var update: SQLUpdate

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.update
    }

    // See `SQLColumnUpdateBuilder.values`.
    @inlinable
    public var values: [any SQLExpression] {
        get { self.update.values }
        set { self.update.values = newValue }
    }

    // See `SQLPredicateBuilder.predicate`.
    @inlinable
    public var predicate: (any SQLExpression)? {
        get { self.update.predicate }
        set { self.update.predicate = newValue }
    }

    // See `SQLReturningBuilder.returning`.
    @inlinable
    public var returning: SQLReturning? {
        get { self.update.returning }
        set { self.update.returning = newValue }
    }

    // See `SQLCommonTableExpressionBuilder.tableExpressionGroup`.
    @inlinable
    public var tableExpressionGroup: SQLCommonTableExpressionGroup? {
        get { self.update.tableExpressionGroup }
        set { self.update.tableExpressionGroup = newValue }
    }

    /// Create a new ``SQLUpdateBuilder``.
    ///
    /// Use this API directly only if you need to have control over the builder's initial update query. Prefer using
    /// ``SQLBuilder/update(_:)-2tf1c`` or ``SQLBuilder/update(_:)-80964`` whnever possible.
    ///
    /// - Parameters:
    ///   - update: A query to use as the builder's initial state. It must at minimum specify a table to update.
    ///   - builder: A builder to associate with the builder.
    @inlinable
    public init(_ update: SQLUpdate, on builder: SQLBuilder) {
        self.update = update
        self.builder = builder
    }
}

extension SQLBuilder {
    /// Create a new ``SQLUpdateBuilder`` associated with this builder.
    ///
    /// - Parameter table: A table to specify for the builder's update query.
    /// - Returns: A new builder.
    @inlinable
    public func update(_ table: String) -> SQLUpdateBuilder {
        self.update(SQLIdentifier(table))
    }

    /// Create a new ``SQLUpdateBuilder`` associated with this builder.
    ///
    /// - Parameter table: An expression used as the target of the builder's update query.
    /// - Returns: A new builder.
    @inlinable
    public func update(_ table: any SQLExpression) -> SQLUpdateBuilder {
        .init(.init(table: table), on: self)
    }
}
