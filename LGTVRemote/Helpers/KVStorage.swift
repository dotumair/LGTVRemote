
import Foundation
import Foil

final class KVStorage {
    static let shared = KVStorage()
    
    private init() {}

    @FoilDefaultStorageOptional(key: "deviceName")
    var deviceName: String?
    
    @FoilDefaultStorageOptional(key: "host")
    var host: String?
    
    @FoilDefaultStorageOptional(key: "mac")
    var mac: String?

    @FoilDefaultStorageOptional(key: "clientKey")
    var clientKey: String?
}
