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
struct GetPetsByStatus: APIProtocol, OpenAPILambdaHttpApi {

    init(transport: OpenAPILambdaTransport) throws {
        try self.registerHandlers(on: transport, middlewares: [ErrorHandlingMiddleware()])
    }

    func findPetsByStatus(_ input: Operations.findPetsByStatus.Input) async throws -> Operations.findPetsByStatus.Output {
        switch input.query.status {
        case .available:
            let petsMatching: [Components.Schemas.Pet] = petsExample.filter { $0.status == .available }
            return .ok(.init(body: .json(petsMatching)))
        case .pending:
            let petsMatching: [Components.Schemas.Pet] = petsExample.filter { $0.status == .pending}
            return .ok(.init(body: .json(petsMatching)))
        case .sold:
            let petsMatching: [Components.Schemas.Pet] = petsExample.filter { $0.status == .sold}
            return .ok(.init(body: .json(petsMatching)))
        }
    }
}
