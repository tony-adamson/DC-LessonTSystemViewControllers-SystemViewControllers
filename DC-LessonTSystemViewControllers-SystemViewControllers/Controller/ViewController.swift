//
//  ViewController.swift
//  DC-LessonTSystemViewControllers-SystemViewControllers
//
//  Created by Антон Адамсон on 24.04.2023.
//

import UIKit

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
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
    }
    
}

