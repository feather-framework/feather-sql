/// Common definitions for any query builder which permits specifying range and ordering behaviors.
public protocol SQLPartialResultBuilder {
    /// Zero or more `ORDER BY` clauses.
    var orderBys: [any SQLExpression] { get set }

    /// If set, limits the maximum number of results.
    var limit: Int? { get set }

    /// If set, offsets the results.
    var offset: Int? { get set }
}

// MARK: - Limit/offset

extension SQLPartialResultBuilder {
    /// Adds a `LIMIT` clause to the query. If called more than once, the last call wins.
    ///
    /// - Parameter max: Optional maximum limit. If `nil`, any existing limit is removed.
    ///   The value may not be negative.
    @inlinable
    @discardableResult
    public func limit(_ max: Int?) -> Self {
        var copy = self
        copy.limit = max
        return copy
    }
    /// Adds a `OFFSET` clause to the query. If called more than once, the last call wins.
    ///
    /// - Parameter n: Optional offset. If `nil`, any existing offset is removed. The value may not be negative.
    /// - Returns: `self` for chaining.
    @inlinable
    @discardableResult
    public func offset(_ n: Int?) -> Self {
        var copy = self
        copy.offset = n
        return copy
    }
}

// MARK: - Order

extension SQLPartialResultBuilder {
    /// Adds an `ORDER BY` clause to the query with the specified column and ordering.
    ///
    /// - Parameters:
    ///   - column: Name of column to sort results by. Appended to any previously added orderings.
    ///   - direction: The sort direction for the column.
    @inlinable
    @discardableResult
    public func orderBy(
        _ column: String,
        _ direction: SQLDirection = .ascending
    ) -> Self {
        let copy = self
        return copy.orderBy(SQLColumn(column), direction)
    }

    /// Adds an `ORDER BY` clause to the query with the specifed expression and ordering.
    ///
    /// - Parameters:
    ///   - expression: Expression to sort results by. Appended to any previously added orderings.
    ///   - direction: An expression describing the sort direction for the ordering expression.
    @inlinable
    @discardableResult
    public func orderBy(
        _ expression: any SQLExpression,
        _ direction: any SQLExpression
    ) -> Self {
        let copy = self
        return copy.orderBy(
            SQLOrderBy(expression: expression, direction: direction)
        )
    }
    /// Adds an `ORDER BY` clause to the query using the specified expression.
    ///
    /// - Parameter expression: Expression to sort results by. Appended to any previously added orderings.
    @inlinable
    @discardableResult
    public func orderBy(_ expression: any SQLExpression) -> Self {
        var copy = self
        copy.orderBys.append(expression)
        return copy
    }
}
