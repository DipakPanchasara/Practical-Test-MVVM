//
//  CountryVC.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import UIKit
import SKCountryPicker
import FAPanels
class CountryVC: CountryPickerWithSectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the viewsele
        self.setMenuIcon(img: UIImage(named: "ic_menu")!)
        
    }
    func setMenuIcon(img: UIImage) {
        // Setup view bar buttons
        let uiBarButtonItem = UIBarButtonItem(image: img, style:UIBarButtonItem.Style.done, target: self, action: #selector(self.menuClicked))
        
        //(barButtonSystemItem: .stop,
                                              //target: self,
                                           // / / action: #selector(self.crossButtonClicked(_:)))
        
        navigationItem.leftBarButtonItem = uiBarButtonItem
    }
    @objc func menuClicked(){
        
            self.panel?.openLeft(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
