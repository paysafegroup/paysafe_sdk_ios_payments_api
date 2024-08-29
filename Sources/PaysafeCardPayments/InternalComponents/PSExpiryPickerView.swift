//
//  PSExpiryPickerView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSExpiryPickerViewDelegate
protocol PSExpiryPickerViewDelegate: AnyObject {
    func pickerViewSelectedDate(month: Int, year: Int)
}

/// PSExpiryPickerView
class PSExpiryPickerView: UIPickerView {
    private let months = Array(1...12)
    private let years = Array(Calendar.current.component(.year, from: Date())...Calendar.current.component(.year, from: Date()) + 20)

    private var selectedMonth: Int? {
        didSet {
            guard let selectedMonth, let selectedIndex = months.firstIndex(of: selectedMonth) else { return }
            selectRow(selectedIndex, inComponent: 0, animated: true)
        }
    }

    private var selectedYear: Int? {
        didSet {
            guard let selectedYear, let selectedIndex = years.firstIndex(of: selectedYear) else { return }
            selectRow(selectedIndex, inComponent: 1, animated: true)
        }
    }

    /// PSExpiryPickerViewDelegate
    weak var psDelegate: PSExpiryPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        delegate = self
        dataSource = self

        selectedMonth = Calendar.current.component(.month, from: Date())
        selectedYear = Calendar.current.component(.year, from: Date())
    }

    func didBeginEditing() {
        let month = selectedMonth ?? Calendar.current.component(.month, from: Date())
        let year = selectedYear ?? Calendar.current.component(.year, from: Date())
        psDelegate?.pickerViewSelectedDate(month: month, year: year)
    }
}

// MARK: - UIPickerViewDataSource
extension PSExpiryPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(format: "%02d", months[row])
        case 1:
            return String(years[row])
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate
extension PSExpiryPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = months[selectedRow(inComponent: 0)]
        let year = years[selectedRow(inComponent: 1)]

        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())

        // Check for past month of the current year
        if year == currentYear, month < currentMonth {
            selectedMonth = currentMonth
            selectedYear = currentYear
            psDelegate?.pickerViewSelectedDate(month: currentMonth, year: currentYear)
        } else {
            selectedMonth = month
            selectedYear = year
            psDelegate?.pickerViewSelectedDate(month: month, year: year)
        }
    }
}
