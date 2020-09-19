//
//  IP2LocationService.swift
//  QuickChat
//
//  Created by Do Le Duy on 9/19/20.
//  Copyright © 2020 Haik Aslanyan. All rights reserved.
//

import Foundation
import Alamofire

typealias requestOwnerIPCompletion = (Result<String, Error>) -> Void

class IP2LocationService {
  
  func loadOwnerIP(completion: @escaping requestOwnerIPCompletion) -> Void {
    let url = "http://35.198.220.200:8765/showip"

    AF.request(url).responseDecodable(of: String.self) { response in
      switch response.result {
      case .success(let ownerIP):
        completion(.success(ownerIP))
      case .failure(let error):
        completion(.failure(error))
        
      }
    }
  }
}
