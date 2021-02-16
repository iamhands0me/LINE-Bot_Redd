import Fluent
import Vapor

final class Art: Model, Content {
    static let schema = "arts"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "imgUrl")
    var imgUrl: String

    init() { }

    init(id: UUID? = nil, title: String, name: String, imgUrl: String) {
        self.id = id
        self.title = title
        self.name = name
        self.imgUrl = imgUrl
    }
}
