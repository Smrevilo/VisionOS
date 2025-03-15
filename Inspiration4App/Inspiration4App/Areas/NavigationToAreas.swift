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
            Text("Welcome to the Inspiration 4 Mission by SpaceX")
                .monospaced()
                .font(.system(size: 40, weight: .bold))
                .padding(.top, 250)
            
            HStack(spacing: 25) {
                ForEach(Area.allCases) { area in
                    NavigationLink {
                        Text(area.title)
                            .monospaced()
                            .font(.system(size: 40, weight: .bold))
                        if area == .astronauts {
                            CrewArea()
                        } else if area == .equiment {
                            EquipmentArea()
                        } else if area == .mission {
                            
                        }
                
                        Spacer()
                        
                    } label: {
                        Label(area.name, systemImage: "chevron.right")
                            .monospaced()
                            .font(.title)
                    }
                    .controlSize(.extraLarge)
                }
            }
            
        }
        .background {
            Image("Inspiration4")
        }
    }
}

#Preview {
    NavigationToAreas()
        .environment(ViewModel())
}
