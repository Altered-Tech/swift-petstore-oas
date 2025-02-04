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
struct GetPetsByTags: APIProtocol, OpenAPILambdaHttpApi {
    
    init(transport: OpenAPILambdaTransport) throws {
        try self.registerHandlers(on: transport, middlewares: [ErrorHandlingMiddleware()])
    }
    
    func findPetsByTags(_ input: Operations.findPetsByTags.Input) async throws -> Operations.findPetsByTags.Output {
        guard let inputTags = input.query.tags else { return .badRequest(.init()) }
        //Forcing unwrap
        let matchingTags = tagsExample.filter { inputTags.contains( $0.name! ) }
        let petsWithTags: [Components.Schemas.Pet] = petsExample.filter { pet in
            // Forcing unwrap
            pet.tags!.contains { petTag in
                matchingTags.contains { $0.id == petTag.id! }
            }
        }
        return .ok(.init(body: .json(petsWithTags)))
    }
}
