//
//  HapticsManager.swift
//  DDG
//
//  Created by Aasem Hany on 26/09/2023.
//

import UIKit


enum HapticsManager {
    static func playSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
