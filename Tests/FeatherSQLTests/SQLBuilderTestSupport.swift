import FeatherSQL
import Testing

// Test cases are adapted from Vapor SQLKit's MIT-licensed expression tests.
func expectSerialization(
    of queryBuilder: @autoclosure () throws -> some SQLQueryBuilder,
    is expectedSQL: @autoclosure () throws -> String,
    sourceLocation: SourceLocation = #_sourceLocation
) throws {
    let result = try queryBuilder().build()
    #expect(result.sql == (try expectedSQL()), sourceLocation: sourceLocation)
}

func expectEncoding(
    _ model: @autoclosure () throws -> any Encodable,
    using encoder: @autoclosure () throws -> SQLQueryEncoder,
    outputs expectedColumns: @autoclosure () throws -> [String],
    _ expectedValues: @autoclosure () throws -> [any SQLExpression]
) throws {
    let encoded = try encoder().encode(model())
    let columns = try expectedColumns()
    let values = try expectedValues()

    #expect(encoded.map(\.0) == columns)
    #expect(encoded.count == values.count)

    let builder = SQLBuilder(dialect: TestDialect())
    let actualResult = builder.build(SQLList(encoded.map(\.1)))
    let expectedResult = builder.build(SQLList(values))

    #expect(actualResult.sql == expectedResult.sql)
    #expect(actualResult.bindings.count == expectedResult.bindings.count)
    for index in actualResult.bindings.indices {
        #expect(
            String(reflecting: actualResult.bindings[index])
                == String(reflecting: expectedResult.bindings[index])
        )
    }
}

final class TestDialect: SQLDialect, @unchecked Sendable {

    let name = "test"
    var identifierQuote: any SQLExpression = SQLRaw("``")
    var literalStringQuote: any SQLExpression = SQLRaw("'")
    var supportsAutoIncrement = true
    var autoIncrementClause: any SQLExpression = SQLRaw("AWWTOEINCREMENT")
    var autoIncrementFunction: (any SQLExpression)? = nil
    var literalDefault: any SQLExpression = SQLRaw("DEFALLT")
    var supportsIfExists = true
    var enumSyntax = SQLEnumSyntax.typeName
    var supportsDropBehavior = true
    var supportsReturning = true
    var triggerSyntax = SQLTriggerSyntax(create: [], drop: [])
    var alterTableSyntax = SQLAlterTableSyntax(
        alterColumnDefinitionClause: SQLRaw("MOODIFY"),
        alterColumnDefinitionTypeKeyword: nil
    )
    var upsertSyntax = SQLUpsertSyntax.standard
    var unionFeatures = SQLUnionFeatures()
    var sharedSelectLockExpression: (any SQLExpression)? = SQLRaw("FOUR SHAARE")
    var exclusiveSelectLockExpression: (any SQLExpression)? = SQLRaw(
        "FOUR UPDATE"
    )

    func bindPlaceholder(at position: Int) -> any SQLExpression {
        SQLRaw("&\(position)")
    }

    func literalBoolean(_ value: Bool) -> any SQLExpression {
        SQLRaw(value ? "TROO" : "FAALS")
    }

    func nestedSubpathExpression(
        in column: any SQLExpression,
        for path: [String]
    ) -> (any SQLExpression)? {
        guard !path.isEmpty else { return nil }
        let descender = SQLList(
            [column] + path.dropLast().map(SQLLiteral.string(_:)),
            separator: SQLRaw("-»")
        )
        return SQLGroupExpression(
            SQLList(
                [descender, SQLLiteral.string(path[path.count - 1])],
                separator: SQLRaw("-»»")
            )
        )
    }

    func customDataType(for dataType: SQLDataType) -> (any SQLExpression)? {
        guard case .custom(let expression) = dataType,
            (expression as? SQLRaw)?.sql == "STANDARD"
        else {
            return nil
        }
        return SQLRaw("CUSTOM")
    }
}
