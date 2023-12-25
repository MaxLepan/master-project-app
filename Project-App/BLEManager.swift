//
//  BLEClient.swift
//  SwiftUI_BLE
//
//  Created by Al on 03/11/2023.
//

import Foundation

import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let instance = BLEManager()
    
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    let serviceUUID = CBUUID(string: "ee25b7b6-7798-4749-8b12-734cfbc5caa9")
    var characteristicUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    var writableCharacteristic: CBCharacteristic?
    
    var scanCallback: ((CBPeripheral,String) -> ())?
    var connectCallback: ((CBPeripheral) -> ())?
    var disconnectCallback: ((CBPeripheral) -> ())?
    var didFinishDiscoveryCallback: ((CBPeripheral) -> ())?
    var messageReceivedCallback:((Data?)->())?
    var isScanning = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("BLE ON")
        default:
            print("Bluetooth is not available.")
        }
    }
    
    func scan(callback: @escaping (CBPeripheral,String) -> ()) {
        isScanning = true
        scanCallback = callback
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    func stopScan() {
        isScanning = false
        centralManager?.stopScan()
    }
    
    func sendData(data: Data?) {
        guard let peripheral = discoveredPeripheral, let characteristic = writableCharacteristic else {
            print("Peripheral or writableCharacteristic not found.")
            return
        }
        
        guard let dataToSend = data else {
            print("Data is nil.")
            return
        }
        
        // Determine how to write based on the characteristic's properties
        let type: CBCharacteristicWriteType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
        
        peripheral.writeValue(dataToSend, for: characteristic, type: type)

    }
    
    func listenForMessages(callback:@escaping(Data?)->()) {
        messageReceivedCallback = callback
    }
    
    func disconnectPeripheral(_ periph: CBPeripheral, callback: @escaping (CBPeripheral) -> ()) {
        disconnectCallback = callback
        centralManager?.cancelPeripheralConnection(periph)
    }
    
    func connectPeripheral(_ periph: CBPeripheral, callback: @escaping (CBPeripheral) -> ()) {
        connectCallback = callback
        discoveredPeripheral = periph
        centralManager?.connect(periph, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(String(describing: peripheral.name))")
        
        discoveredPeripheral = peripheral
        scanCallback?(peripheral,advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "unknown")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "")")
        
        peripheral.delegate = self
        
        // Discover services for the connected peripheral
        peripheral.discoverServices([serviceUUID])
        connectCallback?(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services where service.uuid == serviceUUID {
            // Discover the characteristics for our service
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics where characteristic.uuid == characteristicUUID {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writableCharacteristic = characteristic
            }

            
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == characteristicUUID, let value = characteristic.value {
            let stringValue = String(data: value, encoding: .utf8)
            messageReceivedCallback?(value)
            print("Received value: \(stringValue ?? "")")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == characteristicUUID, let value = characteristic.value {
            let stringValue = String(data: value, encoding: .utf8)
            messageReceivedCallback?(value)
            print("Received value: \(stringValue ?? "")")
        }
    }
    
    
    
    func cleanup() {
        guard let discoveredPeripheral = discoveredPeripheral else { return }
        
        if discoveredPeripheral.state != .connected {
            return
        }
        
        if let services = discoveredPeripheral.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == characteristicUUID && characteristic.isNotifying {
                            discoveredPeripheral.setNotifyValue(false, for: characteristic)
                            return
                        }
                    }
                }
            }
        }
        
        centralManager.cancelPeripheralConnection(discoveredPeripheral)
    }
}
