//
//  Connection.swift
//  SwiftUI_BLE
//
//  Created by Freestyle on 08/11/2023.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreLocation

class Connection:ObservableObject {
    
    @Published var periphList = [Peripheral]()
    @Published var isScanning = false
    @Published var isConnected = false
//    @Published var acceleroReceived = [Axis]()
//    @Published var citiesReceived = [Location]()
    
    var countIndex = 0
    var cityNames = [String]()
    var connectedPeriph: Peripheral?
    
    static var instance = Connection()
    
    func addPeripheral(periph: Peripheral) {
        if !self.periphList.contains(periph) {
            self.periphList.append(periph)
        }
    }
    
    func startScan() {
        isScanning = true
        BLEManager.instance.scan { periph, name in
            self.addPeripheral(periph: Peripheral(name: name, cbPeriph: periph))
        }
    }
    
    func stopScan() {
        BLEManager.instance.stopScan()
        isScanning = false
    }
    
    func connectToPeripheral(periph: Peripheral){
        if let cbPeriph = periph.cbPeriph {
            BLEManager.instance.connectPeripheral(cbPeriph) { connectedCbPeriph in
                self.connectedPeriph = periph
                self.stopScan()
                self.isConnected = true
            }
        }
    }
    
    func disconnetFromPeripheral(periph: Peripheral) {
        if let cbPeriph = periph.cbPeriph {
            BLEManager.instance.disconnectPeripheral(cbPeriph) { _ in }
        }
    }
    
    func sendData(str:String) {
        if let stringData = str.data(using: .utf8) {
            // let dataToSend = DataByteManager.instance.appendPrefix(userId: 0x05, dataType: DataType.Text.rawValue, to: stringData)
            BLEManager.instance.sendData(data: stringData)
        }
    }
    
    func sendData(img:UIImage){
        if let data = img.pngData() {
//            let dataToSend = DataByteManager.instance.appendPrefix(userId: 0x05, dataType: DataType.Image.rawValue, to: data)
//            BLEManager.instance.sendData(data: dataToSend)
        }
        
    }
    
    func changeBLEManagerCharacteristicUUID(with characteristicUUIDString:String) {
        BLEManager.instance.characteristicUUID = CBUUID(string: characteristicUUIDString)
    }
    
//    func listenForAcceleroMessages(limit: Int = 100) {
//        BLEManager.instance.listenForMessages { data in
//            if let d = data {
//                if let infos = String(data: d, encoding: .utf8) {
//                    if self.acceleroReceived.count < limit * 3 {
//                        if let double = Double(infos) {
//                            let axisArray = ["x", "y", "z"]
//                            let newAxis = Axis(axis: axisArray[self.countIndex % 3], value: double, index: self.countIndex / 3)
//                            self.acceleroReceived.append(newAxis)
//                            self.countIndex += 1
//                        }
//                    } else {
//                        // print(self.acceleroReceived)
//                        self.sendData(str: "stopAccelero")
//                    }
//                }
//            }
//        }
//    }
    
}
