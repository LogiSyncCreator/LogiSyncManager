//
//  EnvironModel.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/12.
//

import Foundation

struct EnvironModel {
    
    var account: MyUser = MyUser()
    var matchings: [ManagedMatching] = []
    
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
    
    func insertMatchings(postData: SendMatchingInformation) async throws {
        do {
            
            try await api.setMatchings(postData: postData)
        } catch {
            print("post data is invalid.")
        }
    }
    
    func retriveMatchngGroup() async throws -> [ManagedMatching] {
        do {
            let postData: [String: Any] = ["manager": self.account.user.userId]
            
            let matchingData = try await api.getMatchingGroup(postData: postData)
            let matchings = try JSONDecoder().decode([ManagedMatching].self, from: matchingData)
            return matchings
        } catch {
            print("Not Found matching list.")
            return []
        }
    }
    
    func insertCustomStatus(icon: String, shipper: String, color: String, name: String, index: Int) async throws -> Bool {
        do {
            let postData: [String: Any] = [
                "icon": icon,
                "shipper": shipper,
                "manager": self.account.user.userId,
                "color": color,
                "delete": false,
                "name": name,
                "index": index,
            ]
            
            let _ = try await api.setCustomStatus(postData: postData)
            
            return true
            
        } catch {
            print("input status invaild")
            return false
        }
    }
    
    func deleteMatching(matchingId: String) async throws {
        do {
            try await api.deleteMatching(param: matchingId)
        } catch {
            print("APIERR: マッチングの削除に失敗")
        }
    }
    
    func deleteCustomStatus(statusId: String) async throws {
        do {
            try await api.deleteCustomStatus(param: statusId)
        } catch {
            print("APIERR: ステータスの削除に失敗")
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
    var delete: Bool = false
}

struct UserStatus: Codable {
    var index: Int = 0
    var id: String = ""
    var userId: String = ""
    var statusId: String = ""
    var name: String = ""
    var color: String = ""
    var icon: String = ""
    var delete: Bool = false
}

struct CustomStatus: Codable, Hashable {
    var id: String = ""
    var manager: String = ""
    var shipper: String = ""
    var name: String = ""
    var delete: Bool = false
    var color: String = ""
    var icon: String = ""
    var index: Int = 0
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
    var delete: Bool = false
}

struct SendMatchingInformation: Codable {
    var manager: String = ""
    var shipper: String = ""
    var driver: String = ""
    var address: String = ""
    var start: Date = Date()
    var delete: Bool = false
}

struct MatchingUser: Codable {
    var manager: UserInformation
    var shipper: UserInformation
    var driver: UserInformation
}

struct ManagedMatching:Hashable, Codable {
    
    // Hashableプロトコルに準拠するために必要な関数
    static func == (lhs: ManagedMatching, rhs: ManagedMatching) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String = ""
    var index: Int = 0
    var matching: MatchingInformation = MatchingInformation()
    var user: MatchingUser = MatchingUser(manager: UserInformation(), shipper: UserInformation(), driver: UserInformation())
    var status: [CustomStatus] = []
}
