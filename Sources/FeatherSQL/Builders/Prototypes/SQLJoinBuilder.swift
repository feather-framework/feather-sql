/// Common definitions for any query builder which permits specifying joins.
public protocol SQLJoinBuilder {
    /// The set of joins to be applied to the query.
    var joins: [any SQLExpression] { get set }
}

extension SQLJoinBuilder {
    /// Include the given table in the list of those used by the query, performing an explicit join using the
    /// given method and condition(s). Tables are joined left to right.
    ///
    /// - Parameters:
    ///   - table: The name of the table to join.
    ///   - method: The join method to use.
    ///   - expression: A string containing a join condition.
    @inlinable
    @discardableResult
    public func join(
        _ table: String,
        method: SQLJoinMethod = .inner,
        on expression: any SQLExpression
    ) -> Self {
        let copy = self
        return copy.join(SQLIdentifier(table), method: method, on: expression)
    }
    /// Include the given table in the list of those used by the query, performing an explicit join using the
    /// given method and condition(s). Tables are joined left to right.
    ///
    /// - Parameters:
    ///   - table: The name of the table to join.
    ///   - method: The join method to use.
    ///   - expression: A string containing a join condition.
    @inlinable
    @discardableResult
    public func join(
        _ table: any SQLExpression,
        method: any SQLExpression = SQLJoinMethod.inner,
        on expression: any SQLExpression
    ) -> Self {
        var copy = self
        copy.joins.append(
            SQLJoin(method: method, table: table, expression: expression)
        )
        return copy
    }
    /// Include the given table in the list of those used by the query, performing an explicit join using the
    /// given method and condition(s). Tables are joined left to right.
    ///
    /// - Parameters:
    ///   - table: The name of the table to join.
    ///   - method: The join method to use.
    ///   - left: The left side of a ``SQLBinaryExpression``.
    ///   - op: A ``SQLBinaryOperator``.
    ///   - right: The right side of a ``SQLBinaryExpression``.
    @inlinable
    @discardableResult
    public func join(
        _ table: String,
        method: any SQLExpression = SQLJoinMethod.inner,
        on left: any SQLExpression,
        _ op: SQLBinaryOperator,
        _ right: any SQLExpression
    ) -> Self {
        let copy = self
        return copy.join(
            SQLIdentifier(table),
            method: method,
            on: left,
            op,
            right
        )
    }
    /// Include the given table in the list of those used by the query, performing an explicit join using the
    /// given method and condition(s). Tables are joined left to right.
    ///
    /// - Parameters:
    ///   - table: The name of the table to join.
    ///   - method: The join method to use.
    ///   - left: The left side of a ``SQLBinaryExpression``.
    ///   - op: A ``SQLBinaryOperator``.
    ///   - right: The right side of a ``SQLBinaryExpression``.
    @inlinable
    @discardableResult
    public func join(
        _ table: any SQLExpression,
        method: any SQLExpression = SQLJoinMethod.inner,
        on left: any SQLExpression,
        _ op: SQLBinaryOperator,
        _ right: any SQLExpression
    ) -> Self {
        let copy = self
        return copy.join(
            table,
            method: method,
            on: SQLBinaryExpression(left: left, op: op, right: right)
        )
    }
    /// Include the given table in the list of those used by the query, performing an explicit join using the
    /// given method and columns. Tables are joined left to right.
    ///
    /// - Parameters:
    ///   - table: The name of the table to join.
    ///   - method: The join method to use.
    ///   - columns: One or more columns to use to perform a `NATURAL JOIN`.
    @inlinable
    @discardableResult
    public func join(
        _ table: any SQLExpression,
        method: any SQLExpression = SQLJoinMethod.inner,
        using columns: any SQLExpression
    ) -> Self {
        var copy = self
        // TODO: Make ``SQLJoin`` aware of the `USING` syntax; this method is hacky and somewhat driver-specific.
        copy.joins.append(
            SQLList(
                [
                    method, SQLRaw("JOIN"), table, SQLRaw("USING"),
                    SQLGroupExpression(columns),
                ],
                separator: SQLRaw(" ")
            )
        )
        return copy
    }
}
