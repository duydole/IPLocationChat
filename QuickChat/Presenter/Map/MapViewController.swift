//
//  MapViewController.swift
//  QuickChat
//
//  Created by Do Le Duy on 9/19/20.
//  Copyright © 2020 Haik Aslanyan. All rights reserved.
//

import GoogleMaps
import UIKit
import GoogleMapsUtils

typealias LDMapPosition = CLLocationCoordinate2D

let kDebugTotalMarker = 100
let kCameraLatitude: CLLocationDegrees = 16.0
let kCameraLongitude: CLLocationDegrees = 106.0
let kDefaultCameraZoom: Float = 4.0

class MapViewController: UIViewController, GMSMapViewDelegate {
  
  private var googleMapView: GMSMapView!
  private var clusterManager: GMUClusterManager!
  private var ip2LocationService = IP2LocationService()
  
  override func loadView() {
    /// Setup camera
    let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: kDefaultCameraZoom)
    
    /// Set googleMapView as viewController.view
    googleMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    self.view = googleMapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    /// Setup ClusterManager
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: googleMapView, clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: googleMapView, algorithm: algorithm, renderer: renderer)
    clusterManager.setMapDelegate(self)
    
    /// Mark owner location on GoogleMapView
    markRandom()
  }
  
  // MARK: - GMUMapViewDelegate
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapView.animate(toLocation: marker.position)
    if let _ = marker.userData as? GMUCluster {
      mapView.animate(toZoom: mapView.camera.zoom + 1)
      NSLog("Did tap cluster")
      return true
    }
    NSLog("Did tap marker")
    return false
  }
  
  // MARK: - Private
  
  func markRandom() {
    for position in self.genRandomPositions(count: kDebugTotalMarker) {
      markOnMapViewWithPosition(position)
    }
  }
  
  func markOwnerLocationOnMapView() {
    ip2LocationService.loadOwnerIP { result in
      switch result {
      case .success(let ownerIP):
        self.ip2LocationService.getLocationOfIP(ip: ownerIP) { (result) in
          switch result {
          case .success(let position):
            self.markOnMapViewWithPosition(position)
          case .failure(let error):
            fatalError("Unresolved error: \(error)")
          }
        }
      case .failure(let error):
        fatalError("Unresolved error: \(error)")
      }
    }
  }
  
  func markOnMapViewWithPosition(_ position: LDMapPosition) {
    let marker = GMSMarker(position: position)
    marker.map = self.googleMapView
  }
  
  func genRandomPositions(count: Int) -> [LDMapPosition] {
    var listPosition: [LDMapPosition] = []
    for _ in 1...count {
      listPosition.append(LDMapPosition(latitude: self.randomLatitude(), longitude: self.randomLongitude()))
    }
    return listPosition
  }
  
  func randomLatitude() -> CLLocationDegrees {
    return CLLocationDegrees(Int.random(in: -90...90))
  }
  
  func randomLongitude() -> CLLocationDegrees {
    return CLLocationDegrees(Int.random(in: -180...180))
  }
}
