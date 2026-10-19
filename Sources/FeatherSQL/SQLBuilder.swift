/// SQLKit's builder entry point, detached from connection and execution APIs.
public struct SQLBuilder: Sendable {

    public let dialect: any SQLDialect

    public init(dialect: any SQLDialect) {
        self.dialect = dialect
    }

    public func build(
        _ expression: any SQLExpression
    ) -> SQLBuildResult {
        var serializer = SQLSerializer(dialect: dialect)
        expression.serialize(to: &serializer)
        return SQLBuildResult(sql: serializer.sql, bindings: serializer.binds)
    }
}
