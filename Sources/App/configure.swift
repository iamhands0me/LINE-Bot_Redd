import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST"),
        username: Environment.get("DATABASE_USERNAME"),
        password: Environment.get("DATABASE_PASSWORD"),
        database: Environment.get("DATABASE_NAME"),
        tlsConfiguration: .forClient(certificateVerification: .none)
    ), as: .mysql)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateArt())

    // register routes
    try routes(app)
}
