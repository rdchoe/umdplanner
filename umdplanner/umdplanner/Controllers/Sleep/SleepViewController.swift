//
//  SleepViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Charts

class SleepViewController: UIViewController {
    
    var durationSet = [Double]()
    var dateSet = [String]()
    var timeSet = [Double]()
    var dict : [Date: Double] = [:]
    var sleepPeriod = sleepTracker()
    var flag = false
    var flagTime : Date?
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var SleepButton: UIButton!
    @IBOutlet weak var ManualButton: UIButton!
    @IBOutlet weak var SummaryButton: UIButton!
    @IBOutlet weak var SleepTimeChartView: LineChartView!
    @IBOutlet weak var DurationTitle: UILabel!
    @IBOutlet weak var TimeTitle: UILabel!
    @IBOutlet weak var NavCtr: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: 0x282C35)
        //        SleepButton.setTitleColor(UIColor(rgb: 0xFFA7C4), for: UIControl.State.normal)
        ManualButton.setTitleColor(UIColor(rgb: 0xFFA7C4), for: UIControl.State.normal)
        SummaryButton.setTitleColor(UIColor(rgb: 0xFFA7C4), for: UIControl.State.normal)
        DurationTitle.textColor = UIColor(rgb: 0xFFA7C4)
        TimeTitle.textColor = UIColor(rgb: 0xFFA7C4)
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x282C35)
        tabBarController?.tabBar.barTintColor = UIColor(rgb: 0x282C35)
        
        SleepButton.layer.cornerRadius = 0.5 * SleepButton.bounds.size.width
        SleepButton.clipsToBounds = true
        SleepButton.setImage(UIImage(named:"sleepButton.jpg"), for: .normal)
        
        //DurationTitle.font = UIFont(name: "Montserrat-Black", size: 17)
        //TimeTitle.font = UIFont(name: "Montserrat-Black", size: 17)
        //ManualButton.titleLabel?.font = UIFont(name: "merriweather-regular", size: 17)
        //SummaryButton.titleLabel?.font = UIFont(name: "merriweather-regular", size: 17)
        //        DurationTitle.font = UIFont(name: "Montserrat", size: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveData()
        setChartValues()
        checkFlag()
    }
    
    @IBAction func SleepButtonPreesed(_ sender: Any) {
        if !flag {
            addFlag()
            flag = true
        } else {
            saveFlagTime()
            self.SleepButton.setBackgroundImage(UIImage(named: "SleepImage.png"), for: UIControl.State.normal)
            retrieveData()
            setChartValues()
            flag = false
        }
        checkFlag()
    }
    
    func setChartValues(_ count : Int = 20) {
        var lineChartEntry = [ChartDataEntry]()
        let xAxis = lineChart.xAxis
        let leftAxis = lineChart.leftAxis
        let rightAxis = lineChart.rightAxis
        
        for i in 0..<timeSet.count {
            let val = ChartDataEntry(x: Double(i), y: Double(timeSet[i]))
            lineChartEntry.append(val)
        }
        
        lineChart.noDataTextColor = UIColor(rgb: 0xE5E5E6)
        lineChart.backgroundColor = UIColor(rgb: 0x424857)
        lineChart.tintColor = UIColor(rgb: 0xE5E5E6)
        lineChart.borderColor = UIColor(rgb: 0xE5E5E6)
        lineChart.legend.enabled = false
        leftAxis.labelTextColor = UIColor.white
        xAxis.labelTextColor = UIColor.white
        
        
        lineChart.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        rightAxis.enabled = false
        xAxis.drawGridLinesEnabled = false
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Sleep Hours")
        line1.circleRadius = 3
        line1.circleColors = [UIColor(rgb: 0xE5E5E6)]
        line1.colors = [UIColor(rgb: 0xFFA7C4)]
        line1.valueColors = [UIColor.white]
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values:dateSet)
        xAxis.granularity = 1
        
        
        let data = LineChartData()
        data.addDataSet(line1)
        if (timeSet.count != 0) {
            lineChart.data = data
        } else {
            lineChart.data = nil
        }
        
        setDurationChart()
        
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
    }
    
    func setDurationChart() {
        var dataEntries: [BarChartDataEntry] = []
        let xAxis = SleepTimeChartView.xAxis
        let leftAxis = SleepTimeChartView.leftAxis
        let rightAxis = SleepTimeChartView.rightAxis
        let d = durationSet
        for i in 0..<d.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(d[i]))
            dataEntries.append(dataEntry)
        }
        
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = [UIColor.white]
        if (durationSet.count != 0) {
            SleepTimeChartView.data = chartData
        } else {
            SleepTimeChartView.data = nil
        }
        
        SleepTimeChartView.pinchZoomEnabled = false
        SleepTimeChartView.doubleTapToZoomEnabled = false
        SleepTimeChartView.noDataTextColor = UIColor(rgb: 0xE5E5E6)
        SleepTimeChartView.backgroundColor = UIColor(rgb: 0x424857)
        SleepTimeChartView.tintColor = UIColor(rgb: 0xE5E5E6)
        SleepTimeChartView.borderColor = UIColor(rgb: 0xE5E5E6)
        SleepTimeChartView.legend.enabled = false
        SleepTimeChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        chartDataSet.colors = [UIColor(rgb: 0xFFA7C4)]
        chartDataSet.valueColors = [UIColor.white]
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values:dateSet)
        xAxis.granularity = 1
        xAxis.labelTextColor = UIColor.white
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values:dateSet)
        rightAxis.enabled = false
        leftAxis.labelTextColor = UIColor.white
    }
    
    func addFlag() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SleepFlag", in: context)
        let newRecord = NSManagedObject(entity: entity!, insertInto: context)
        
        newRecord.setValue(true, forKey: "flag")
        newRecord.setValue(Date(), forKey: "time")
        
        do {
            try context.save()
            let alert = UIAlertController(title: "Sleeping!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Saving Error", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("Failed saving")
        }
    }
    
    func saveFlagTime() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sleep", in: context)
        
        let newRecord = NSManagedObject(entity: entity!, insertInto: context)
        
        let UT = Date()
        let ST = flagTime
        let d = UT.timeIntervalSince(ST!)
        
        newRecord.setValue(Int(d), forKey: "duration")
        newRecord.setValue(ST, forKey: "sleepTime")
        newRecord.setValue(UT, forKey: "upTime")
        
        do {
            try context.save()
            let alert = UIAlertController(title: "Data Entry Saved!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Saving Error", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("Failed saving")
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SleepFlag")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
        flag = false
    }
    
    func checkFlag() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SleepFlag")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                flag = (data.value(forKey: "flag") != nil)
                if flag {
                    flagTime = data.value(forKey: "time") as? Date
                    self.SleepButton.setBackgroundImage(UIImage(named: "moon.png"), for: UIControl.State.normal)
                }
            }
            
        } catch {
            print("Failed")
        }
    }
    
    func retrieveData() {
        durationSet.removeAll()
        dateSet.removeAll()
        dict.removeAll()
        timeSet.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sleep")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let interval = (data.value(forKey: "duration") as! Int)
                let sleepTime = data.value(forKey: "sleepTime")
                var doubleInt = 0.0
                let minutes = (interval / 60) % 60
                let hours = (interval / 3600)
                
                doubleInt += Double(hours)
                doubleInt += Double(minutes)/60
                let rounded = Double(round(100*doubleInt)/100)
                dict[sleepTime as! Date] = rounded
                let slpHr = Double(Calendar.current.component(.hour, from: sleepTime as! Date))
                let slpMin = Double(Calendar.current.component(.minute, from: sleepTime as! Date))
                let sleepTimeInDouble : Double = slpHr + slpMin/100
                timeSet.append(sleepTimeInDouble)
            }
            
            for (k,v) in (Array(dict).sorted {$0.key < $1.key}) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
                let myString = formatter.string(from: k)
                let yourDate = formatter.date(from: myString)
                formatter.dateFormat = "MM/dd"
                let myStringafd = formatter.string(from: yourDate!)
                dateSet.append(myStringafd)
                durationSet.append(v)
            }
        } catch {
            print("Failed")
        }
        print(durationSet)
    }
    
    func calculateAvgTime(dates : [Date]) -> String {
        var totalHour = 0, totalMin = 0
        for date in dates {
            let hour = Calendar.current.component(.hour, from: date)
            let minutes = Calendar.current.component(.minute, from: date)
            totalHour += Int(hour)
            totalMin += Int(minutes)
        }
        return String(format: "%02d : %02d", totalHour/dates.count, totalMin/dates.count)
        
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
