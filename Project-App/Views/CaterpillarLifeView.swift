//
//  CaterpillarLifeView.swift
//  Project-App
//
//  Created by Freestyle on 25/12/2023.
//

import SwiftUI

struct CaterpillarLifeView: View {
    
    var chosenBbutterfly = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Caterpillar life")
                Text("Chosen butterfly : \(chosenBbutterfly)")
                Spacer()
                HStack {
                    Spacer()
                    Button("Launch drone flight sequence") {
                        print("Drone flight sequence launched")
                    }
                    Spacer()
                    Button("Activate Pschiit") {
                        print("Pschitt activated")
                    }
                    Spacer()
                }
                Spacer()
                NavigationLink("Caterpillar in chrysalid"){
                    ChrysalidView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    CaterpillarLifeView(chosenBbutterfly: "1")
}
