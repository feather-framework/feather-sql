/// Builds ``SQLCreateTrigger`` queries.
public struct SQLCreateTriggerBuilder: SQLQueryBuilder {
    /// ``SQLCreateTrigger`` query being built.
    public var createTrigger: SQLCreateTrigger

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.createTrigger
    }

    /// Create a new ``SQLCreateTriggerBuilder``.
    @usableFromInline
    init(
        trigger: any SQLExpression,
        table: any SQLExpression,
        when: any SQLExpression,
        event: any SQLExpression,
        on builder: SQLBuilder
    ) {
        self.createTrigger = .init(
            trigger: trigger,
            table: table,
            when: when,
            event: event
        )
        self.builder = builder
    }

    /// Identifies whether the trigger applies to each row or each statement.
    @inlinable
    @discardableResult
    public func each(_ value: SQLCreateTrigger.EachSpecifier) -> Self {
        let copy = self
        return copy.each(value as any SQLExpression)
    }
    /// Identifies whether the trigger applies to each row or each statement.
    @inlinable
    @discardableResult
    public func each(_ value: any SQLExpression) -> Self {
        var copy = self
        copy.createTrigger.each = value
        return copy
    }
    /// Specifies this is a constraint trigger.
    @inlinable
    @discardableResult
    public func isConstraint() -> Self {
        var copy = self
        copy.createTrigger.isConstraint = true
        return copy
    }
    /// Specify the columns to which the trigger applies.
    @inlinable
    @discardableResult
    public func columns(_ columns: [String]) -> Self {
        let copy = self
        return copy.columns(columns.map(SQLIdentifier.init(_:)))
    }
    /// Specify the columns to which the trigger applies.
    @inlinable
    @discardableResult
    public func columns(_ columns: [any SQLExpression]) -> Self {
        var copy = self
        copy.createTrigger.columns = columns
        return copy
    }
    /// Specify the trigger's timing.
    ///
    /// > Note: Only applies to constraint triggers.
    @inlinable
    @discardableResult
    public func timing(_ value: SQLCreateTrigger.TimingSpecifier) -> Self {
        let copy = self
        return copy.timing(value as any SQLExpression)
    }
    /// Specify the trigger's timing.
    ///
    /// > Note: Only applies to constraint triggers.
    @inlinable
    @discardableResult
    public func timing(_ value: any SQLExpression) -> Self {
        var copy = self
        copy.createTrigger.timing = value
        return copy
    }
    /// Specify a conditional expression which determines whether the trigger is actually executed.
    @inlinable
    @discardableResult
    public func condition(_ value: any SQLExpression) -> Self {
        var copy = self
        copy.createTrigger.condition = value
        return copy
    }
    /// Specify the name of another table referenced by the constraint.
    ///
    /// To specify a schema-qualified table, use ``SQLQualifiedTable``.
    ///
    /// > Note: This option is used for foreign key constraints and is not recommended for general use. Only applies to constraint triggers.
    @inlinable
    @discardableResult
    public func referencedTable(_ value: String) -> Self {
        let copy = self
        return copy.referencedTable(SQLIdentifier(value))
    }
    /// Specify the name of another table referenced by the constraint.
    ///
    /// To specify a schema-qualified table, use ``SQLQualifiedTable``.
    ///
    /// > Note: This option is used for foreign key constraints and is not recommended for general use. Only applies to constraint triggers.
    @inlinable
    @discardableResult
    public func referencedTable(_ value: any SQLExpression) -> Self {
        var copy = self
        copy.createTrigger.referencedTable = value
        return copy
    }
    /// Specify a body for the trigger.
    @inlinable
    @discardableResult
    public func body(_ statements: [any SQLExpression]) -> Self {
        var copy = self
        copy.createTrigger.body = statements
        return copy
    }
    /// Specify a procedure name for the trigger to execute.
    @inlinable
    @discardableResult
    public func procedure(_ name: String) -> Self {
        let copy = self
        return copy.procedure(SQLIdentifier(name))
    }
    /// Specify a procedure name for the trigger to execute.
    @inlinable
    @discardableResult
    public func procedure(_ name: any SQLExpression) -> Self {
        var copy = self
        copy.createTrigger.procedure = name
        return copy
    }
    /// Specify whether this trigger precedes or follows a referenced trigger.
    @inlinable
    @discardableResult
    public func order(
        precedence: SQLCreateTrigger.OrderSpecifier,
        otherTriggerName: String
    ) -> Self {
        let copy = self
        return copy.order(
            precedence: precedence,
            otherTriggerName: SQLIdentifier(otherTriggerName)
        )
    }
    /// Specify whether this trigger precedes or follows a referenced trigger.
    @inlinable
    @discardableResult
    public func order(
        precedence: SQLCreateTrigger.OrderSpecifier,
        otherTriggerName: any SQLExpression
    ) -> Self {
        let copy = self
        return copy.order(
            precedence: precedence as any SQLExpression,
            otherTriggerName: otherTriggerName
        )
    }
    /// Specify whether this trigger precedes or follows a referenced trigger.
    @inlinable
    @discardableResult
    public func order(
        precedence: any SQLExpression,
        otherTriggerName: any SQLExpression
    ) -> Self {
        var copy = self
        copy.createTrigger.order = precedence
        copy.createTrigger.orderTriggerName = otherTriggerName
        return copy
    }
}

extension SQLBuilder {
    /// Create a new ``SQLCreateTriggerBuilder``.
    @inlinable
    public func create(
        trigger: String,
        table: String,
        when: SQLCreateTrigger.WhenSpecifier,
        event: SQLCreateTrigger.EventSpecifier
    ) -> SQLCreateTriggerBuilder {
        self.create(
            trigger: SQLIdentifier(trigger),
            table: SQLIdentifier(table),
            when: when,
            event: event
        )
    }

    /// Create a new ``SQLCreateTriggerBuilder``.
    @inlinable
    public func create(
        trigger: any SQLExpression,
        table: any SQLExpression,
        when: any SQLExpression,
        event: any SQLExpression
    ) -> SQLCreateTriggerBuilder {
        .init(
            trigger: trigger,
            table: table,
            when: when,
            event: event,
            on: self
        )
    }
}
