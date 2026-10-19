/// Builds ``SQLCreateTable`` queries.
public struct SQLCreateTableBuilder: SQLQueryBuilder {
    /// ``SQLCreateTable`` query being built.
    public var createTable: SQLCreateTable

    // See `SQLQueryBuilder.builder`.
    public var builder: SQLBuilder

    // See `SQLQueryBuilder.query`.
    @inlinable
    public var query: any SQLExpression {
        self.createTable
    }

    /// The set of column definitions.
    @inlinable
    public var columns: [any SQLExpression] {
        get { self.createTable.columns }
        set { self.createTable.columns = newValue }
    }

    /// Create a new ``SQLCreateTableBuilder``.
    @inlinable
    public init(_ createTable: SQLCreateTable, on builder: SQLBuilder) {
        self.createTable = createTable
        self.builder = builder
    }

    /// Add a new column by name, type, and constraints.
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
    /// Add a new column by name, type, and constraints.
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
    /// Add a new column by name, type, and constraints.
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
    /// Add a new column by name, type, and constraints.
    @inlinable
    @discardableResult
    public func column(
        _ column: any SQLExpression,
        type dataType: any SQLExpression,
        _ constraints: [any SQLExpression]
    ) -> Self {
        let copy = self
        return copy.column(
            SQLColumnDefinition(
                column: column,
                dataType: dataType,
                constraints: constraints
            )
        )
    }
    /// Add a new column definition.
    @inlinable
    @discardableResult
    public func column(_ columnDefinition: any SQLExpression) -> Self {
        var copy = self
        copy.columns.append(columnDefinition)
        return copy
    }
    /// Add multiple column definitions.
    @inlinable
    @discardableResult
    public func column(definitions: [SQLColumnDefinition])
        -> SQLCreateTableBuilder
    {
        var copy = self
        copy.columns.append(contentsOf: definitions)
        return copy
    }

    /// Mark the new table as temporary.
    @inlinable
    @discardableResult
    public func temporary() -> Self {
        var copy = self
        copy.createTable.temporary = true
        return copy
    }
    /// It is usually an error to attempt to create a new table in a builder that already contains a table, index or view of the
    /// same name. However, if the "IF NOT EXISTS" clause is specified as part of the CREATE TABLE statement and a table or view
    /// of the same name already exists, the CREATE TABLE command simply has no effect (and no error message is returned). An
    /// error is still returned if the table cannot be created because of an existing index, even if the "IF NOT EXISTS" clause is
    /// specified.
    @inlinable
    @discardableResult
    public func ifNotExists() -> Self {
        var copy = self
        copy.createTable.ifNotExists = true
        return copy
    }
    /// Specify a `SELECT` query to be used to populate the new table.
    ///
    /// If called more than once, each subsequent invocation overwrites the query from the one before.
    @inlinable
    @discardableResult
    public func select(
        _ closure: (SQLSubqueryBuilder) throws -> SQLSubqueryBuilder
    ) rethrows -> Self {
        var copy = self
        let builder = SQLSubqueryBuilder()
        let selected = try closure(builder)
        copy.createTable.asQuery = selected.select
        return copy
    }
}

// MARK: Constraints

extension SQLCreateTableBuilder {
    /// Add a `PRIMARY KEY` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the primary key.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func primaryKey(
        _ columns: String...,
        named constraintName: String? = nil
    ) -> Self {
        let copy = self
        return copy.primaryKey(columns, named: constraintName)
    }
    /// Add a `PRIMARY KEY` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the primary key.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func primaryKey(
        _ columns: [String],
        named constraintName: String? = nil
    ) -> Self {
        let copy = self
        return copy.primaryKey(
            columns.map(SQLIdentifier.init(_:)),
            named: constraintName.map(SQLIdentifier.init(_:))
        )
    }
    /// Add a `PRIMARY KEY` constraint to the table.
    ///
    /// - parameters:
    ///   - columns: One or more columns to include in the primary key.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func primaryKey(
        _ columns: [any SQLExpression],
        named constraintName: (any SQLExpression)? = nil
    ) -> Self {
        var copy = self
        copy.createTable.tableConstraints.append(
            SQLConstraint(
                algorithm: SQLTableConstraintAlgorithm.primaryKey(
                    columns: columns
                ),
                name: constraintName
            )
        )
        return copy
    }
    /// Add a `UNIQUE` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the unique constraint.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func unique(
        _ columns: String...,
        named constraintName: String? = nil
    ) -> Self {
        let copy = self
        return copy.unique(columns, named: constraintName)
    }
    /// Add a `UNIQUE` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the unique constraint.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func unique(_ columns: [String], named constraintName: String? = nil)
        -> Self
    {
        let copy = self
        return copy.unique(
            columns.map(SQLIdentifier.init(_:)),
            named: constraintName.map(SQLIdentifier.init(_:))
        )
    }
    /// Add a `UNIQUE` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the unique constraint.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func unique(
        _ columns: [any SQLExpression],
        named constraintName: (any SQLExpression)? = nil
    ) -> Self {
        var copy = self
        copy.createTable.tableConstraints.append(
            SQLConstraint(
                algorithm: SQLTableConstraintAlgorithm.unique(columns: columns),
                name: constraintName
            )
        )
        return copy
    }
    /// Add a `CHECK` constraint to the table.
    ///
    /// - Parameters:
    ///   - expression: A check constraint expression.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func check(
        _ expression: any SQLExpression,
        named constraintName: String? = nil
    ) -> Self {
        let copy = self
        return copy.check(
            expression,
            named: constraintName.map(SQLIdentifier.init(_:))
        )
    }
    /// Add a `CHECK` constraint to the table.
    ///
    /// - Parameters:
    ///   - expression: A check constraint expression.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func check(
        _ expression: any SQLExpression,
        named constraintName: (any SQLExpression)? = nil
    ) -> Self {
        var copy = self
        copy.createTable.tableConstraints.append(
            SQLConstraint(
                algorithm: SQLTableConstraintAlgorithm.check(expression),
                name: constraintName
            )
        )
        return copy
    }
    /// Add a `FOREIGN KEY` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the constraint.
    ///   - foreignTable: The table referenced by the constraint.
    ///   - foreignColumns: The foreign table columns corresponding to the constrained columns.
    ///   - onDelete: Optional foreign key action to perform on delete.
    ///   - onUpdate: Optional foreign key action to perform on update.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func foreignKey(
        _ columns: [String],
        references foreignTable: String,
        _ foreignColumns: [String],
        onDelete: SQLForeignKeyAction? = nil,
        onUpdate: SQLForeignKeyAction? = nil,
        named constraintName: String? = nil
    ) -> Self {
        let copy = self
        return copy.foreignKey(
            columns.map(SQLIdentifier.init(_:)),
            references: SQLIdentifier(foreignTable),
            foreignColumns.map(SQLIdentifier.init(_:)),
            onDelete: onDelete,
            onUpdate: onUpdate,
            named: constraintName.map(SQLIdentifier.init(_:))
        )
    }
    /// Add a `FOREIGN KEY` constraint to the table.
    ///
    /// - Parameters:
    ///   - columns: One or more columns to include in the constraint.
    ///   - foreignTable: The table referenced by the constraint.
    ///   - foreignColumns: The foreign table columns corresponding to the constrained columns.
    ///   - onDelete: Optional foreign key action to perform on delete.
    ///   - onUpdate: Optional foreign key action to perform on update.
    ///   - constraintName: An optional name to give the constraint.
    @inlinable
    @discardableResult
    public func foreignKey(
        _ columns: [any SQLExpression],
        references foreignTable: any SQLExpression,
        _ foreignColumns: [any SQLExpression],
        onDelete: (any SQLExpression)? = nil,
        onUpdate: (any SQLExpression)? = nil,
        named constraintName: (any SQLExpression)? = nil
    ) -> Self {
        var copy = self
        copy.createTable.tableConstraints.append(
            SQLConstraint(
                algorithm: SQLTableConstraintAlgorithm.foreignKey(
                    columns: columns,
                    references: SQLForeignKey(
                        table: foreignTable,
                        columns: foreignColumns,
                        onDelete: onDelete,
                        onUpdate: onUpdate
                    )
                ),
                name: constraintName
            )
        )
        return copy
    }
}

// MARK: Connection

extension SQLBuilder {
    /// Create a new ``SQLCreateTableBuilder``.
    @inlinable
    public func create(table: String) -> SQLCreateTableBuilder {
        self.create(table: SQLIdentifier(table))
    }

    /// Create a new ``SQLCreateTableBuilder``.
    @inlinable
    public func create(table: any SQLExpression) -> SQLCreateTableBuilder {
        .init(.init(name: table), on: self)
    }
}
