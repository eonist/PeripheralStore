#if DEBUG
import Foundation
import CoreBluetooth
/**
 * We use this for testing restoration in restoration example projects
 * - Fixme: ⚠️️ move to ios test target only? or is it also used in macos?
 * - Fixme: ⚠️️ move to unit / UITest soon?
 * ## Examples:
 * PeripheralStore.add(UUID(uuidString: "012345.0000.0000"))
 * PeripheralStore.ids // ["012345.0000.0000"]
 */
internal final class PeripheralStore {
   /**
    * The `user-default` key where we store the disocvered peripheral identifier uuid's
    */
   fileprivate static let userDefaultKey: String = {
      "discoveredPeripherals" // Define a user default key for the discovered peripherals
   }()
}
/**
 * Ext
 */
extension PeripheralStore {
   /**
    * Get ids
    */
   internal static var ids: [UUID] {
      let peripherals: [Any] = UserDefaults.standard.array(forKey: userDefaultKey) ?? [] // Get the array of peripherals from UserDefaults or initialize an empty array
      return peripherals.compactMap {
         guard let id: String = $0 as? String else { return nil } // Get the UUID string from the array element, or return nil if it is not a string
         return UUID(uuidString: id) // Convert the UUID string to a UUID object and return it
      }
   }
   /**
    * Assert if UUID exists in the list of peripheral UUIDs
    * - Parameter uuid: The UUID to check for
    */
   internal static func has(_ uuid: String) -> Bool {
      guard let uuid: UUID = .init(uuidString: uuid) else {
         // If unable to create a UUID from the string, print an error message and return false
         Swift.print("Err, creating uuid")
         return false
      }
      return ids.contains(uuid) // Return true if the UUID is in the array of IDs, false otherwise
   }
   /**
    * Set id's
    * - Remark: Since iOS12, it isn't mandatory to call .syncronize. Apple says: https://developer.apple.com/documentation/foundation/userdefaults/1414005-synchronize
    * - Fixme: ⚠️️ Test if this includes existing ids, or overwrite them etc?
    * - Parameter ids: The array of peripheral UUIDs to set
    */
   internal static func set(_ ids: [UUID]) {
      let uuids = ids.map { $0.uuidString }
      UserDefaults.standard.set(uuids, forKey: userDefaultKey) // Convert the UUIDs to strings and save them to UserDefaults
   }
   /**
    * Add a peripheral UUID to the list of discovered peripherals
    * - Remark: Call this whenever a peripheral is discovered
    * - Parameter id: The UUID of the peripheral to add
    */
   internal static func add(_ id: UUID) {
      let peripherals: [UUID] = Self.ids // Get the array of peripheral UUIDs
      if !peripherals.contains(id) { // If the array does not contain the given UUID, add it to the array
         set(peripherals + [id]) // Save the updated array of peripheral UUIDs to UserDefaults
      }
   }
}
#endif
// store approved peers in userdefault:
// class func getScannedServices() -> [String : CBUUID] {
//   if let storedServices = UserDefaults.standard.dictionary(forKey: "services") {
//      var services = [String: CBUUID]()
//      for (name, uuid) in storedServices {
//         if let uuid = uuid as? String {
//            services[name] = CBUUID(string: uuid)
//         }
//      }
//      return services
//   } else {
//      return [:]
//   }
// }
//
//class func getScannedServiceNames() -> [String] {
//   return Array(self.getScannedServices().keys)
//}
//class func getScannedServiceUUIDs() -> [CBUUID] {
//   return Array(self.getScannedServices().values)
//}
//class func getScannedServiceUUID(_ name: String) -> CBUUID? {
//   let services = self.getScannedServices()
//   if let uuid = services[name] {
//      return uuid
//   } else {
//      return nil
//   }
//}
//class func setScannedServices(_ services:[String: CBUUID]) {
//   var storedServices = [String:String]()
//   for (name, uuid) in services {
//      storedServices[name] = uuid.uuidString
//   }
//   UserDefaults.standard.set(storedServices, forKey:"services")
//}
//class func addScannedService(_ name :String, uuid: CBUUID) {
//   var services = self.getScannedServices()
//   services[name] = uuid
//   self.setScannedServices(services)
//}
//class func removeScannedService(_ name: String) {
//   var beacons = self.getScannedServices()
//   beacons.removeValue(forKey: name)
//   self.setScannedServices(beacons)
//   }
