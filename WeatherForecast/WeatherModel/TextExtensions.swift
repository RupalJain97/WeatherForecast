//
//  TextExtensions.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/27/24.
//

import SwiftUI

extension Text {
    func titleStyle() -> some View {
        self.font(.largeTitle)
            .bold()
            .foregroundColor(.white)
    }

    func subtitleStyle() -> some View {
        self.font(.subheadline)
            .foregroundColor(.gray)
    }
}
