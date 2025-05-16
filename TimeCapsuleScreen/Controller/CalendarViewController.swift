//
//  CalendarViewController.swift
//  Avox
//
//  Created by Nimap on 21/12/24.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var daysStackView: UIStackView!
    
    var collectionView        : UICollectionView!
    let calendar              = Calendar.current
    var dates                 : [CalendarModel] = []
    var currentMonthDate      : Date = Date()
    
    var deviceManager         : DeviceManager?
    var navigationItems       = UINavigationItem()
    
    var eventLabel            : UILabel?
    var tableView             : UITableView?
    var eventModel            : [EventData] = []
    
    var fontSize              : CGFloat = 0.0
    var cellHeight            : CGFloat = 0.0
    var cellSize              : CGFloat = 0.0
    
    var heightConstraint      : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadDeviceManager()
        loadNavigationBar()
        loadCollectionView()
        prepareCalendar(for: Date())
        loadEventView()
        getEventData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionView()
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_5_6_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_12FAMILY_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_CELL_HEIGHT
        }
        cellSize = self.view.frame.size.width / 9
    }
    
    func loadNavigationBar() {
        navigationItems.title = ""
        let addEventBtn = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addEventButtonPressed))
        let previousBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(previousButtonPressed))
        let nextBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .done, target: self, action: #selector(nextButtonPressed))
        navigationItems.rightBarButtonItems = [nextBtn, previousBtn, addEventBtn]
        navigationItems.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar.items = [navigationItems]
        navigationBar.barTintColor = Helper.Color.bgPrimary
        navigationBar.tintColor = Helper.Color.appPrimary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: 24) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
    }
    
    func loadCollectionView() {
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 40, height: 40)  // Adjust cell size
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false // Important for dynamic height
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5.0),
            collectionView.topAnchor.constraint(equalTo: daysStackView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5.0),
        ])
        heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: cellSize*4)
        heightConstraint.isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        cell.updateCollectionViewCell(with: dates[indexPath.item], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = dates[indexPath.item]
        print("Selected date: \(selectedDate.date!)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func loadEventView() {
        eventLabel = UILabel()
        eventLabel!.translatesAutoresizingMaskIntoConstraints = false
        eventLabel!.text = "Upcoming Event"
        eventLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        eventLabel!.textColor = Helper.Color.textPrimary
        eventLabel!.textAlignment = .left
        eventLabel!.isUserInteractionEnabled = true
        self.view.addSubview(eventLabel!)
        NSLayoutConstraint.activate([
            eventLabel!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0),
            eventLabel!.topAnchor.constraint(equalTo: collectionView!.bottomAnchor, constant: 10.0),
            eventLabel!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0)
        ])
        
        tableView = UITableView()
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView!.topAnchor.constraint(equalTo: eventLabel!.bottomAnchor, constant: 5.0),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.updateTableViewCellForEvent(model: eventModel[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(eventModel[indexPath.row].title!)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DatabaseManager.share.context.delete(eventModel[indexPath.row])
            do {
                try DatabaseManager.share.context.save()
                eventModel.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error {
                debugPrint("Failed to delete notification: \(error)")
            }
            //self.tableView!.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func getEventData() {
        do {
            let result = try DatabaseManager.share.context.fetch(EventData.fetchRequest()) as [EventData]
            eventModel = result
            tableView!.reloadData()
        }catch {
            debugPrint(error)
        }
    }
    
    func prepareCalendar(for date: Date) {
        currentMonthDate = date // Update the current month
        navigationItems.title = getMonthName(for: date)
        // Get the first day of the current month and number of days
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        
        var days: [CalendarModel] = []
        
        for _ in 1..<startWeekday {
            days.append(CalendarModel(date: nil, isToday: false, isCurrentMonth: false))
        }
        
        for day in range {
            let currentDate = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
            let isToday = calendar.isDateInToday(currentDate)
            days.append(CalendarModel(date: currentDate, isToday: isToday, isCurrentMonth: true))
        }
        
        self.dates = days
        self.collectionView.reloadData()
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func previousButtonPressed() {
        currentMonthDate = calendar.date(byAdding: .month, value: -1, to: currentMonthDate)!
        prepareCalendar(for: currentMonthDate)
        updateCollectionView()
    }
    
    @objc func nextButtonPressed() {
        currentMonthDate = calendar.date(byAdding: .month, value: 1, to: currentMonthDate)!
        prepareCalendar(for: currentMonthDate)
        updateCollectionView()
    }
    
    func getMonthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        return formatter.string(from: date)
    }
    
    @objc func addEventButtonPressed() {
        let vc = AddEventViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateCollectionView() {
        // Force layout update before getting contentSize
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()

        // Update height constraint
        heightConstraint.constant = collectionView.contentSize.height
    }
}
