//
//  PeripheralView.swift
//  SwiftUI_BLE
//
//  Created by Freestyle on 08/11/2023.
//

import SwiftUI

struct PeripheralView: View {
    
    @Binding var model:Peripheral
    
    var body: some View {
        Text(model.name)
    }
}

struct PeripheralView_Previews: PreviewProvider {
    @State static var defaultModel = Peripheral.defaultPeripheral()
    static var previews: some View {
        PeripheralView(model: $defaultModel)
    }
}
