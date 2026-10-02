// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

@main struct IntelTemperatureTests {
    static func main() {
        let platform = TemperatureSensorSelector.platform(brandString: "Intel(R) Core(TM) i5-2415M CPU @ 2.30GHz")
        precondition(platform == .intel)
        // Hardware keys observed on MacBookPro8,1, plus a hotter GPU/battery to
        // detect accidental mixing between the displayed CPU and other sensors.
        let readings: [(key: String, value: Double)] = [
            ("TC0C", 74.15625), ("TC1C", 71), ("TC2C", 71),
            ("TC0D", 70.375), ("TC0F", 77.97266), ("TC0P", 62.5),
            ("TCGC", 92), ("TB0T", 99), ("TCSA", 100)
        ]
        precondition(TemperatureSensorSelector.displayedCPUTemperature(readings: readings, platform: platform) == 74.15625)
        precondition(!TemperatureSensorSelector.isCPUTemperatureKey("TCGC", platform: platform))
        precondition(!TemperatureSensorSelector.isCPUTemperatureKey("TCSA", platform: platform))
        precondition(TemperatureSensorSelector.isGPUTemperatureKey("TCGC", platform: platform))
        precondition(TemperatureSensorSelector.isGPUTemperatureKey("TG0D", platform: platform))
        precondition(!TemperatureSensorSelector.isGPUTemperatureKey("TC0D", platform: platform))
        precondition(TemperatureSensorSelector.isCPUCoreKey("TC0c", platform: platform))
        precondition(TemperatureSensorSelector.displayedCPUTemperature(readings: [("TC0C", 0), ("TC1C", .nan), ("TC0D", 70), ("TC0F", 90)], platform: platform) == 70)
        precondition(TemperatureSensorSelector.displayedCPUTemperature(readings: [("TC0C", 125), ("TC1C", .infinity), ("TC0D", -5), ("TCGC", 80)], platform: platform) == nil)
        precondition(TemperatureSensorSelector.displayedCPUTemperature(readings: [("TC0P", 61)], platform: platform) == 61)
        precondition(TemperatureSensorSelector.platform(brandString: "Apple M1") == .appleM1Family)
        precondition(TemperatureSensorSelector.isCPUTemperatureKey("Tp01", platform: .appleM1Family))
        precondition(!TemperatureSensorSelector.isCPUTemperatureKey("TC0C", platform: .appleM1Family))
        precondition(TemperatureSensorSelector.isGPUTemperatureKey("Tg0D", platform: .appleM1Family))
        precondition(!TemperatureSensorSelector.isGPUTemperatureKey("TCGC", platform: .appleM1Family))
        print("Intel temperature regression tests passed")
    }
}
