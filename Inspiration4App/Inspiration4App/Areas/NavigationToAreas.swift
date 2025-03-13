//
//  NavigationToAreas.swift
//  Inspiration4App
//
//  Created by m1 on 13/03/2025.
//

import SwiftUI

struct NavigationToAreas: View {
    var body: some View {
        VStack {
            NavigationLink {
                Text("Hello WOrld")
            } label: {
                Label("Hola 1", systemImage: "chevron.right")
            }
            NavigationLink {
                Text("Hello World 2")
            } label: {
                Label("Hola 2", systemImage: "chevron.right")
            }
            NavigationLink {
                Text("Hello world 3")
            } label: {
                Label("Hola 3", systemImage: "chevron.right")
            }
        }
    }
}

#Preview {
    NavigationToAreas()
}
