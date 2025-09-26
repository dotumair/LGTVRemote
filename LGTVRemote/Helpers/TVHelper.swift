
import Foundation
import Combine
import Haptica
import WebOSClient

enum RemoteStatus {
    case connected
    case disconnected
}

class TVHelper {
    static let shared = TVHelper()
    
    private var tvCommander: WebOSClient?
    private var appName = "RemoteApp"
    
    private let registrationRequestId = "registrationSubscription"
    
    private var isConnected = false
    
    // Combine publishers
    let remoteStatusPublisher = PassthroughSubject<RemoteStatus, Never>()
    let connectionStatusPublisher = PassthroughSubject<Bool, Never>()
    
    private init() {
        connect()
    }
    
    func tryDeviceConnect(device: TVDevice) {
        KVStorage.shared.host = device.host
        KVStorage.shared.deviceName = device.name
        KVStorage.shared.mac = device.mac
        KVStorage.shared.clientKey = nil
        
        disconnect()
        connect()
    }
    
    private func connect() {
        guard let ip = KVStorage.shared.host, ip.isValidIPAddress else { return }
        print("Connecting to \(ip)")
        var url: URL? {
            #if DEBUG
            return URL(string: "ws://\(ip):3000")
            #endif
            return URL(string: "wss://\(ip):3001")
        }
        guard let url = url else { return }
        tvCommander = WebOSClient(url: url, delegate: self, shouldPerformHeartbeat: true, heartbeatTimeInterval: 20, shouldLogActivity: false)
        tvCommander?.connect()
        tvCommander?.send(.register(pairingType: .prompt, clientKey: KVStorage.shared.clientKey), id: registrationRequestId)
    }
    
    func tryHostConnect(host: String) {
        KVStorage.shared.host = host
        KVStorage.shared.clientKey = nil
        disconnect()
        connect()
    }
    
    func sendCommand(_ command: WebOSKeyTarget) {
        guard let tvCommander = tvCommander,
              isConnected
        else {
            remoteStatusPublisher.send(.disconnected)
            return
        }
        tvCommander.sendKey(command)
        if UserDefaults.standard.vibrationEnabled {
            Haptic.impact(.light).generate()
        }
    }
    
    func sendText(_ text: String) {
        guard let tvCommander = tvCommander,
              isConnected
        else {
            remoteStatusPublisher.send(.disconnected)
            return
        }
        tvCommander.send(.insertText(text: text, replace: false))
        if UserDefaults.standard.vibrationEnabled {
            Haptic.impact(.light).generate()
        }
    }

    func launchApp(app: String) {
        guard let tvCommander = tvCommander,
              isConnected
        else {
            remoteStatusPublisher.send(.disconnected)
            return
        }
        tvCommander.send(.launchApp(appId: app))
    }
    
    func isAnyDeviceConnected() -> Bool {
        guard tvCommander != nil else { return false }
        return isConnected
    }
    
//    func getConnectedDeviceAddress() -> String? {
//        guard let tvCommander = tvCommander, tvCommander.isConnected else { return nil }
//        return tvCommander.tvConfig.ipAddress
//    }
    
    func disconnect() {
        tvCommander?.disconnect()
        isConnected = false
    }
}

extension TVHelper: WebOSClientDelegate {
    func didRegister(with clientKey: String) {
        KVStorage.shared.clientKey = clientKey
        isConnected = true
        connectionStatusPublisher.send(true)
    }
    
    func didReceiveNetworkError(_ error: (any Error)?) {
        if let error = error as NSError? {
            if error.code == 57 || error.code == 60 || error.code == 54 {
                disconnect()
            }
        }
    }
}

//extension TVHelper: TVCommanderDelegate {
//    func tvCommanderDidConnect(_ tvCommander: TVCommander) {
//        print("Connected")
//        connectionStatusPublisher.send(tvCommander.isConnected)
//        UserDefaults.standard.lastSavedIPAddress = tvCommander.tvConfig.ipAddress
//    }
//    
//    func tvCommanderDidDisconnect(_ tvCommander: TVCommander) {
//        print("Disconnected")
//        connectionStatusPublisher.send(tvCommander.isConnected)
//    }
//    
//    func tvCommander(_ tvCommander: TVCommander, didUpdateAuthState authStatus: TVAuthStatus) {
//        authStatusPublisher.send(authStatus)
//        switch authStatus {
//        case .none:
//            break
//        case .allowed:
//            UserDefaults.standard.lastSavedAuthToken = tvCommander.tvConfig.token
//            remoteStatusPublisher.send(.authorized)
//        case .denied:
//            remoteStatusPublisher.send(.unauthorized)
//            break
//        }
//    }
//    
//    func tvCommander(_ tvCommander: TVCommander, didWriteRemoteCommand command: TVRemoteCommand) {
//        print(command)
//    }
//    
//    func tvCommander(_ tvCommander: TVCommander, didEncounterError error: TVCommanderError) {
//        print(error.localizedDescription)
//    }
//}
