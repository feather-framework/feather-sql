/// Builds ``SQLAlterEnum`` queries.
public struct SQLAlterEnumBuilder: SQLQueryBuilder {
    /// ``SQLAlterEnum`` query being built.
    public var alterEnum: SQLAlterEnum

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.alterEnum
    }

    /// Create a new ``SQLAlterEnumBuilder``.
    @usableFromInline
    init(builder: SQLBuilder, name: any SQLExpression) {
        self.builder = builder
        self.alterEnum = .init(name: name, value: nil)
    }

    /// Append a new case to the enum type.
    @inlinable
    @discardableResult
    public func add(value: String) -> Self {
        let copy = self
        return copy.add(value: SQLLiteral.string(value))
    }
    /// Append a new case to the enum type.
    @inlinable
    @discardableResult
    public func add(value: any SQLExpression) -> Self {
        var copy = self
        copy.alterEnum.value = value
        return copy
    }
}

extension SQLBuilder {
    /// Create a new ``SQLAlterEnumBuilder``.
    @inlinable
    public func alter(enum name: String) -> SQLAlterEnumBuilder {
        self.alter(enum: SQLIdentifier(name))
    }

    /// Create a new ``SQLAlterEnumBuilder``.
    @inlinable
    public func alter(enum name: any SQLExpression) -> SQLAlterEnumBuilder {
        .init(builder: self, name: name)
    }
}
