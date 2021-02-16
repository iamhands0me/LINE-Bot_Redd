import Fluent
import Vapor
import LineBotPackage

struct Hello: Content {
    var name: String?
}

func routes(_ app: Application) throws {
    let webhookParser = WebhookParser(channelSecret: "...")
    let lineBotApi = LineBotApi(channelAccessToken: "...")
            
    app.post("callback") { req -> HTTPResponseStatus in
        if let requestBody = req.body.string,
           let signature = req.headers["X-Line-Signature"].first,
           let events = webhookParser.parse(body: requestBody, signature: signature) {
            for event in events {
                switch event {
                case .message(let messageEvent):
                    if let text = messageEvent.message.text {
                        Art.query(on: req.db).filter(\.$title == text).first().whenComplete { result in
                            switch result {
                            case .success(let art):
                                if let art = art {
                                    let textSendMessage = TextSendMessage(text: art.name)
                                    let imageSendMessage = ImageSendMessage(originalContentUrl: art.imgUrl, previewImageUrl: art.imgUrl)
                                    _ = req.client.send(lineBotApi.replyMessage(replyToken: messageEvent.replyToken, messages: [textSendMessage, imageSendMessage]))
                                } else {
                                    let textSendMessage = TextSendMessage(text: "找不到")
                                    _ = req.client.send(lineBotApi.replyMessage(replyToken: messageEvent.replyToken, message: textSendMessage))
                                }
                            case .failure( _):
                                let textSendMessage = TextSendMessage(text: "找不到")
                                _ = req.client.send(lineBotApi.replyMessage(replyToken: messageEvent.replyToken, message: textSendMessage))
                            }
                            
                        }
                    }
                case .follow(_): break
                    
                }
            }
        }
   
        return HTTPStatus.ok
    }
    
    try app.register(collection: TodoController())
    //try app.register(collection: ArtController())
}
