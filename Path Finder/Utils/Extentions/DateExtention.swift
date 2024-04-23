//
//  DateExtention.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-23.
//

import Foundation


extension Date {
    
    // Return formated time difference
    func formattedTimeDifference(from startDate: Date, to endDate: Date) -> String? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .second], from: startDate, to: endDate)
        
        guard let minutes = components.minute, let seconds = components.second else {
            return nil
        }
        
        if minutes < 10 {
            return String(format: "%d:%02d min", minutes, seconds)
        } else {
            return String(format: "%d:%02d min", minutes, seconds)
        }
    }
    
    // Return Formated Date & Time as String
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
