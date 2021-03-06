import UIKit
import XCTest

import WorkWeek

class MyCal: NSCalendar {

}

class DayTimePickerTests: XCTestCase {

    var picker: DayTimePicker!
    var pickerView: UIPickerView!

    override func setUp() {
        picker = DayTimePicker()
        pickerView = UIPickerView(frame: .zeroRect)
        super.setUp()
    }
    
    override func tearDown() {
        picker = nil
        super.tearDown()
    }

    func testComponentsForDayOfWeekAndHourOfDay() {
        var comps = picker.numberOfComponentsInPickerView(pickerView)
        XCTAssertEqual(comps, 2, "Two Components: 1 for the Day, 1 for the Hour")
    }

    func testRowsInComponent0(){
        let days = picker.pickerView(pickerView, numberOfRowsInComponent: 0)
        XCTAssertEqual(days, 7, "Seven Days in Week") //this test is not good
    }
    func testRowsInComponent1(){
        let hours = picker.pickerView(pickerView, numberOfRowsInComponent: 1)
        XCTAssertEqual(hours, 24, "24 hours in day")
    }
    func testRowsInComponent2(){
        let nothing = picker.pickerView(pickerView, numberOfRowsInComponent: 2)
        XCTAssertEqual(nothing, 0, "Zero rows in undefined component")
    }

    func testDayView(){
        if let gregorianCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian) {
            let customPicker = DayTimePicker(calendar: gregorianCalendar)
            let dayView = customPicker.pickerView(pickerView, viewForRow: 0, forComponent: 0, reusingView: nil)
            XCTAssertNotNil(dayView, "DayView is returned")
            let daylabel = dayView as! UILabel
            XCTAssertEqual(daylabel.text!, "Sunday", "Sunday is the first component in the day view (for Gregorian Calendar)")
        } else {
            XCTFail("Not Able to setup Calendar Fail")
        }
    }

    func testInvalidDayView(){
        if let gregorianCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian) {
            let customPicker = DayTimePicker(calendar: gregorianCalendar)
            let dayView = customPicker.pickerView(pickerView, viewForRow: 100, forComponent: 0, reusingView: nil)
            XCTAssertNotNil(dayView, "DayView is returned")
            let daylabel = dayView as! UILabel
            XCTAssertNotNil(daylabel, "DayLabel is not nil")
            XCTAssertNil(daylabel.text, "Text is not set on invald items")
        } else {
            XCTFail("Not Able to setup Calendar Fail")
        }
    }

    func testHourView(){
        if let gregorianCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian){
            let customPicker = DayTimePicker(calendar: gregorianCalendar)
            let hourView = customPicker.pickerView(pickerView, viewForRow: 0, forComponent: 1, reusingView: nil)
            XCTAssertNotNil(hourView, "Hour View is not Nil")
            let hourLabel = hourView as! UILabel
            XCTAssertEqual(hourLabel.text!, "12:00 AM", "First Hour is 12:00 AM")
        } else {
            XCTFail("Not able to setup Calendar fail")
        }
    }

    func testInvalidHourView(){
        if let gregorianCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian){
            let customPicker = DayTimePicker(calendar: gregorianCalendar)
            let hourView = customPicker.pickerView(pickerView, viewForRow: 100, forComponent: 1, reusingView: nil)
            XCTAssertNotNil(hourView, "Hour View is not Nil")
            let hourLabel = hourView as! UILabel
            XCTAssertNotNil(hourLabel, "Hour Lable is not nil")
            XCTAssertNil(hourLabel.text, "Text is not set on invald items")
        } else {
            XCTFail("Not able to setup Calendar fail")
        }
    }
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
