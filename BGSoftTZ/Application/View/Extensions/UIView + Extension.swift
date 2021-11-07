//
//  UIView + Extension.swift
//  BGSoftTZ
//
//  Created by pro2017 on 07/11/2021.
//

import Foundation
import UIKit

extension UIView {

    func removeAllShadows() {
        if let sublayers = self.layer.sublayers, !sublayers.isEmpty {
            for sublayer in sublayers {
                if (sublayer is CAGradientLayer) {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
}
