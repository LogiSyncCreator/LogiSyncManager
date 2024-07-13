//
//  EnvironViewModel.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/12.
//

import Foundation
import Combine

class EnvironViewModel: ObservableObject {
    
    @Published var model = EnvironModel()
    
    @Published var reView: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // ログインイベント
    private let loginCalled = PassthroughSubject<Void, Never>()
    
    // 送信イベント
    public let sendMatching = PassthroughSubject<Void, Never>()
    public let sendStatus = PassthroughSubject<Void, Never>()
    public let sendUser = PassthroughSubject<Void, Never>()
    
    // 受信イベント
    public let receivedMatching = PassthroughSubject<Void, Never>()
    public let receivedStatus = PassthroughSubject<Void, Never>()
    public let receivedUser = PassthroughSubject<Void, Never>()
    
    var api = APIRequest()
    
    init(){
        loginCalled.sink { [weak self] () in
            guard let self = self else {
                return
            }
            
            Task {
                try await self.setUserStatus()
                await MainActor.run {
                    self.reView.toggle()
                }
            }
            
            print("login success!")
            
        }.store(in: &cancellables)
    }
    
    func userLogin(userId: String, pass: String) async throws {
        do {
            let user = try await self.model.getUserInfo(id: userId, pass: pass)
            
            await MainActor.run {
                self.model.account.user = user
                loginCalled.send()
            }
            
        } catch {
            print("login failed")
        }
    }
    
    func setUserStatus() async throws {
        let status = try await self.model.getUserStatus()
        await MainActor.run {
            self.model.account.status = status
        }
    }
}
