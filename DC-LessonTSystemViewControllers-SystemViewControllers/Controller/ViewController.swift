//
//  ViewController.swift
//  DC-LessonTSystemViewControllers-SystemViewControllers
//
//  Created by Антон Адамсон on 24.04.2023.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    //UIImagePickerControllerDelegate передаст информацию о выбранном изображении обратно в приложение.
    //UINavigationControllerDelegate будет отвечать за закрытие представления выбора изображения.
    //MFMailComposeViewControllerDelegate отвечает за закрытие контроллера создания почтового сообщения в нужный момент

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        //защита от неполучения изображения
        guard let image = imageView.image else { return }
        
        //создаем экземпляр класса UIActivityViewController
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // вызываем всплывающее окно при нажатии на кнопку - кнопка выстыпает чем то вроде источника. но эта строка для устройств с большими диагоналями. на телефонах можно обойтись без нее
        activityController.popoverPresentationController?.sourceView = sender
        // выводим его на экран через present
        present(activityController, animated: true)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        //если мы смогли создать экземпляр класса URL с параметрами то:
        if let url = URL(string: "https://www.apple.com") {
            //можем создать экземпляр класса SFSafariViewController в который передадим нашу ссылку
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        //создаем экземпляр класса UIImagePickerController
        let imagePicker = UIImagePickerController()
        //пусть экземпляр будет делагатом
        imagePicker.delegate = self
        
        //создаем экземпляр класса UIAlertController содержащий заголовок и тп
        let alertController = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        //создаем экземпляры класса UIAlertAction
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //добавляем в alertController кнопку
        alertController.addAction(cancelAction)
        
        //проверяем доступность источника данных - камера телефона
        //ОБЯЗАТЕЛЬНО добавить в info.plist ключ NSCameraUsageDescription со значением строки - поясняющей пользователю, как приложение использует эти данные и зачем ему нужен доступ к камере
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //если доступен то создаем экземпляр класса с замыканием при выборе
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                //замыкание присваивает источнику данных экземпляра класса - камеру
                imagePicker.sourceType = .camera
                //и показывает это
                self.present(imagePicker, animated: true)
            }
            //добавляем эту кнопку в alertController
            alertController.addAction(cameraAction)
        }
        
        //аналогично предыдущему
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        //добавляем функциональность для больших экранов
        alertController.popoverPresentationController?.sourceView = sender
        
        // выводим alertController на экран через present
        present(alertController, animated: true)
        
    }

    //метод для получения выбранного фото из библиотеки изображений устройства
    //штатная функция swift
    //Этот метод сообщает делегату, что пользователь выбрал фото (или другой медиа-контент), и включает фото в словарь info
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Так как словарь info имеет тип [UIImagePickerController.InfoKey: Any], то значение для ключа originalImage не будет иметь тип UIImage. Необходимо привести тип значения к типу UIImage
        //защита. если мы можем создать экземпляр из info[.originalImage] и привести к типу UIImage то:
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        //то можем обновить изображение в imageView
        imageView.image = selectedImage
        //и закроем выбор изображения
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        //проверка по библиотеке MessageUI на возможность отправки сообщений устройством пользователя, если такой возможности нет, выйти из функции
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail")
            return
        }
        
        //создаем экземпляр класса
        let mailComposer = MFMailComposeViewController()
        //и назначаем его делегатом
        mailComposer.mailComposeDelegate = self
        
        //назначаем кому отправится письмо
        mailComposer.setToRecipients(["example@example.com"])
        //устанавливаем тему
        mailComposer.setSubject("Look at this")
        //заполняем поле с сообещением
        //sHTML - Bool для проверки, должен ли ваше сообщение интерпретироваться как простой текст или HTML. В этом электронном письме вы не будете отправлять HTML, поэтому параметр isHTML установлен в false.
        mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false)
        
        //если в imageView.image есть изображение и мы можем сжать изображение то
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9) {
            //добавим вложение в письмо, установим тип и имя для файла
            mailComposer.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        
        //и наконец представим это пользователю
        present(mailComposer, animated: true, completion: nil)
    }
    
    //штатная функция swift чтобы закрыть контроллер составления письма и вернуться в приложение
    //Этот метод вызывается после отправки или отмены отправки письма пользователем. Здесь вы можете проверить значение result, чтобы определить, было ли письмо отправлено успешно, а error содержит любые ошибки, которые могли возникнуть при отправке. 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
    
}

