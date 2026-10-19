/// Builds ``SQLDropEnum`` queries.
public struct SQLDropEnumBuilder: SQLQueryBuilder {
    /// ``SQLDropEnum`` query being built.
    public var dropEnum: SQLDropEnum

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.dropEnum
    }

    /// Create a new ``SQLDropEnumBuilder``.
    @usableFromInline
    init(name: any SQLExpression, on builder: SQLBuilder) {
        self.dropEnum = .init(name: name)
        self.builder = builder
    }

    /// The optional `IF EXISTS` clause suppresses the error that would normally
    /// result if the type does not exist.
    @inlinable
    @discardableResult
    public func ifExists() -> Self {
        var copy = self
        copy.dropEnum.ifExists = true
        return copy
    }
    /// The drop behavior clause specifies if objects that depend on a type
    /// should also be dropped or not when the type is dropped, for databases
    /// that support this.
    @inlinable
    @discardableResult
    public func behavior(_ behavior: SQLDropBehavior) -> Self {
        var copy = self
        copy.dropEnum.dropBehavior = behavior
        return copy
    }
    /// Adds a `CASCADE` clause to the `DROP TYPE` statement instructing that
    /// objects that depend on this type should also be dropped.
    @inlinable
    @discardableResult
    public func cascade() -> Self {
        let copy = self
        return copy.behavior(.cascade)
    }
    /// Adds a `RESTRICT` clause to the `DROP TYPE` statement instructing that
    /// if any objects depend on this type, the drop should be refused.
    @inlinable
    @discardableResult
    public func restrict() -> Self {
        let copy = self
        return copy.behavior(.restrict)
    }
}

extension SQLBuilder {
    /// Create a new ``SQLDropEnumBuilder``.
    @inlinable
    public func drop(enum name: String) -> SQLDropEnumBuilder {
        self.drop(enum: SQLIdentifier(name))
    }

    /// Create a new ``SQLDropEnumBuilder``.
    @inlinable
    public func drop(enum name: any SQLExpression) -> SQLDropEnumBuilder {
        .init(name: name, on: self)
    }
}
