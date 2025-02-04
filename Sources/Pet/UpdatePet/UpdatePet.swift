//
//  main.swift
//  swift-sam-example
//
//  Created by Michael Einreinhof on 2/3/25.
//

import Foundation
import OpenAPIRuntime
import OpenAPILambda

@main
struct UpdatePet: APIProtocol, OpenAPILambdaHttpApi {
    
    init(transport: OpenAPILambdaTransport) throws {
        try self.registerHandlers(on: transport, middlewares: [ErrorHandlingMiddleware()])
    }
    
    func updatePet(_ input: Operations.updatePet.Input) async throws -> Operations.updatePet.Output {
        var pets: [Components.Schemas.Pet] = petsExample
        let requestBody: Components.Schemas.Pet
        switch input.body {
            case .json(let json):
                requestBody = json
        }
        
        guard let id = requestBody.id, id > 0 else {
            return .badRequest(.init())
        }
        
        guard let index = pets.firstIndex(where: { $0.id == requestBody.id }) else {
            return .notFound(.init())
        }
        
        pets[index] = requestBody
        
        return .ok(.init(body: .json(pets[index])))
    }
}
