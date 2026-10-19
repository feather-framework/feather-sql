/// Builds ``SQLAlterTable`` queries.
public struct SQLAlterTableBuilder: SQLQueryBuilder {
    /// ``SQLAlterTable`` query being built.
    public var alterTable: SQLAlterTable

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.alterTable
    }

    /// Create a new ``SQLAlterTableBuilder``.
    @inlinable
    public init(_ alterTable: SQLAlterTable, on builder: SQLBuilder) {
        self.alterTable = alterTable
        self.builder = builder
    }

    /// Rename the table.
    @inlinable
    @discardableResult
    public func rename(to newName: String) -> Self {
        let copy = self
        return copy.rename(to: SQLIdentifier(newName))
    }
    /// Rename the table.
    @inlinable
    @discardableResult
    public func rename(to newName: any SQLExpression) -> Self {
        var copy = self
        copy.alterTable.renameTo = newName
        return copy
    }
    /// Add a new column to the table.
    @inlinable
    @discardableResult
    public func column(
        _ column: String,
        type dataType: SQLDataType,
        _ constraints: SQLColumnConstraintAlgorithm...
    ) -> Self {
        let copy = self
        return copy.column(column, type: dataType, constraints)
    }
    /// Add a new column to the table.
    @inlinable
    @discardableResult
    public func column(
        _ column: String,
        type dataType: SQLDataType,
        _ constraints: [SQLColumnConstraintAlgorithm]
    ) -> Self {
        let copy = self
        return copy.column(SQLIdentifier(column), type: dataType, constraints)
    }
    /// Add a new column to the table.
    @inlinable
    @discardableResult
    public func column(
        _ column: any SQLExpression,
        type dataType: any SQLExpression,
        _ constraints: any SQLExpression...
    ) -> Self {
        let copy = self
        return copy.column(column, type: dataType, constraints)
    }
    /// Add a new column to the table.
    @inlinable
    @discardableResult
    public func column(
        _ column: any SQLExpression,
        type dataType: any SQLExpression,
        _ constraints: [any SQLExpression]
    ) -> Self {
        let copy = self
        return copy.addColumn(
            SQLColumnDefinition(
                column: column,
                dataType: dataType,
                constraints: constraints
            )
        )
    }
    /// Add a new column to the table.
    @inlinable
    @discardableResult
    public func addColumn(_ columnDefinition: any SQLExpression) -> Self {
        var copy = self
        copy.alterTable.addColumns.append(columnDefinition)
        return copy
    }
    /// Change an existing column's type and constraints.
    @inlinable
    @discardableResult
    public func modifyColumn(
        _ column: String,
        type dataType: SQLDataType,
        _ constraints: SQLColumnConstraintAlgorithm...
    ) -> Self {
        let copy = self
        return copy.modifyColumn(column, type: dataType, constraints)
    }
    /// Change an existing column's type and constraints.
    @inlinable
    @discardableResult
    public func modifyColumn(
        _ column: String,
        type dataType: SQLDataType,
        _ constraints: [SQLColumnConstraintAlgorithm]
    ) -> Self {
        let copy = self
        return copy.modifyColumn(
            SQLIdentifier(column),
            type: dataType,
            constraints
        )
    }
    /// Change an existing column's type and constraints.
    @inlinable
    @discardableResult
    public func modifyColumn(
        _ column: any SQLExpression,
        type dataType: any SQLExpression,
        _ constraints: any SQLExpression...
    ) -> Self {
        let copy = self
        return copy.modifyColumn(column, type: dataType, constraints)
    }
    /// Change an existing column's type and constraints.
    @inlinable
    @discardableResult
    public func modifyColumn(
        _ column: any SQLExpression,
        type dataType: any SQLExpression,
        _ constraints: [any SQLExpression]
    ) -> Self {
        let copy = self
        return copy.modifyColumn(
            SQLColumnDefinition(
                column: column,
                dataType: dataType,
                constraints: constraints
            )
        )
    }
    /// Change an existing column's type.
    @inlinable
    @discardableResult
    public func update(column: String, type dataType: SQLDataType) -> Self {
        let copy = self
        return copy.update(column: SQLIdentifier(column), type: dataType)
    }
    /// Change an existing column's type.
    @inlinable
    @discardableResult
    public func update(
        column: any SQLExpression,
        type dataType: any SQLExpression
    ) -> Self {
        let copy = self
        return copy.modifyColumn(
            SQLAlterColumnDefinitionType(column: column, dataType: dataType)
        )
    }
    /// Alter an existing column.
    @inlinable
    @discardableResult
    public func modifyColumn(_ columnDefinition: any SQLExpression) -> Self {
        var copy = self
        copy.alterTable.modifyColumns.append(columnDefinition)
        return copy
    }
    /// Drop an existing column from the table.
    @inlinable
    @discardableResult
    public func dropColumn(_ column: String) -> Self {
        let copy = self
        return copy.dropColumn(SQLIdentifier(column))
    }
    /// Drop an existing column from the table.
    @inlinable
    @discardableResult
    public func dropColumn(_ column: any SQLExpression) -> Self {
        var copy = self
        copy.alterTable.dropColumns.append(column)
        return copy
    }
}

extension SQLBuilder {
    /// Create a new ``SQLAlterTableBuilder``.
    @inlinable
    public func alter(table: String) -> SQLAlterTableBuilder {
        self.alter(table: SQLIdentifier(table))
    }

    /// Create a new ``SQLAlterTableBuilder``.
    @inlinable
    public func alter(table: SQLIdentifier) -> SQLAlterTableBuilder {
        self.alter(table: table as any SQLExpression)
    }

    /// Create a new ``SQLAlterTableBuilder``.
    @inlinable
    public func alter(table: any SQLExpression) -> SQLAlterTableBuilder {
        .init(.init(name: table), on: self)
    }
}
