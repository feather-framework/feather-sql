import Testing

@testable import FeatherSQL

@Suite("Core expression builder tests")
struct SQLBuilderCoreExpressionTests {

    @Test("serializes arithmetic expressions in updates")
    func binaryOperators() throws {
        let builder = SQLBuilder(dialect: TestDialect())
        try expectSerialization(
            of: builder.update("planets")
                .set(
                    "moons",
                    to: SQLBinaryExpression(
                        SQLIdentifier("moons"),
                        .add,
                        SQLLiteral.numeric("1")
                    )
                )
                .where("best_at_space", .greaterThanOrEqual, "yes"),
            is:
                "UPDATE ``planets`` SET ``moons`` = ``moons`` + 1 WHERE ``best_at_space`` >= &1"
        )
    }

    @Test("binds arrays as individual values")
    func insertArrayOfEncodableValues() throws {
        let builder = SQLBuilder(dialect: TestDialect())
        let result = builder.insert(into: "planets")
            .columns("name")
            .values(["Jupiter"])
            .build()

        #expect(result.sql == "INSERT INTO ``planets`` (``name``) VALUES (&1)")
        #expect(result.bindings.count == 1)
        #expect(result.bindings.first as? String == "Jupiter")
    }

    @Test("serializes nested JSON paths through the dialect")
    func jsonPaths() throws {
        let builder = SQLBuilder(dialect: TestDialect())
        try expectSerialization(
            of: builder.select()
                .column(SQLNestedSubpathExpression(column: "json", path: ["a"]))
                .column(
                    SQLNestedSubpathExpression(
                        column: "json",
                        path: ["a", "b"]
                    )
                )
                .column(
                    SQLNestedSubpathExpression(
                        column: "json",
                        path: ["a", "b", "c"]
                    )
                )
                .column(
                    SQLNestedSubpathExpression(
                        column: SQLColumn("json", table: "table"),
                        path: ["a", "b"]
                    )
                ),
            is:
                "SELECT (``json``-»»'a'), (``json``-»'a'-»»'b'), (``json``-»'a'-»'b'-»»'c'), (``table``.``json``-»'a'-»»'b')"
        )
    }

    @Test("escapes quoted identifiers and string literals")
    func quoting() throws {
        let builder = SQLBuilder(dialect: TestDialect())
        try expectSerialization(
            of: builder.raw("\(ident: "foo``bar``") \(literal: "foo'bar'")"),
            is: "``foo````bar`````` 'foo''bar'''"
        )
    }

    @Test("serializes SQLStatement parts with whitespace separation")
    func statementParts() {
        let builder = SQLBuilder(dialect: TestDialect())
        var serializer = SQLSerializer(dialect: builder.dialect)
        serializer.statement {
            $0.append("select", SQLIdentifier("name"))
            $0.append("from", SQLIdentifier("planets"))
        }
        #expect(serializer.sql == "select ``name`` from ``planets``")
    }

    @Test("preserves SQL string key conversion utilities")
    func stringKeyConversions() {
        #expect("aA".convertedToSnakeCase == "a_a")
        #expect("a_b_c".convertedFromSnakeCase == "aBC")
        #expect("abcdef".drop(prefix: "abc") == "def")
    }
}
