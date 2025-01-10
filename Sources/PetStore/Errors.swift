//
//  Errors.swift
//  OpenAPI-Foundation
//
//  Created by Michael Einreinhof on 12/23/24.
//

import OpenAPIRuntime
import Foundation
import HTTPTypes

struct PrintingMiddleware: ServerMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, ServerRequestMetadata) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        do {
            let (response, responseBody) = try await next(request, body, metadata)
            print("<<<: \(response.status.code)")
            return (response, responseBody)
        } catch {
            print("!!!: \(error.localizedDescription)")
            throw error
        }
    }
}

extension DecodingError: HTTPResponseConvertible {
    public var httpStatus: HTTPResponse.Status {
        switch self {
        
        case .typeMismatch(_, _):
                .badRequest
        case .valueNotFound(_, _):
                .badRequest
        case .keyNotFound(_, _):
                .notFound
        case .dataCorrupted(_):
                .badRequest
        @unknown default:
                .badRequest
        }
    }
}

extension UnicodeDecodingResult: HTTPResponseConvertible {
    public var httpStatus: HTTPResponse.Status {
        switch self {
            
        case .scalarValue(_):
                .ok
        case .emptyInput:
                .badRequest
        case .error:
                .unprocessableContent
        }
    }
    
    
}
