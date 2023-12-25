//
//  PlantSelectionView.swift
//  Project-App
//
//  Created by Freestyle on 25/12/2023.
//

import SwiftUI

struct PlantSelectionView: View {
    var body: some View {
        NavigationStack {
            Text("Plant Selection")
            HStack {
                NavigationLink("Plant 1"){
                    CaterpillarLifeView(chosenBbutterfly: "1")
                }
                .padding()
                NavigationLink("Plant 2"){
                    CaterpillarLifeView(chosenBbutterfly: "2")
                }
                .padding()
                NavigationLink("Plant 3"){
                    CaterpillarLifeView(chosenBbutterfly: "3")
                }
                .padding()
            }
        }
    }
}

#Preview {
    PlantSelectionView()
}
