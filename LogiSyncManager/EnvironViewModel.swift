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
    @Published var matchingsAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // ログインイベント
    private let loginCalled = PassthroughSubject<Void, Never>()
    
    // セットイベント
    public let setCustomStatus = PassthroughSubject<(icon: String, shipper: String, color: String, name: String, index: Int), Never>()
    
    // 送信イベント
    public let sendMatching = PassthroughSubject<SendMatchingInformation, Never>()
    public let sendStatus = PassthroughSubject<Void, Never>()
    public let sendUser = PassthroughSubject<Void, Never>()
    
    // 受信イベント
    public let receivedMatching = PassthroughSubject<Void, Never>()
    public let receivedStatus = PassthroughSubject<Void, Never>()
    public let receivedUser = PassthroughSubject<Void, Never>()
    
    // ロードフラグ
    @Published var isInsertMatchings: Bool = false
    
    var api = APIRequest()
    
    init(){
        setCustomStatus.sink { [weak self] (icon: String, shipper: String, color: String, name: String, index: Int) in
            guard let self = self else {
                return
            }
            
            Task {
                await MainActor.run {
                    for index in self.model.matchings.indices {
                        if self.model.matchings[index].matching.shipper == shipper {
                            self.model.matchings[index].status.append(CustomStatus(id: UUID().uuidString, name: name, delete: false, color: color, icon: icon, index: self.model.matchings[index].status.count + 1))
                        }
                    }
                    self.reView.toggle()
                }
            }
        }.store(in: &cancellables)
        
        loginCalled.sink { [weak self] () in
            guard let self = self else {
                return
            }
            
            Task {
                try await self.setUserStatus()
                await MainActor.run {
                    self.reView.toggle()
                    self.receivedMatching.send()
                }
            }
            
            print("login success!")
            
        }.store(in: &cancellables)
        
        sendMatching.sink { [weak self] sendMatchingInformation in
            guard let self = self else {
                return
            }
            
            self.isInsertMatchings = true
            
            Task {
                try await self.model.insertMatchings(postData: sendMatchingInformation)
                
                await MainActor.run {
                    self.isInsertMatchings = false
                    self.matchingsAlert = true
                    self.reView.toggle()
                    self.receivedMatching.send()
                }
                
            }
        }.store(in: &cancellables)
        
        receivedMatching.sink { [weak self] () in
            guard let self = self else {
                return
            }
            
            Task {
                try await self.setMatchings()
                
                await MainActor.run {
                    self.reView.toggle()
                }
            }
            
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
    
    func setMatchings() async throws {
        let matchings = try await self.model.retriveMatchngGroup()
        await MainActor.run {
            self.model.matchings = matchings
        }
    }
    
    func setCustomStatus(icon: String, shipper: String, color: String, name: String, index: Int) async throws {
        let responseCustomStatus = try await self.model.insertCustomStatus(icon: icon, shipper: shipper, color: color, name: name, index: index)
        if responseCustomStatus {
//            self.receivedMatching.send()
            // フラグでプログレスバーの処理
            setCustomStatus.send((icon: icon, shipper: shipper, color: color, name: name, index: index))
        }
    }
    
    func deleteMatching(uuid: String) async throws {
        try await self.model.deleteMatching(matchingId: uuid)
        await MainActor.run {
            self.receivedMatching.send()
        }
    }
    
    func deleteStatus(uuid: String) async throws {
        try await self.model.deleteCustomStatus(statusId: uuid)
    }
}
