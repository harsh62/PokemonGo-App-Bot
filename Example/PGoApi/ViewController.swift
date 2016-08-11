//
//  ViewController.swift
//  PGoApi
//
//  Created by Luke Sapan on 08/02/2016.
//  Copyright (c) 2016 Luke Sapan. All rights reserved.
//

import UIKit
import PGoApi

class ViewController: UIViewController, PGoAuthDelegate {

    var auth: GPSOAuth!
    var request = PGoApiRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = GPSOAuth()
        auth.delegate = self
        auth.login(withUsername: "harsh.singh@pointclickcare.com", withPassword: "Aman-2392")
    }
    
    func didReceiveAuth() {
        print("Auth received!!")
        simulateAppStartAndMakeLoginRequest()
    }
    
    func didNotReceiveAuth() {
        print("Failed to auth!")
    }
    
    func simulateAppStartAndMakeLoginRequest() {
        print("Starting simulation...")
        
        // Init with auth
        request = PGoApiRequest(auth: auth)
        
        // Set the latitude/longitude of player; altitude should be included, but it's optional
        request.setLocation(37.331686, longitude: -122.030765, altitude: 1.0)
        
        // Simulate the start
        request.simulateAppStart()
        request.makeRequest(.Login, completion: {
            responseIntent, status, response in
            if status == .Success {
                self.getMapObjects()
            }
        })
    }
    
    
    func  getMapObjects() {
        self.request.getMapObjects()
        self.request.makeRequest(.GetMapObjects, completion: {
            responseIntent, status, response in
            if (status! == .Success){
                print("Got map objects!")
                print(response!.response)
                print(response!.subresponses)
                let r = response!.subresponses[0] as! Pogoprotos.Networking.Responses.GetMapObjectsResponse
                let cell = r.mapCells[0]
                print(cell.nearbyPokemons)
                print(cell.wildPokemons)
                print(cell.catchablePokemons)
            }
        })
    }

}

