//
//  LocationManager.swift
//  DDG
//
//  Created by Aasem Hany on 16/07/2023.
//

import Foundation

final class LocationManager: ObservableObject{
    @Published var locations = [DDGLocation]()
}
