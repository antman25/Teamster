//
//  CLPlacemark+CompactAddress.swift
//  Teamster
//
//  Created by Anthony Magner on 1/24/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//
import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}
