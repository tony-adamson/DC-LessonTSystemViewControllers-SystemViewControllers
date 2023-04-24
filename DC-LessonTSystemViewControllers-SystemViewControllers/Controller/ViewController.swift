//
//  ViewController.swift
//  DC-LessonTSystemViewControllers-SystemViewControllers
//
//  Created by Антон Адамсон on 24.04.2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

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
        //создаем экземпляр класса UIAlertController содержащий заголовок и тп
        let alertController = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        //создаем экземпляры класса UIAlertAction
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //экземпляр с кодом замыкания, которое будет выполнено при выборе
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            print("User selected Camera action")
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            print("User selected Photo Library action")
        }
        
        //добавляем в alertController 3 кнопки
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        //добавляем функциональность для больших экранов
        alertController.popoverPresentationController?.sourceView = sender
        // выводим alertController на экран через present
        present(alertController, animated: true)
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
    }
    
}

