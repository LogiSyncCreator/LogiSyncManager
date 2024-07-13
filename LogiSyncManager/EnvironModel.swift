//
//  EnvironModel.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/12.
//

import Foundation

struct EnvironModel {
    
    var account: MyUser = MyUser()
    var matchings: [MyMatching] = []
    
    let api = APIRequest()
    
    /// ログインしてステータスをセットする
    /// - ログイン処理:
    ///   - id: user id
    ///   - pass: user password
    func getUserInfo(id: String, pass: String) async throws -> UserInformation {
        do {
            let user = try await api.userLogin(id: id, pass: pass)
            let userInfo = try JSONDecoder().decode(UserInformation.self, from: user)
            return userInfo
        } catch {
            print("Invalid user id or password.")
            return UserInformation()
        }
    }
    
    /// ステータスを取得する
    func getUserStatus() async throws -> UserStatus {
        do {
            let status = try await api.getStatus(id: account.user.userId)
            let userStatus = try JSONDecoder().decode(UserStatus.self, from: status)
            return userStatus
        } catch {
            print("Invalid user id.")
            return UserStatus()
        }
    }
}

struct MyUser {
    var user: UserInformation = UserInformation()
    var status: UserStatus = UserStatus()
}

struct UserInformation: Codable {
    var id: String = ""
    var userId: String = ""
    var profile: String = ""
    var name: String = ""
    var company: String = ""
    var role: String = ""
    var phone: String = ""
}

struct UserStatus: Codable {
    var id: String = ""
    var userId: String = ""
    var statusId: String = ""
    var name: String = ""
    var color: String = ""
    var icon: String = ""
    var delete: Bool = false
}

struct MyMatching: Codable {
    var index: Int = 0
    var matching: MatchingInformation = MatchingInformation()
    var user: MatchingUser = MatchingUser(manager: UserInformation(), shipper: UserInformation(), driver: UserInformation())
}

struct MatchingInformation: Codable {
    var id: String = ""
    var manager: String = ""
    var shipper: String = ""
    var driver: String = ""
    var address: String = ""
    var start: String = ""
}

struct MatchingUser: Codable {
    var manager: UserInformation
    var shipper: UserInformation
    var driver: UserInformation
}
