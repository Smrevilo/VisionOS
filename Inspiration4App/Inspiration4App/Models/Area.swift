//
//  Area.swift
//  Inspiration4App
//
//  Created by m1 on 13/03/2025.
//
import Foundation

enum Area: String, Identifiable, CaseIterable, Equatable
{
    case astronauts, equiment, mission
    var id: Self { self }
    var name: String { rawValue.lowercased() }
    
    var title: String {
        switch self {
        case .astronauts:
            "Inspiration 4 mission crew members..."
        case .equiment:
            "Inspiration 4 mission equiment..."
        case .mission:
            "Inspiration 4 mission trailer..."
        }
    }
    
}
