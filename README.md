# FeatherSQL

FeatherSQL is a connection-free SQL expression and serialization library for
Swift. It builds SQL statements and parameter bindings for a supplied SQL
dialect; database connections, transactions, and execution belong to
[FeatherDatabase](https://github.com/feather-framework/feather-database) and
driver packages.

[![Release: 1.0.0-alpha.1](https://img.shields.io/badge/Release-1.0.0--alpha.1-F05138)](https://github.com/feather-framework/feather-sql/releases/tag/1.0.0-alpha.1)
[![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)](https://feather-framework.github.io/feather-sql/)
![Swift 6.3+](https://img.shields.io/badge/Swift-6.3%2B-F05138)

## Features

- Composable SQL expressions and query builders
- Parameterized query serialization with bound values
- Dialect-defined SQL syntax and capabilities
- No database driver or connection dependency
- Swift concurrency and strict-concurrency support

## Requirements

- Swift 6.3 or later
- macOS 15+, iOS 18+, tvOS 18+, watchOS 11+, or visionOS 2+
- Linux

## Installation

Add the `1.0.0-alpha.1` release to your package dependencies and target:

```swift
.package(url: "https://github.com/feather-framework/feather-sql", exact: "1.0.0-alpha.1"),
```

```swift
.product(name: "FeatherSQL", package: "feather-sql"),
```

This is an alpha release; APIs may change before the stable `1.0.0` release.

Use a dialect package alongside FeatherSQL. For example, the PostgreSQL
dialect is provided separately by
[FeatherSQLPostgres](https://github.com/feather-framework/feather-sql-postgres).

## Usage

Build a query with a dialect, then pass the resulting SQL and bindings to a
database adapter:

```swift
import FeatherSQL
import FeatherSQLPostgres

let sql = SQLBuilder.postgres
    .select()
    .column("id")
    .column("email")
    .from("users")
    .where("email", .equal, "user@example.com")
    .build()

print(sql.sql) // SELECT "id", "email" FROM "users" WHERE "email" = $1
print(sql.bindings) // ["user@example.com"]
```

FeatherSQL only constructs the statement. It does not open a connection or run
the query.

## Development

```sh
swift build
swift test
swift format lint --strict --recursive Sources Tests
```

Pull requests run Swift formatting and soundness checks, plus the test suite on
Linux. Tagged releases and manual workflow runs publish DocC documentation to
GitHub Pages.

## Origins and attribution

FeatherSQL is a fork of the Vapor SQLKit ecosystem. Its SQL expression,
query-builder, serialization, and dialect behavior are derived from these
upstream repositories:

- [SQLKit](https://github.com/vapor/sql-kit) — core SQL expressions,
  query builders, and serialization
- [PostgresKit](https://github.com/vapor/postgres-kit) — PostgreSQL dialect
  behavior
- [MySQLKit](https://github.com/vapor/mysql-kit) — MySQL dialect behavior
- [SQLiteKit](https://github.com/vapor/sqlite-kit) — SQLite dialect behavior

FeatherSQL separates SQL construction from database connections and query
execution, which are provided by other Feather packages. It is maintained as
part of Feather Framework and is not an official Vapor project or release.

FeatherSQL's own work is copyright Binary Birds Kft. and is distributed under
the MIT License in [LICENSE](LICENSE). The upstream projects retain their
respective copyrights; their notices and the MIT license text are recorded in
[LICENSES.md](LICENSES.md).

## Contributing

Contributions are welcome. Please keep changes focused and include tests for
new behavior.
