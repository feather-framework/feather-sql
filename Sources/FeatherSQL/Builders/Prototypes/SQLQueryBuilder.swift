/// A fluent builder that produces SQL but does not execute it.
public protocol SQLQueryBuilder {

    var query: any SQLExpression { get }
    var builder: SQLBuilder { get }
}

extension SQLQueryBuilder {

    public func build() -> SQLBuildResult {
        builder.build(query)
    }
}
