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
            return .badRequest(.init(body: .json(.init(
                message: "Bad Request: Pet ID must be provided or greater than 0.",
                code: 400))))
        }
        
        guard let index = pets.firstIndex(where: { $0.id == requestBody.id }) else {
            return .notFound(.init(body: .json(.init(
                message: "Not Found: No pet found with ID \(String(describing: requestBody.id))",
                code: 404))))
        }
        
        pets[index] = requestBody
        
        return .ok(.init(body: .json(pets[index])))
    }
}
