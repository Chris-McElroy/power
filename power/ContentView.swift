//
//  ContentView.swift
//  power
//
//  Created by Chris McElroy on 12/28/22.
//

import IOKit.ps
import SwiftUI

enum PowerState {
	case dying, low, fine, charged
}

struct ContentView: View {
	@State var powerState = getPowerState()
	
	var color: Color {
		switch powerState {
		case .fine: return .clear
		case .charged: return Color(.displayP3, red: 0, green: 0.85, blue: 0.3)
		case .low: return Color(.displayP3, red: 0.88, green: 0.62, blue: 0.0, opacity: 1.0)
		case .dying: return Color(.displayP3, red: 1, green: 0.0, blue: 0.0, opacity: 1.0)
		}
	}
	
    var body: some View {
		Circle()
			.foregroundColor(color)
			.frame(width: 3, height: 3)
			.padding(.all, 3)
    }
}


// from https://stackoverflow.com/a/34571839/8222178
func getPowerState() -> PowerState {
	// Take a snapshot of all the power source info
	guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue() else { return .dying }

	// Pull out a list of power sources
	guard let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [AnyObject] else { return .dying }
	
	// For each power source...
	for ps in sources {
		// Fetch the information for a given power source out of our snapshot
		guard let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as? [String: AnyObject] else { return .dying }
		
		guard (info[kIOPSNameKey] as? String) == "InternalBattery-0" else { return .dying }
		
		let capacity = (info[kIOPSCurrentCapacityKey] as? Int) ?? 0
		
		if (info[kIOPSPowerSourceStateKey] as? String) == "AC Power" && capacity >= 80 {
			return .charged
		}
		
		if capacity <= 20 { return .dying }
		if capacity < 50 { return .low }
		return .fine
	}
	
	return .dying
}
