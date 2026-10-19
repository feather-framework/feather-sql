/// Builds ``SQLDropIndex`` queries.
public struct SQLDropIndexBuilder: SQLQueryBuilder {
    /// ``SQLDropIndex`` query being built.
    public var dropIndex: SQLDropIndex

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    public var query: any SQLExpression {
        self.dropIndex
    }

    /// Create a new ``SQLDropIndexBuilder``.
    public init(_ dropIndex: SQLDropIndex, on builder: SQLBuilder) {
        self.dropIndex = dropIndex
        self.builder = builder
    }

    /// The optional `IF EXISTS` clause suppresses the error that would normally
    /// result if the index does not exist.
    @inlinable
    @discardableResult
    public func ifExists() -> Self {
        var copy = self
        copy.dropIndex.ifExists = true
        return copy
    }
    /// Convenience method for specifying an owning object using a `String`. See
    /// ``on(_:)-84xo2`` for details.
    @inlinable
    @discardableResult
    public func on(_ owningObject: String) -> Self {
        let copy = self
        return copy.on(SQLIdentifier(owningObject))
    }
    /// The object (usually a table) which owns the index may be explicitly specified.
    /// Some dialects treat indexes as builder-level objects in their own right and
    /// treat specifying an owner as an error, while others require the owning object
    /// in order to perform the drop operation at all. At the time of this writing,
    /// there is no support for specifying this in ``SQLDialect``; callers must ensure
    /// that they either specify or omit an owning object as appropriate.
    @inlinable
    @discardableResult
    public func on(_ owningObject: any SQLExpression) -> Self {
        var copy = self
        copy.dropIndex.owningObject = owningObject
        return copy
    }
    /// The drop behavior clause specifies if objects that depend on a index
    /// should also be dropped or not when the index is dropped, for databases
    /// that support this.
    @inlinable
    @discardableResult
    public func behavior(_ behavior: SQLDropBehavior) -> Self {
        var copy = self
        copy.dropIndex.behavior = behavior
        return copy
    }
    /// Adds a `CASCADE` clause to the `DROP INDEX` statement instructing that
    /// objects that depend on this index should also be dropped.
    @inlinable
    @discardableResult
    public func cascade() -> Self {
        let copy = self
        return copy.behavior(.cascade)
    }
    /// Adds a `RESTRICT` clause to the `DROP INDEX` statement instructing that
    /// if any objects depend on this index, the drop should be refused.
    @inlinable
    @discardableResult
    public func restrict() -> Self {
        let copy = self
        return copy.behavior(.restrict)
    }
}

extension SQLBuilder {
    /// Create a new ``SQLDropIndexBuilder``.
    @inlinable
    public func drop(index name: String) -> SQLDropIndexBuilder {
        self.drop(index: SQLIdentifier(name))
    }

    /// Create a new ``SQLDropIndexBuilder``.
    @inlinable
    public func drop(index name: any SQLExpression) -> SQLDropIndexBuilder {
        .init(.init(name: name), on: self)
    }
}
