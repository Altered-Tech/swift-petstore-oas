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
struct AddPet: APIProtocol, OpenAPILambdaHttpApi {

    init(transport: OpenAPILambdaTransport) throws {
        try self.registerHandlers(on: transport, middlewares: [ErrorHandlingMiddleware()])
    }

    func addPet(_ input: Operations.addPet.Input) async throws -> Operations.addPet.Output {
        var requestBody: Components.Schemas.Pet
        switch input.body {
            case .json(let json): requestBody = json
        }
        var pets: [Components.Schemas.Pet] = petsExample

        let newId: Int64 = Int64(pets.count)
        requestBody.id = newId

        pets.append(requestBody)

        return .ok(.init(body: .json(requestBody)))
    }
}
