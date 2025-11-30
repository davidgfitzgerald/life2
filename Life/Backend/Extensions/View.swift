//
//  View.swift
//  Life
//
//  Created by David Fitzgerald on 30/11/2025.
//

import SwiftUI


extension View {
    func onSwipe(
        left: (() -> Void)? = nil,
        right: (() -> Void)? = nil,
        minimumDistance: CGFloat = 50
    ) -> some View {
        self.gesture(
            DragGesture(minimumDistance: minimumDistance)
                .onEnded { value in
                    let horizontalDistance = value.translation.width
                    let verticalDistance = value.translation.height
                    
                    if abs(horizontalDistance) > abs(verticalDistance) {
                        if horizontalDistance > 0 {
                            right?()
                        } else {
                            left?()
                        }
                    }
                }
        )
    }
}
