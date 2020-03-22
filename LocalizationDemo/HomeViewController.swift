//
//  HomeViewController.swift
//  LocalizedApp
//
//  Created by Naiyer Aghaz on 12/11/19.
//  Copyright © 2019 Naiyer Aghaz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnSettingTapped(_ sender: Any)  {
        let alertC = UIAlertController(title: "Change your language", message: "", preferredStyle: .alert)
        let eng = UIAlertAction(title: "English", style: .default) { (alert) in
            Bundle.setLanguage("en")
            UserDefaults.standard.set("en", forKey: "selectedLanguage")
            self.navigationController?.popToRootViewController(animated: true)
        }
        let spanish = UIAlertAction(title: "Spanish", style: .default) { (alert) in
            UserDefaults.standard.set("es", forKey: "selectedLanguage")
            Bundle.setLanguage("es")
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertC.addAction(eng)
        alertC.addAction(spanish)
        self.present(alertC, animated: true, completion: nil)
    }
    
}

//MARK: Localization configure bundle
extension Bundle {
    class func setLanguage(_ language: String) {
        var onceToken: Int = 0
        
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            object_setClass(Bundle.main, PrivateBundle.self)
        }
        onceToken = 1
        objc_setAssociatedObject(Bundle.main, &associatedLanguageBundle, (language != nil) ? Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "") : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
private var associatedLanguageBundle:Character = "0"

class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle: Bundle? = objc_getAssociatedObject(self, &associatedLanguageBundle) as? Bundle
        return (bundle != nil) ? (bundle!.localizedString(forKey: key, value: value, table: tableName)) : (super.localizedString(forKey: key, value: value, table: tableName))
    }
}

