//
//  ContentViewModel.swift
//  User-Location_SwiftUI
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 29/08/22.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    func checkIfLocationServicesIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert letting them know that they have to turn locations on")
        }
    }
    
    //Function that check the user location permission, its private because only functions inside this class can have access to this function
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        
        
        //Switch case to determine the authorization of the user about the location of it
        switch locationManager.authorizationStatus {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your current location in restricted")
        case .denied:
            print("You have denied this app location permission. Go to the settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MapDetails.defaultSpan)
        @unknown default:
            break
        }

    }
    
    //Function created to verify if the user location permission did change
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
