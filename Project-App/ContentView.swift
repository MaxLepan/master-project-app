//
//  ContentView.swift
//  Project-App
//
//  Created by Freestyle on 25/12/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = Connection.instance
    @State var messageString = ""
    
    @State var isPresenting = false
    @State var image:UIImage = UIImage()
        
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Button(action: {
                    // model.isScanning ? model.stopScan() : model.startScan()
                }, label: {
                    Text(model.isScanning ? "Stop" : "Scan")
                })
                Text(model.isConnected ? "Connected" : "Not connected")
                //Text("Pour une raison inconnue, il faut d'abord activer, désactiver puis réactiver le scan pour que l'affichage des périphériques fonctionne.")
                List($model.periphList){ periph in
                    PeripheralView(model: periph).onTapGesture {
                        model.connectToPeripheral(periph: periph.wrappedValue)
                    }
                }
            }
            NavigationLink("Plant Selection") {
                PlantSelectionView()
            }
        }
        .padding()
        .sheet(isPresented: self.$isPresenting) {
            Text("Testing")
        }
        .onChange(of: model.isConnected) {
            isPresenting = true
        }
    }
}

#Preview {
    ContentView()
}
