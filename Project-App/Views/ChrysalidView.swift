//
//  ChrysalidView.swift
//  Project-App
//
//  Created by Freestyle on 25/12/2023.
//

import SwiftUI

struct ChrysalidView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Chrysalid")
                Spacer()
                HStack {
                    Button("Activate Winter"){
                        print("Winter activated")
                    }
                }
                Spacer()
                NavigationLink("Butterfly is out"){
                    
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ChrysalidView()
}
