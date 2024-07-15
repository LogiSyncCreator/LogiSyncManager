//
//  APIRequest.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/12.
//

import Foundation

final class APIRequest {
    let host: String = "192.168.68.82"
    let port: String = "8080"
    let httpd: String = "http"
    
    
    func userLogin(id: String, pass: String) async throws -> Data {
        let postData: [String: Any] = ["username":id, "password":pass]
        return try await APIRequest(postData: postData, endPoint: "accounts/login")
    }
    
    
    func getStatus(id: String) async throws -> Data {
        return try await APIRequest(param: id, endPoint: "/status/nowstatus")
    }
    
    func setMatchings(postData: SendMatchingInformation) async throws {
        return try await APIRequest(postData: postData, endPoint: "matching")
    }
    
    func getMatchingGroup(postData: [String: Any]) async throws -> Data {
        return try await APIRequest(postData: postData, endPoint: "matching/managedgroup")
    }
    
    func deleteMatching(param: String) async throws {
        return try await APIRequest(param: param, endPoint: "matching/cancel")
    }
    
    func setCustomStatus(postData: [String: Any]) async throws -> Data {
        return try await APIRequest(postData: postData, endPoint: "status")
    }
    
    func deleteCustomStatus(param: String) async throws {
        return try await APIRequest(param: param, endPoint: "status", method: "DELETE")
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: GET or DELETE
    func APIRequest(param: String, endPoint: String, method: String = "GET") async throws {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)/\(param)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // URLSessionを使用してリクエストを送信
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: POST or DELETE
    func APIRequest<T: Encodable>(postData: T, endPoint: String, method: String = "POST") async throws {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSONEncoderを使用してデータをエンコード
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(postData)
        
        // URLSessionを使用してリクエストを送信
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: GET or DELETE
    func APIRequest(param: String, endPoint: String, method: String = "GET") async throws -> Data {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)/\(param)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // URLSessionを使用してリクエストを送信
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: POST or DELETE
    func APIRequest(postData: [String: Any], endPoint: String, method: String = "POST") async throws -> Data {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POSTデータを設定
        request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        
        // URLSessionを使用してリクエストを送信
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
