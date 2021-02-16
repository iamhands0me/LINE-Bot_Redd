import Fluent
import Vapor

struct ArtController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let arts = routes.grouped("arts")
        arts.get(use: index)
        arts.post(use: create)
        arts.group(":artID") { art in
            art.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Art]> {
        return Art.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Art> {
        let art = try req.content.decode(Art.self)
        return art.save(on: req.db).map { art }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Art.find(req.parameters.get("artID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
