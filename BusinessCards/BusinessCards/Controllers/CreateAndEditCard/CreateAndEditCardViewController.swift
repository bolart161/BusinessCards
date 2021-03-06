//
//  ViewController.swift
//  BusinessCards
//
//  Created by Artem on 15/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

class CreateAndEditCardViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet private var scrollView: UIScrollView!
    // neccessary fields
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var surnameField: UITextField!
    @IBOutlet private var phoneField: UITextField!
    @IBOutlet private var categoryField: UITextField!
    // unneccessary fields
    @IBOutlet private var middleNameField: UITextField!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var companyField: UITextField!
    @IBOutlet private var addressField: UITextField!
    @IBOutlet private var websiteField: UITextField!
    @IBOutlet private var descriptionField: UITextView!
    @IBOutlet private var addImageButtonOutlet: UIButton! {
            didSet {
                addImageButtonOutlet.imageView?.contentMode = .scaleAspectFill
            }
    }
    private let categoryPicker = UIPickerView()
    private let cards = DBService<CardRecord>()
    private let categories = DBService<CategoryRecord>()
    private lazy var categoriesList = categories.getAll(sortBy: .name, ascending: true)
    private var isMy: Bool = false {
        didSet {
            let predicate = NSPredicate(format: "isMy == %d", self.isMy as CVarArg)
            self.categoriesList = self.categoriesList.filter(predicate)
            self.categoryPicker.reloadAllComponents()
        }
    }
    private var card: CardRecord?
    private var category: CategoryRecord?
    private var cardNetworkService = CardNetworkService()
    private var imagePicker = UIImagePickerController()
    private var imageWasChanged: Bool = false
    private var url: String = ""

    @IBAction private func addImageButton(_ sender: Any) {
        self.present(self.imagePicker, animated: true)
    }

    @IBAction private func saveButton(_ sender: Any) {
        // check necessary fields
        // swiftlint:disable:next empty_string
        if nameField.text == "" || surnameField.text == "" || phoneField.text == "" || categoryField.text == "" {
            let alert = UIAlertController(title: "Невозможно сохранить изменения", message: "Заполните все обязательные поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))

            self.present(alert, animated: true)
            return
        }

        var textInfo = getInfo()

        // check phoneField.text is a number
        guard let phone = textInfo[.phone] else { return }
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phone)) {
            let alert = UIAlertController(title: "Некорректный номер телефона", message: "Допустимы только цифры", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        // check category
        // swiftlint:disable:next implicitly_unwrapped_optional
        var category: CategoryRecord!
        guard let categoryName = categoryField.text else { return }
        if let categoryRecord = categories.get(field: .name, value: categoryName).first {
            category = categoryRecord
        } else {
            let alert = UIAlertController(title: "Категории с таким именем не существует", message: "Создать?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Создать", style: .default) { _ in
                category = CategoryRecord(name: categoryName, isMy: self.isMy)
                self.categories.add(category)
            }
            )
            self.present(alert, animated: true)
            return
        }

        // if edit card
        if let card = self.card {
            let alert = UIAlertController(title: "Сохранить изменения?", message: "Данное действие нельзя отменить", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отменить", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { _ in
                self.cards.edit(data: card, value: textInfo)
                self.cards.edit(data: card, value: [.category: category])
                _ = self.navigationController?.popViewController(animated: true)
            }
            )

            self.present(alert, animated: true)
            return
        }

        // swiftlint:disable:next force_unwrapping
        cards.add(CardRecord(name: textInfo[.name]!, surname: textInfo[.surname]!, phone: textInfo[.phone]!, category: category, info: textInfo))
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction private func cancelButton(_ sender: Any) {
        let alert = UIAlertController(title: "Отменить редактирование?", message: "Данные не будут сохранены", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отменить", style: .destructive) { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        )
        alert.addAction(UIAlertAction(title: "Вернуться", style: .default, handler: nil))

        self.present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createCategoryPicker()
        configImagePicker()
        createToolbar()
        makeTextViewBorders()
        fillInfo()
        let moreActionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(tappedMore))
        navigationItem.rightBarButtonItem = moreActionButton
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func tappedMore() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVCEditAndCreateView")
            as? ActionsTableViewControllerCreateAndEdit else { return }
        popVC.modalPresentationStyle = .popover

        let popOverVC = popVC.popoverPresentationController

        popOverVC?.delegate = self
        popOverVC?.barButtonItem = navigationItem.rightBarButtonItems?.first
        popVC.preferredContentSize = CGSize(width: 200, height: 100)
        self.present(popVC, animated: true)
    }

    @objc private func keyboard(notification: Notification) {
        let userInfo = notification.userInfo
        // swiftlint:disable:next force_cast
        let keyboardScreenEndFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func createCategoryPicker() {
        self.categoryPicker.delegate = self
        self.categoryField.inputView = categoryPicker
    }

    private func configImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
    }

    private func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateAndEditCardViewController.dismissKeyboard))

        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        nameField.inputAccessoryView = toolBar
        surnameField.inputAccessoryView = toolBar
        phoneField.inputAccessoryView = toolBar
        categoryField.inputAccessoryView = toolBar
        middleNameField.inputAccessoryView = toolBar
        emailField.inputAccessoryView = toolBar
        companyField.inputAccessoryView = toolBar
        addressField.inputAccessoryView = toolBar
        websiteField.inputAccessoryView = toolBar
        descriptionField.inputAccessoryView = toolBar
    }

    private func makeTextViewBorders() {
        let customLightGray = UIColor.lightGray.cgColor
        customLightGray.copy(alpha: 0.95)
        descriptionField.layer.borderColor = customLightGray
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setCardRecord(card: CardRecord) {
        self.card = card
    }

    func setUrl(url: String) {
        self.url = url
    }

    func isMyFlag(isMy: Bool) {
        self.isMy = false
    }

    func setCategory(category: CategoryRecord) {
        self.category = category
        self.isMy = category.isMy
    }

    // swiftlint:disable:next cyclomatic_complexity 
    private func fillInfo() {
        if !self.url.isEmpty {
            cardNetworkService.getCardFromAPI(url: self.url) { cardFromAPI in
                self.middleNameField.text = cardFromAPI.value.middleName
                self.companyField.text = cardFromAPI.value.company
                self.addressField.text = cardFromAPI.value.address
                self.emailField.text = cardFromAPI.value.email
                self.websiteField.text = cardFromAPI.value.website
                self.nameField.text = cardFromAPI.value.name
                self.surnameField.text = cardFromAPI.value.surname
                self.phoneField.text = cardFromAPI.value.phone
                self.url = ""
            }
            return
        }
        if let category = self.category {
            categoryField.text = category.name
        }
        guard let card = self.card else { return }
        nameField.text = card.name
        surnameField.text = card.surname
        phoneField.text = card.phone
        categoryField.text = card.category?.name

        if let middleName = card.middleName {
            middleNameField.text = middleName
        }
        if let company = card.company {
            companyField.text = company
        }
        if let email = card.email {
            emailField.text = email
        }
        if let address = card.address {
            addressField.text = address
        }
        if let website = card.website {
            websiteField.text = website
        }
        if let description = card.descriptionText {
            descriptionField.text = description
        }
        if let imagePath = card.imagePath {
            if let image = ImageService().get(imagePath: imagePath) {
                addImageButtonOutlet.setImage(image, for: .normal)
            }
        }
    }

    private func getInfo() -> [String: String] {
        var textInfo: [String: String] = [:]
        textInfo[.name] = nameField.text?.trimmingCharacters(in: .whitespaces)
        textInfo[.surname] = surnameField.text?.trimmingCharacters(in: .whitespaces)
        textInfo[.phone] = phoneField.text?.trimmingCharacters(in: .whitespaces)

        if let middleName = middleNameField.text?.trimmingCharacters(in: .whitespaces), !middleName.isEmpty {
            textInfo[.middleName] = middleName
        }
        if let email = emailField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty {
            textInfo[.email] = email
        }
        if let company = companyField.text?.trimmingCharacters(in: .whitespaces), !company.isEmpty {
            textInfo[.company] = company
        }
        if let address = addressField.text?.trimmingCharacters(in: .whitespaces), !address.isEmpty {
            textInfo[.address] = address
        }
        if let website = websiteField.text?.trimmingCharacters(in: .whitespaces), !website.isEmpty {
            textInfo[.website] = website
        }
        if let description = descriptionField.text?.trimmingCharacters(in: .whitespaces), !description.isEmpty {
            textInfo[.descriptionText] = description
        }
        if imageWasChanged, let image = addImageButtonOutlet.imageView?.image {
            textInfo[.imagePath] = ImageService().save(image: image)
        }
        return textInfo
    }
}

extension CreateAndEditCardViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesList[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categoriesList[row].name
    }
}

extension CreateAndEditCardViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageButtonOutlet.setImage(image, for: .normal)
            imageWasChanged = true
        } else {
            print("Picking image failed")
        }

        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateAndEditCardViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
