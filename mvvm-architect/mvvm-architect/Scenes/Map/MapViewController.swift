//
//  MapViewController.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/16/20.
//  Copyright © 2020 sun. All rights reserved.
//

import GoogleMaps

final class MapViewController: UIViewController {
    @IBOutlet private var mapView: GMSMapView!

    private let lat: Double = 21.022
    private let long: Double = 105.819

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }

    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        mapView.camera = camera

        // Create a marker in the center of the map
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "My position"
        marker.snippet = "Hanoi"
        marker.map = mapView
    }
}
