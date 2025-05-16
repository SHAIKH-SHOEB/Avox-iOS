//
//  AddEventViewController.swift
//  Avox
//
//  Created by Nimap on 12/01/25.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, CustomBottomSheetViewDelegate, AvoxAlertViewDelegate, LocationViewControllerDelegate {
    
    var deviceManager           : DeviceManager?
    var navigationBar           : UINavigationBar?
    var alertView               : AvoxAlertView?
    
    var scrollView              : UIScrollView?
    var contentView             : UIView?
    
    var stackView               : UIStackView?
    var timeStackView           : UIStackView?
    
    var eventNameView           : UIView?
    var eventNameTextField      : UITextField?
    
    var startTimeView           : UIView?
    var startTimeTextField      : UITextField?
    
    var endTimeView             : UIView?
    var endTimeTextField        : UITextField?
    
    var dateView                : UIView?
    var dateTextField           : UITextField?
    
    var reminderView            : UIView?
    var reminderTextField       : UITextField?
    
    var locationView            : UIView?
    var locationTextField       : UITextField?
    
    var eventTypeView           : UIView?
    var eventTypeTextField      : UITextField?
    
    var colorView               : UIView?
    var colorTextField          : UITextField?
    
    var contactView             : UIView?
    var contactTextField        : UITextField?
    
    var notesView               : UIView?
    var notesTextView           : UITextView?
    
    var bottomSheetView         : CustomBottomSheetView?
    var addEventButton          : UIButton?
    
    var fontSize                : CGFloat = 0.0
    var constant                : CGFloat = 0.0
    var cellHeight              : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        loadDeviceManager()
        loadPage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_5_6_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_12FAMILY_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_CELL_HEIGHT
        }
    }
    
    func loadPage() {
        loadNavigationBar()
        loadScrollView()
        loadStackView()
        loadBaseView()
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: "Add Event")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(leftkButtonPressed))
        navigationBar!.items = [navigationItem]
        navigationBar!.barTintColor = Helper.Color.bgPrimary
        navigationBar!.tintColor = Helper.Color.appPrimary
        navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: fontSize*1.8) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
        self.view.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadScrollView() {
        scrollView = UIScrollView()
        scrollView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.showsHorizontalScrollIndicator = false
        scrollView!.delegate = self
        self.view.addSubview(scrollView!)
        NSLayoutConstraint.activate([
            scrollView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: constant),
            scrollView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant),
            scrollView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant),
            scrollView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -constant)
        ])
    }
    
    func loadStackView() {
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = NSLayoutConstraint.Axis.vertical
        stackView!.spacing = constant
        stackView!.distribution = .fillProportionally
        scrollView!.addSubview(stackView!)
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor),
            stackView!.topAnchor.constraint(equalTo: scrollView!.topAnchor),
            stackView!.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor),
            stackView!.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor),
            stackView!.widthAnchor.constraint(equalTo: scrollView!.widthAnchor)
        ])
    }
    
    func loadBaseView() {
        eventNameView = setBackView(cellHeight*1.2)
        eventNameTextField = setTextField(eventNameView!, title: "Event Title", placeholder: "Enter Event Title")
        
        timeStackView = UIStackView()
        timeStackView!.axis = NSLayoutConstraint.Axis.horizontal
        timeStackView!.spacing = constant
        timeStackView!.distribution = .fillEqually
        stackView!.addArrangedSubview(timeStackView!)
        
        startTimeView = setBackView(cellHeight*1.2, view: timeStackView)
        startTimeTextField = setTextField(startTimeView!, title: "Start Time", placeholder: "HH:MM A")
        startTimeTextField!.inputAccessoryView = addToolBar(cancelSelector: #selector(startCancelButtonTapped), doneSelector: #selector(startDoneButtonTapped))
        startTimeTextField!.inputView = addDatePicker(selector: #selector(handleStartTimePicker(sender: )), isTime: true)
        
        endTimeView = setBackView(cellHeight*1.2, view: timeStackView)
        endTimeTextField = setTextField(endTimeView!, title: "End Time", placeholder: "HH:MM A")
        endTimeTextField!.inputAccessoryView = addToolBar(cancelSelector: #selector(endCancelButtonTapped), doneSelector: #selector(endDoneButtonTapped))
        endTimeTextField!.inputView = addDatePicker(selector: #selector(handleEndTimePicker(sender: )), isTime: true)
        
        dateView = setBackView(cellHeight*1.2)
        dateTextField = setTextField(dateView!, title: "Event Date", placeholder: "DD MMM YYYY")
        dateTextField!.inputAccessoryView = addToolBar(cancelSelector: #selector(dateCancelButtonTapped), doneSelector: #selector(dateDoneButtonTapped))
        dateTextField!.inputView = addDatePicker(selector: #selector(handleDatePicker(sender: )), isTime: false)
        
        reminderView = setBackView(cellHeight*1.2)
        reminderTextField = setTextField(reminderView!, title: "Reminder", placeholder: "Select Reminder")
        
        locationView = setBackView(cellHeight*1.2)
        locationTextField = setTextField(locationView!, title: "Location", placeholder: "Pick Location")
        
        eventTypeView = setBackView(cellHeight*1.2)
        eventTypeTextField = setTextField(eventTypeView!, title: "Event Type", placeholder: "Select Event Type")
        
        colorView = setBackView(cellHeight*1.2)
        colorTextField = setTextField(colorView!, title: "Color", placeholder: "Select Color Type")
        
        contactView = setBackView(cellHeight*1.2)
        contactTextField = setTextField(contactView!, title: "Contact", placeholder: "Enter Contact")
        contactTextField!.inputAccessoryView = addToolBar(cancelSelector: #selector(contactCancelButtonTapped), doneSelector: #selector(contactDoneButtonTapped))
        contactTextField!.keyboardType = .numberPad
        
        notesView = setBackView(cellHeight*2)
        notesTextView = setTextView(notesView!, title: "Notes", placeholder: "Note...")
        notesTextView!.inputAccessoryView = addToolBar(cancelSelector: #selector(noteCancelButtonTapped), doneSelector: #selector(noteDoneButtonTapped))
        
        addEventButton = UIButton(type: .system)
        addEventButton!.translatesAutoresizingMaskIntoConstraints = false
        addEventButton!.setTitle("Add Event", for: .normal)
        addEventButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        addEventButton!.backgroundColor = Helper.Color.appPrimary
        addEventButton!.layer.cornerRadius = constant
        addEventButton!.setTitleColor(Helper.Color.bgPrimary, for: .normal)
        addEventButton!.addTarget(self, action: #selector(addEventButtonPressed), for: .touchDown)
        stackView!.addArrangedSubview(addEventButton!)
        NSLayoutConstraint.activate([
            addEventButton!.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
    }
    
    @objc func addEventButtonPressed() {
        if !formValidation() {
            addEventDatabaseInstant()
        }
    }
    
    func didClickOnOption(type: Int) {
        bottomSheetView = CustomBottomSheetView(type: type)
        bottomSheetView!.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView!.delegate = self
        bottomSheetView!.alpha = 0.0
        self.view.addSubview(bottomSheetView!)
        NSLayoutConstraint.activate([
            bottomSheetView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomSheetView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            bottomSheetView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomSheetView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView!.alpha = 1.0
        }
    }
    
    func backButtonPressed() {
        if bottomSheetView != nil {
            bottomSheetView!.removeFromSuperview()
            bottomSheetView!.delegate = nil
            bottomSheetView = nil
        }
    }
    
    func didCustomBottomSheetPressed(name: String, type: Int) {
        backButtonPressed()
        
        let textField: UITextField? = {
            switch type {
            case 1: return colorTextField
            case 2: return eventTypeTextField
            case 3: return reminderTextField
            default: return nil
            }
        }()
            
        textField?.text = name
    }
    
    @objc func startDoneButtonTapped() {
        startTimeTextField!.resignFirstResponder()
        if startTimeTextField!.text!.isEmpty {
            startTimeTextField!.text = AppUtils.dateToTimeFormatAsString(date: Date())
        }
    }
    
    @objc func startCancelButtonTapped() {
        startTimeTextField!.resignFirstResponder()
        if startTimeTextField!.text!.isEmpty {
            startTimeTextField!.text = ""
        }
    }
    
    @objc func endDoneButtonTapped() {
        endTimeTextField!.resignFirstResponder()
        if endTimeTextField!.text!.isEmpty {
            endTimeTextField!.text = AppUtils.dateToTimeFormatAsString(date: Date())
        }
    }
    
    @objc func endCancelButtonTapped() {
        endTimeTextField!.resignFirstResponder()
        if endTimeTextField!.text!.isEmpty {
            endTimeTextField!.text = ""
        }
    }
    
    @objc func dateDoneButtonTapped() {
        dateTextField!.resignFirstResponder()
        if dateTextField!.text!.isEmpty {
            dateTextField!.text = AppUtils.dateToDateFormatAsString(date: Date())
        }
    }
    
    @objc func dateCancelButtonTapped() {
        dateTextField!.resignFirstResponder()
        if dateTextField!.text!.isEmpty {
            dateTextField!.text = ""
        }
    }
    
    @objc func contactDoneButtonTapped() {
        contactTextField!.resignFirstResponder()
    }
    
    @objc func contactCancelButtonTapped() {
        contactTextField!.resignFirstResponder()
    }
    
    @objc func noteDoneButtonTapped() {
        notesView!.resignFirstResponder()
    }
    
    @objc func noteCancelButtonTapped() {
        notesView!.resignFirstResponder()
    }
    
    @objc func leftkButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        // Change the title based on the scroll position with animation
//        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//            if yOffset > 100 { // Adjust the threshold as needed
//                self.navigationBar?.topItem?.largeTitleDisplayMode = .never
//                self.navigationBar?.topItem?.title = "Add Event"
//            } else {
//                self.navigationBar?.topItem?.largeTitleDisplayMode = .always
//                self.navigationBar?.topItem?.title = "Add Event"
//            }
//        }
//    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // Get the keyboard's height
            let keyboardHeight = keyboardFrame.height
            
            // Adjust the content inset and scroll indicator insets of the scroll view
            var contentInset = scrollView!.contentInset
            contentInset.bottom = keyboardHeight
            scrollView!.contentInset = contentInset
            scrollView!.scrollIndicatorInsets = contentInset
            
            // Scroll to the active text field
            if let activeField = findActiveTextField() {
                var aRect = self.view.frame
                aRect.size.height -= keyboardHeight
                if !aRect.contains(activeField.frame.origin) {
                    scrollView!.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        // Reset the content inset when the keyboard hides
        let contentInset = UIEdgeInsets.zero
        scrollView!.contentInset = contentInset
        scrollView!.scrollIndicatorInsets = contentInset
    }

    func findActiveTextField() -> UITextField? {
        if eventNameTextField!.isFirstResponder {
            return eventNameTextField
        } else if startTimeTextField!.isFirstResponder {
            return startTimeTextField
        } else if endTimeTextField!.isFirstResponder {
            return endTimeTextField
        } else if dateTextField!.isFirstResponder {
            return dateTextField
        } else if reminderTextField!.isFirstResponder {
            return reminderTextField
        } else if locationTextField!.isFirstResponder {
            return locationTextField
        } else if eventTypeTextField!.isFirstResponder {
            return eventTypeTextField
        } else if colorTextField!.isFirstResponder {
            return colorTextField
        } else if contactTextField!.isFirstResponder {
            return contactTextField
        }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == colorTextField {
            colorTextField!.resignFirstResponder()
            didClickOnOption(type: 1)
        }else if textField == locationTextField {
            locationTextField!.resignFirstResponder()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if textField == reminderTextField {
            reminderTextField!.resignFirstResponder()
            didClickOnOption(type: 3)
        }else if textField == eventTypeTextField {
            eventTypeTextField!.resignFirstResponder()
            didClickOnOption(type: 2)
        }
    }
    
    func didPickLocationAsString(location: String) {
        locationTextField?.text = location
    }
    
    func formValidation() -> Bool {
        var message = ""
        var tag = ""
        if eventNameTextField!.text!.isEmpty {
            message = "Event Title Required"
            tag = "titleTag"
        }else if startTimeTextField!.text!.isEmpty {
            message = "Event Start Time Required"
            tag = "startTag"
        }else if endTimeTextField!.text!.isEmpty {
            message = "Event End Time Required"
            tag = "endTag"
        }else if dateTextField!.text!.isEmpty {
            message = "Event Date Required"
            tag = "dateTag"
        }else if reminderTextField!.text!.isEmpty {
            message = "Event Reminder Required"
            tag = "reminderTag"
        }else if locationTextField!.text!.isEmpty {
            message = "Event Location Required"
            tag = "locationTag"
        }else if eventTypeTextField!.text!.isEmpty {
            message = "Event Type Required"
            tag = "typeTag"
        }else if colorTextField!.text!.isEmpty {
            message = "Event Color Required"
            tag = "colorTag"
        }else if contactTextField!.text!.isEmpty {
            message = "Event Contact Required"
            tag = "contactTag"
        }else if notesTextView!.text!.isEmpty && notesTextView!.text == "Note..." {
            message = "Event Note Required"
            tag = "noteTag"
        }
        
        if !message.isEmpty {
            loadAlertView(title: "Empty Field", message: message, tag: [tag])
        }
        return !message.isEmpty
    }
    
    func loadAlertView(title: String, message: String, tag: [String]) {
        unloadAlertView()
        alertView = AvoxAlertView(title: title, message: message, tag: tag, target: self)
        alertView!.delegate = self
    }
    
    func unloadAlertView() {
        if alertView != nil {
            alertView!.removeFromSuperview()
            alertView = nil
        }
    }
    
    func clickOnPositiveButton(tag: String) {
        unloadAlertView()
        if tag == "titleTag" {
            
        }
    }
    
    private func addToolBar(cancelSelector: Selector,doneSelector: Selector) -> UIToolbar {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        numberToolbar.barStyle = .default
        numberToolbar.barTintColor = .lightGray
        numberToolbar.tintColor = .white
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelSelector),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: doneSelector)
        ]
        numberToolbar.sizeToFit()
        return numberToolbar
    }
    
    private func addDatePicker(selector: Selector, isTime: Bool) -> UIDatePicker {
        let datePickerView = UIDatePicker()
        if isTime {
            datePickerView.datePickerMode = .time
        }else{
            datePickerView.datePickerMode = .date
            datePickerView.minimumDate = Date()
        }
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        datePickerView.addTarget(self, action: selector, for: .valueChanged)
        return datePickerView
    }
    
    @objc func handleStartTimePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        startTimeTextField!.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleEndTimePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        endTimeTextField!.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateTextField!.text = dateFormatter.string(from: sender.date)
    }
    
    func setBackView(_ height: CGFloat, view: UIStackView? = nil) -> UIView {
        let stackView = view ?? stackView
        let uIView = UIView()
        uIView.translatesAutoresizingMaskIntoConstraints = false
        uIView.backgroundColor = Helper.Color.bgSecondary
        AppUtils.applyBorderOnView(view: uIView, radius: constant)
        uIView.layer.masksToBounds = false
        stackView!.addArrangedSubview(uIView)
        NSLayoutConstraint.activate([
            uIView.heightAnchor.constraint(equalToConstant: height)
        ])
        return uIView
    }
    
    func setTextView(_ view: UIView, title: String, placeholder: String) -> UITextView {
        let uILabel = UILabel()
        uILabel.translatesAutoresizingMaskIntoConstraints = false
        uILabel.text = title
        uILabel.textColor = Helper.Color.textPrimary
        uILabel.backgroundColor = UIColor.clear
        uILabel.font = UIFont.appFontMedium(ofSize: fontSize*0.8)
        view.addSubview(uILabel)
        NSLayoutConstraint.activate([
            uILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            uILabel.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        ])
        
        let uITextView = UITextView()
        uITextView.translatesAutoresizingMaskIntoConstraints = false
        uITextView.text = placeholder
        uITextView.font = UIFont.appFontRegular(ofSize: fontSize*0.9)
        uITextView.textColor = Helper.Color.textSecondary
        uITextView.backgroundColor = UIColor.clear
        uITextView.isEditable = true
        uITextView.isSelectable = true
        uITextView.delegate = self
        view.addSubview(uITextView)
        NSLayoutConstraint.activate([
            uITextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant*0.5),
            uITextView.widthAnchor.constraint(equalTo: view.widthAnchor),
            uITextView.topAnchor.constraint(equalTo: uILabel.bottomAnchor),
            uITextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return uITextView
    }
    
    func setTextField(_ view: UIView, title: String, placeholder: String) -> UITextField {
        let uILabel = UILabel()
        uILabel.translatesAutoresizingMaskIntoConstraints = false
        uILabel.text = title
        uILabel.textColor = Helper.Color.textPrimary
        uILabel.backgroundColor = UIColor.clear
        uILabel.font = UIFont.appFontMedium(ofSize: fontSize*0.8)
        view.addSubview(uILabel)
        NSLayoutConstraint.activate([
            uILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            uILabel.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        ])
        
        let uITextField = UITextField()
        uITextField.translatesAutoresizingMaskIntoConstraints = false
        uITextField.borderStyle = .none
        uITextField.textColor = Helper.Color.textSecondary
        uITextField.backgroundColor = UIColor.clear
        uITextField.font = UIFont.appFontRegular(ofSize: fontSize*0.9)
        uITextField.delegate = self
        uITextField.keyboardType = .default
        uITextField.autocapitalizationType = .words
        uITextField.autocorrectionType = .no
        uITextField.attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: placeholder), attributes: [NSAttributedString.Key.font: UIFont.appFontLight(ofSize: fontSize*0.9) as Any])
        view.addSubview(uITextField)
        NSLayoutConstraint.activate([
            uITextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            uITextField.topAnchor.constraint(equalTo: uILabel.bottomAnchor),
            uITextField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return uITextField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contactTextField {
            let curruntCharachterCount = textField.text?.count ?? 0
            if range.length + range.location > curruntCharachterCount{
                return false
            }
            let newLength = curruntCharachterCount + string.count - range.length
            return newLength <= 10
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Note..." {
            textView.text = ""
            textView.textColor = Helper.Color.textPrimary
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Note..."
            textView.textColor = .lightGray
        }
    }
    
    func addEventDatabaseInstant() {
        let addEvent = EventData(context: DatabaseManager.share.context)
        addEvent.id = UUID().uuidString
        addEvent.title = eventNameTextField!.text
        addEvent.startTime = startTimeTextField!.text
        addEvent.endTime = endTimeTextField!.text
        addEvent.date = dateTextField!.text
        addEvent.reminder = reminderTextField!.text
        addEvent.location = locationTextField!.text
        addEvent.type = eventTypeTextField!.text
        addEvent.color = colorTextField!.text
        addEvent.contact = contactTextField!.text
        addEvent.note = notesTextView!.text
        DatabaseManager.share.saveContext()
    }
}
