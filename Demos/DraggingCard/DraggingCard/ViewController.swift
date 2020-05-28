//
//  ViewController.swift
//  DraggingCard
//
//  Created by Adam Bell on 5/27/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

import Advance
import Decomposed
import UIKit

class ViewController: UIViewController {

  var cardView: UIView!
  var squircle: CALayer!

  var translationSpring: Spring<CGPoint> = Spring<CGPoint>(initialValue: .zero)

  override func viewDidLoad() {
    super.viewDidLoad()

    self.cardView = UIView(frame: .zero)
    cardView.layer.cornerRadius = 8.0
    cardView.layer.shadowRadius = 4.0
    cardView.layer.shadowOpacity = 0.3
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    cardView.backgroundColor = .white
    cardView.bounds = CGRect(origin: .zero, size: CGSize(width: 160.0, height: 240.0))
    view.addSubview(cardView)

    self.squircle = CALayer()
    squircle.bounds = CGRect(origin: .zero, size: CGSize(width: 57.0, height: 57.0))
    squircle.backgroundColor = UIColor(red: 0.31, green: 0.80, blue: 0.98, alpha: 1.0).cgColor
    squircle.cornerRadius = 10.0
    cardView.layer.addSublayer(squircle)

    cardView.layer.transform.perspective.m34 = 1.0 / 500.0

    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    cardView.addGestureRecognizer(panGestureRecognizer)

    translationSpring.onChange = { [weak self] newValue in
      guard let cardView = self?.cardView, let view = self?.view else { return }

      cardView.layer.translation = newValue

      let scaleValue = 1.0 - (max(abs(newValue.x), abs(newValue.y)) / (view.bounds.size.width * 1.4))
      cardView.layer.scale = CGPoint(x: scaleValue, y: scaleValue)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    squircle.position = CGPoint(x: cardView.bounds.size.width / 2.0, y: cardView.bounds.size.height / 2.0)
    cardView.layer.position = view.center
  }

  @objc func didPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let translation = panGestureRecognizer.translation(in: view)
    let velocity = panGestureRecognizer.velocity(in: view)

    switch panGestureRecognizer.state {
    case .began:
      translationSpring.reset(to: .zero)
      break
    case .changed:
      translationSpring.reset(to: translation)
      cardView.layer.translation = translation
      break
    case .ended, .cancelled:
      translationSpring.velocity = velocity
      translationSpring.target = .zero
      break
    default:
      break
    }
  }

}
