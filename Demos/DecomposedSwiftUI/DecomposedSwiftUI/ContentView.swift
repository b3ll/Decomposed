//
//  ContentView.swift
//  DecomposedSwiftUI
//
//  Created by Adam Bell on 5/27/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

import Decomposed
import simd
import SwiftUI

fileprivate func transformAt(_ percent: CGFloat) -> CATransform3D {
  let startingTransform =
    CATransform3DIdentity
      .translatedBy(x: -100.0, y: -200.0)
      .rotated(by: Quaternion(angle: .pi * 2.0, axis: Vector3(1.0, 0.0, 0.0)))
      .rotated(by: Quaternion(angle: .pi * 2.0, axis: Vector3(0.0, 1.0, 0.0)))
      .applyingPerspective(m34: 1.0 / 500.0)

  let finalTransform =
    CATransform3DIdentity
      .translatedBy(x: 100.0, y: 300.0)
      .rotated(by: Quaternion(angle: .pi / 2.0, axis: Vector3(1.0, 0.0, 0.0)))
      .rotated(by: Quaternion(angle: .pi / 2.0, axis: Vector3(0.0, 1.0, 0.0)))
      .applyingPerspective(m34: 1.0 / 500.0)

  return startingTransform.lerp(to: finalTransform, fraction: percent)
}

struct ContentView: View {

  @State var slidingPercent: CGFloat = 0.0

  var body: some View {
    VStack {
      Spacer()

      Rectangle()
        .foregroundColor(Color(red: 0.31, green:0.80, blue:0.98, opacity:1.0))
        .frame(width: 60.0, height: 60.0)
        .projectionEffect(ProjectionTransform(transformAt($slidingPercent.wrappedValue)))
        .shadow(radius: 2.0)

      Spacer()

      Slider(value: $slidingPercent)
        .accentColor(.black)
        .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewDevice("iPhone 11 Pro")
  }
}
