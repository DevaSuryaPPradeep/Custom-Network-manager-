//
//  WebServices.swift
//  DemoOnCustomPackageImplementations
//
//  Created by Devasurya on 28/05/24.
//

import Foundation

public class WebServices {
    
    public init() {}
     
    public func APICaller <T:Codable>(from URLValue: String, completion :@escaping(Result<T,NetworkErrors>)->Void) {
        guard let URLString = URL(string: URLValue) else {return}
        URLSession.shared.dataTask(with: URLString) { data, response, error in
            guard error == nil else {
                print("error found--->\(String(describing: error?.localizedDescription))")
                completion(.failure(.inValidError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(error?.localizedDescription as Any)
                return  completion(.failure(NetworkErrors.badResponse))
                
            }
            if let returnedData = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: returnedData)
                    completion(.success(decodedData))
                }
                catch {
                    print("error while decoding--->\(String(describing: error.localizedDescription))")
                    completion (.failure(NetworkErrors.failedtoDecodeResponse))
                }
            }
        }.resume()
    }
}

public enum NetworkErrors: Error {
    case  badURL
    case badResponse
    case failedtoDecodeResponse
    case inValidError
}
