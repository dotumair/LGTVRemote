
import Foundation

struct TVDevice: Hashable, Identifiable {
    static func == (lhs: TVDevice, rhs: TVDevice) -> Bool {
        lhs.host == rhs.host
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(host)
    }
    
    let id: String
    let name: String
    let host: String
    let mac: String
}
