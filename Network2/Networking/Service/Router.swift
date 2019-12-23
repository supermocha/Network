//
//  Router.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

extension Router {
    
    public func get(with urlParameters: RequestT.URLParameters?, completion: @escaping Completion) {
           request(urlParameters: urlParameters, bodyParameters: nil, completion: completion)
    }
    
    public func post(with bodyParameters: RequestT.BodyParameters, completion: @escaping Completion) {
        request(urlParameters: nil, bodyParameters: bodyParameters, completion: completion)
    }
    
    public func request(with urlParameters: RequestT.URLParameters, bodyParameters: RequestT.BodyParameters, completion: @escaping Completion) {
        request(urlParameters: urlParameters, bodyParameters: bodyParameters, completion: completion)
    }
    
    public func cancel() {
        guard let task = task else { print(NetworkError.taskNil); return }
        task.cancel()
    }
}
 
private protocol NetworkRouter: class {
    associatedtype RequestT: RequestProtocol
    associatedtype ResponseT: ResponseProtocol
    func request(urlParameters: RequestT.URLParameters?,
                 bodyParameters: RequestT.BodyParameters?,
                 completion: @escaping (ResponseT.Response?) -> Void)
    func cancel()
}

public class Router<RequestT: RequestProtocol, ResponseT: ResponseProtocol>: NetworkRouter {
    
    public typealias Completion = (ResponseT.Response?) -> Void
        
    private var task: URLSessionTask?
    
    fileprivate func request(urlParameters: RequestT.URLParameters?,
                             bodyParameters: RequestT.BodyParameters?,
                             completion: @escaping Completion) {
        do {
            let request = try buildRequest(with: urlParameters, bodyParameters: bodyParameters)
            NetworkLogger.log(request: request)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let response = response as? HTTPURLResponse else {
                    print("Failed to convert response to HTTPURLResponse"); completion(nil)
                    return
                }
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        print(NetworkResponse.noData.rawValue); completion(nil)
                        return
                    }
                    do {
                        let result = try ResponseT.parse(jsonData: data)
                        completion(result)
                    } catch(let error) {
                        print(error.localizedDescription); completion(nil)
                    }
                case .failure(let error):
                    print(error); completion(nil)
                }
            }
            task.resume()
        } catch(let error) {
            print(error.localizedDescription); completion(nil)
        }
    }
    
    private func buildRequest(with urlParameters: RequestT.URLParameters?,
                              bodyParameters: RequestT.BodyParameters?) throws -> URLRequest {
        
        guard let url = URL(string: RequestT.baseURL) else { throw NetworkError.missingURL }
        
        var request = URLRequest(url: url.appendingPathComponent(RequestT.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = RequestT.httpMethod.rawValue
        
        configureHeaders(RequestT.httpHeaders, request: &request)
        
        let task = RequestT.task(with: urlParameters, bodyParameters: bodyParameters)
        
        do {
            switch task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestURL(let urlParameters):
                try configureParameters(parameterEncoding: .urlEncoding,
                                        urlParameters: urlParameters,
                                        bodyParameters: nil,
                                        request: &request)
                
            case .requestJSONBody(let bodyParameters):
                try configureParameters(parameterEncoding: .jsonBodyEncoding,
                                        urlParameters: nil,
                                        bodyParameters: bodyParameters,
                                        request: &request)
                
            case .requestURLJSONBody(let urlParameters, let bodyParameters):
                try configureParameters(parameterEncoding: .urlJSONBodyEncoding,
                                        urlParameters: urlParameters,
                                        bodyParameters: bodyParameters,
                                        request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(parameterEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     bodyParameters: Parameters?,
                                     request: inout URLRequest) throws {
        do {
            try parameterEncoding.encode(request: &request,
                                         urlParameters: urlParameters,
                                         bodyParameters: bodyParameters)
        } catch {
            throw error
        }
    }
    
    private func configureHeaders(_ httpHeaders: HTTPHeaders?,
                                  request: inout URLRequest) {
        guard let headers = httpHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600:       return .failure(NetworkResponse.outdated.rawValue)
        default:        return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
