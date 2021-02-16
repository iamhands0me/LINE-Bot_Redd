import Fluent

struct CreateArt: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("arts")
            .id()
            .field("title", .string, .required)
            .field("name", .string, .required)
            .field("imgUrl", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("arts").delete()
    }
}
