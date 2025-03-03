//
//  DoodleView.swift
//  WallArt
//
//  Created by m1 on 02/03/2025.
//

import SwiftUI
import UIKit

struct DoodleView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        VStack {
            DrawingView()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
                .padding()
            
            Button("Done") {
                dismissWindow(id: "doodle_canvas")
                appModel.flowState = .projectileFlying
            }
            
            Spacer()
            
        }
    }
}

struct DrawingView: UIViewRepresentable {
    func makeUIView(context: Context) -> DrawingUIView {
        let view = DrawingUIView()
        return view
    }
    
    func updateUIView(_ uiView: DrawingUIView, context: Context) {
        
    }
}

class DrawingUIView: UIView {
    private var path = UIBezierPath()
    private var strokeWidth: CGFloat = 5.0
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        path.lineWidth = strokeWidth
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        path.move(to: touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        path.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
}
