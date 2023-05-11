//
//  Color.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import SwiftUI

extension Color {
    func toHex() -> String? {
        guard let components = self.cgColor?.components else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        let hex = String(format: "%02X%02X%02X", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        return hex
    }
}
