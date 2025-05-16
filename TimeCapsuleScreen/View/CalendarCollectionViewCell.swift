//
//  CalendarCollectionViewCell.swift
//  Avox
//
//  Created by Nimap on 21/12/24.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    var baseView            : UIView?
    var dateLabel           : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCell() {
        baseView = UIView()
        baseView!.translatesAutoresizingMaskIntoConstraints = false
        baseView!.backgroundColor = UIColor.clear
        self.addSubview(baseView!)
        NSLayoutConstraint.activate([
            baseView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseView!.topAnchor.constraint(equalTo: self.topAnchor),
            baseView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        dateLabel = UILabel()
        dateLabel!.translatesAutoresizingMaskIntoConstraints = false
        dateLabel!.textAlignment = .center
        //dateLabel!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dateLabel!.font = UIFont.appFontMedium(ofSize: 17.0)
        baseView!.addSubview(dateLabel!)
        NSLayoutConstraint.activate([
            dateLabel!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor),
            dateLabel!.topAnchor.constraint(equalTo: baseView!.topAnchor),
            dateLabel!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor),
            dateLabel!.bottomAnchor.constraint(equalTo: baseView!.bottomAnchor)
        ])
    }
    
    func updateCollectionViewCell(with calendarModol: CalendarModel, index: Int) {
        //let weekdayNames = calendar.shortWeekdaySymbols
        dateLabel!.text = calendarModol.date != nil ?  "\(Calendar.current.component(.day, from: calendarModol.date!))" : ""
        
        if calendarModol.isToday {
            baseView!.backgroundColor = Helper.Color.appPrimary
            baseView!.cornerRadius = self.frame.size.height * 0.5
            dateLabel!.textColor = Helper.Color.accent
            dateLabel!.font = UIFont.appFontBold(ofSize: 17.0)
        }else {
            baseView!.backgroundColor = UIColor.clear
            dateLabel!.font = UIFont.appFontMedium(ofSize: 17.0)
            switch index {
            case 0, 7, 14, 21, 28:
                dateLabel!.textColor = UIColor.lightGray
            default:
                dateLabel!.textColor = Helper.Color.textPrimary
            }
        }
    }
}
