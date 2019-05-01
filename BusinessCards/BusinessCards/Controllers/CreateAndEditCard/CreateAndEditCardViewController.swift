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
    @IBOutlet private var addImageButtonOutlet: UIButton!
    private let cards = DBService<CardRecord>()
    private let categories = DBService<CategoryRecord>()
    private lazy var categoriesList = DBService<CategoryRecord>().getAll(sortBy: .name, ascending: true)
    private var card: CardRecord?
    private var isMy: Bool = false
    private var imageWasChanged: Bool = false

    @IBAction private func addImageButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }

    @IBAction private func saveButton(_ sender: Any) {
        // swiftlint:disable:next empty_string
        if nameField.text == "" || surnameField.text == "" || phoneField.text == "" || categoryField.text == "" {
            let alert = UIAlertController(title: "Невозможно сохранить изменения", message: "Заполните все обязательные поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))

            self.present(alert, animated: true)
            return
        }

        var textInfo = getInfo()
        var category: CategoryRecord
        if let categoryName = categoryField.text, let categoryRecord = categories.get(field: .name, value: categoryName).first {
            category = categoryRecord
        } else {
            fatalError("No category with the same name: \(String(describing: categoryField.text))")
        }

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
        cards.add(CardRecord(name: textInfo[.name]!, surname: textInfo[.surname]!, phone: textInfo[.phone]!, isMy: isMy, category: category, info: textInfo))
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
        createToolbar()
        makeTextViewBorders()
        fillInfo()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryField.inputView = categoryPicker
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
        isMyFlag(isMy: card.isMy)
    }

    func isMyFlag(isMy: Bool) {
        self.isMy = isMy
    }

    private func fillInfo() {
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
        textInfo[.name] = nameField.text
        textInfo[.surname] = surnameField.text
        textInfo[.phone] = phoneField.text

        if let middleName = middleNameField.text, !middleName.isEmpty {
            textInfo[.middleName] = middleName
        }
        if let email = emailField.text, !email.isEmpty {
            textInfo[.email] = email
        }
        if let company = companyField.text, !company.isEmpty {
            textInfo[.company] = company
        }
        if let address = addressField.text, !address.isEmpty {
            textInfo[.address] = address
        }
        if let website = websiteField.text, !website.isEmpty {
            textInfo[.website] = website
        }
        if let description = descriptionField.text, !description.isEmpty {
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
