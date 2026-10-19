/// Builds ``SQLDropTrigger`` queries.
public struct SQLDropTriggerBuilder: SQLQueryBuilder {
    /// ``SQLDropTrigger`` query being built.
    public var dropTrigger: SQLDropTrigger

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.dropTrigger
    }

    /// Create a new ``SQLDropTableBuilder``.
    @inlinable
    public init(_ dropTrigger: SQLDropTrigger, on builder: SQLBuilder) {
        self.dropTrigger = dropTrigger
        self.builder = builder
    }

    /// The optional `IF EXISTS` clause suppresses the error that would normally
    /// result if the table does not exist.
    @inlinable
    @discardableResult
    public func ifExists() -> Self {
        var copy = self
        copy.dropTrigger.ifExists = true
        return copy
    }
    /// The drop behavior clause specifies if objects that depend on a trigger
    /// should also be dropped or not when the trigger is dropped, for databases
    /// that support this.
    @inlinable
    @discardableResult
    public func behavior(_ behavior: SQLDropBehavior) -> Self {
        var copy = self
        copy.dropTrigger.dropBehavior = behavior
        return copy
    }
    /// Adds a `CASCADE` clause to the `DROP TRIGGER` statement instructing that
    /// objects that depend on this trigger should also be dropped.
    @inlinable
    @discardableResult
    public func cascade() -> Self {
        let copy = self
        return copy.behavior(.cascade)
    }
    /// Adds a `RESTRICT` clause to the `DROP TRIGGER` statement instructing that
    /// if any objects depend on this trigger, the drop should be refused.
    @inlinable
    @discardableResult
    public func restrict() -> Self {
        let copy = self
        return copy.behavior(.restrict)
    }
    /// Specify an associated table that owns the trigger to drop, for dialects that require it.
    @inlinable
    @discardableResult
    public func table(_ name: String) -> Self {
        let copy = self
        return copy.table(SQLIdentifier(name))
    }
    /// Specify an associated table that owns the trigger to drop, for dialects that require it.
    @inlinable
    @discardableResult
    public func table(_ name: any SQLExpression) -> Self {
        var copy = self
        copy.dropTrigger.table = name
        return copy
    }
}

extension SQLBuilder {
    /// Create a new ``SQLDropTableBuilder``.
    @inlinable
    public func drop(trigger: String) -> SQLDropTriggerBuilder {
        self.drop(trigger: SQLIdentifier(trigger))
    }

    /// Create a new ``SQLDropTableBuilder``.
    @inlinable
    public func drop(trigger: any SQLExpression) -> SQLDropTriggerBuilder {
        .init(.init(name: trigger), on: self)
    }
}
