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

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var name: String!

  init(position: CLLocationCoordinate2D, name: String) {
    self.position = position
    self.name = name
  }
}

let kClusterItemCount = 10000
let kCameraLatitude: CLLocationDegrees = 16.0
let kCameraLongitude: CLLocationDegrees = 106.0
let kDefaultCameraZoom: Float = 4.0

class MapViewController: UIViewController, GMSMapViewDelegate {

  private var mapView: GMSMapView!
  private var clusterManager: GMUClusterManager!

  override func loadView() {
    let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: kDefaultCameraZoom)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    self.view = mapView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set up the cluster manager with default icon generator and renderer.
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    
    // Register self to listen to GMSMapViewDelegate events.
    clusterManager.setMapDelegate(self)
    
    // Generate and add random items to the cluster manager.
    generateClusterItems()

    // Call cluster() after items have been added to perform the clustering and rendering on map.
    clusterManager.cluster()
  }

  // MARK: - GMUMapViewDelegate

  /// Xử lý event khi tap 1 MARKER
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

  /// Randomly generates cluster items within some extent of the camera and adds them to the
  /// cluster manager.
  private func generateClusterItems() {
    
    IP2LocationService().loadOwnerIP { result in
      switch result {
      case .success(let ownerIP):
        print("duydl: load success: \(ownerIP)")
        IP2LocationService().getLocationOfIP(ip: ownerIP) { (result) in
          switch result {
          case .success(let position):
            let marker = GMSMarker(position: position)
            self.clusterManager.add(marker)
            
          case .failure(let error):
            print(error)
          }
        }
      case .failure(let error):
        print("duydl: load failed: \(error)")
      }
    }
    
//    let extent = 0.2
//    for _ in 1...kClusterItemCount {
//      let lat = kCameraLatitude + extent * randomScale()
//      let lng = kCameraLongitude + extent * randomScale()
//      let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//      let marker = GMSMarker(position: position)
//      clusterManager.add(marker)
//    }
  }

  /// Returns a random value between -1.0 and 1.0.
  private func randomScale() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
  }
}
