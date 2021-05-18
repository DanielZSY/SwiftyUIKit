
import UIKit
import SwiftDate

/// 生日选择器
public class ZBirthdayPickerView: UIPickerView {
    
    /// 设置显示文本颜色
    public var textColor: UIColor = "#333333".color
    /// 生日选择改变回调
    public var onBirthdayChange: ((_ birthday: String) -> Void)?
    /// 设置默认生日 - 年月日
    public var birthday: String? {
        didSet {
            guard let date = birthday?.toDate()?.date else { return }
            
            self.z_year_s = date.year
            self.z_month_s = date.month
            self.z_day_s = date.day
            
            self.daysForm(year: self.z_year_s, month: self.z_month_s)
            if let row = z_arrayYear.firstIndex(of: self.z_year_s) {
                self.selectRow(row, inComponent: 0, animated: false)
            }
            if let row = z_arrayMonth.firstIndex(of: self.z_month_s) {
                self.selectRow(row, inComponent: 1, animated: false)
            }
            if let row = z_arrayDay.firstIndex(of: self.z_day_s) {
                self.selectRow(row, inComponent: 2, animated: false)
            }
        }
    }
    /// 获取当前选择生日字符串
    private var z_date: String {
        let month = z_month_s < 10 ? "0\(z_month_s)" : "\(z_month_s)"
        let day = z_day_s < 10 ? "0\(z_day_s)" : "\(z_day_s)"
        return "\(z_year_s)-\(month)-\(day)"
    }
    private var z_year_s: Int = Date().year - 18
    private var z_month_s: Int = 1
    private var z_day_s: Int = 1
    private var z_arrayYear: [Int] = [Int]()
    private var z_arrayMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ,11, 12]
    private var z_arrayDay: [Int] = [Int]()
    private lazy var z_arrayMonthStr: [String] = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    private lazy var z_arrayMonthAllStr: [String] = ["January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tintColor = "#333333".color
        self.backgroundColor = "#F5F5F5".color
        
        self.z_arrayYear.removeAll()
        let maxyear = Date().year - 18
        let minyear = Date().year - 100
        for year in minyear...maxyear { self.z_arrayYear.append(year) }
        self.daysForm(year: self.z_year_s, month: self.z_month_s)
        
        self.delegate = self
        self.dataSource = self
        self.reloadAllComponents()
        self.selectRow(self.z_arrayYear.count - 1, inComponent: 0, animated: false)
        self.selectRow(0, inComponent: 1, animated: false)
        self.selectRow(0, inComponent: 2, animated: false)
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        self.delegate = nil
        self.dataSource = nil
    }
    /// 计算每个月的天数
    private func daysForm(year: Int, month: Int) {
        self.z_arrayDay.removeAll()
        let isLeapYear = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
        switch month {
        case 1,3,5,7,8,10,12:
            for i in 1...31 {
                self.z_arrayDay.append(i)
            }
        case 4,6,9,11:
            for i in 1...30 {
                self.z_arrayDay.append(i)
            }
        case 2:
            if isLeapYear {
                for i in 1...29 {
                    self.z_arrayDay.append(i)
                }
            } else {
                for i in 1...28 {
                    self.z_arrayDay.append(i)
                }
            }
        default: break
        }
    }
}
extension ZBirthdayPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1: return self.z_arrayMonth.count
        case 2: return self.z_arrayDay.count
        default: break
        }
        return self.z_arrayYear.count
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var val: String = ""
        switch component {
        case 0:
            val = self.z_arrayYear[row].str
        case 1:
            val = self.z_arrayMonth[row].str
        case 2:
            val = self.z_arrayDay[row].str
        default: break
        }
        let text = val.count == 1 ? "0\(val)" : val
        let att = NSMutableAttributedString.init(string: text)
        att.addAttributes([NSAttributedString.Key.foregroundColor: self.textColor, NSAttributedString.Key.font: UIFont.boldSystemFont(24)], range: NSRange.init(location: 0, length: text.count))
        return att
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.z_year_s = self.z_arrayYear[row]
            self.daysForm(year: self.z_year_s, month: self.z_month_s)
            self.reloadComponent(2)
            let lastday = (self.z_arrayDay.last ?? 30)
            if self.z_day_s > lastday {
                self.z_day_s = lastday
            }
        case 1:
            self.z_month_s = self.z_arrayMonth[row]
            self.daysForm(year: self.z_year_s, month: self.z_month_s)
            self.reloadComponent(2)
            let lastday = (self.z_arrayDay.last ?? 30)
            if self.z_day_s > lastday {
                self.z_day_s = lastday
            }
        case 2:
            self.z_day_s = self.z_arrayDay[row]
        default: break
        }
        self.onBirthdayChange?(self.z_date)
    }
}

