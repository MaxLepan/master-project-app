//
//  Peripheral.swift
//  SwiftUI_BLE
//
//  Created by Freestyle on 08/11/2023.
//

import Foundation
import CoreBluetooth

struct Peripheral : ModelProtocol {
    var id = UUID().uuidString
    var name:String
    var cbPeriph:CBPeripheral?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if let leftPeriph = lhs.cbPeriph,
           let rightPeriph = rhs.cbPeriph {
            return leftPeriph.identifier == rightPeriph.identifier
        } else {
            return false
        }
    }
}

extension Peripheral {
    
    static func defaultPeripheral() -> Peripheral {
        return Peripheral(name: "default")
    }
    
}
