//
//  HomeViewController.swift
//  QuickChat
//
//  Created by Do Le Duy on 9/19/20.
//  Copyright © 2020 Haik Aslanyan. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
  
  let goToMapButton = UIButton()
  
  //MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .darkGray
    
    goToMapButton.setTitle("GO", for: .normal)
    goToMapButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
    goToMapButton.addTarget(self, action: #selector(didTapGoToMapButton), for: .touchUpInside)
    view.addSubview(goToMapButton)
  }
  
  @objc private func didTapGoToMapButton() {
    let vc = MapViewController()
    vc.modalPresentationStyle = .fullScreen
    show(vc, sender: self)
  }
}
