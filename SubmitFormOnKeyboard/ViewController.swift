//
//  ViewController.swift
//  SubmitFormOnKeyboard
//
//  Created by user on 2020/08/25.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!

    @IBOutlet weak var submitForm: UIStackView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitFormBottomConstraints: NSLayoutConstraint!

    var submitFormY:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        //ラベルのレイヤー
        textLabel.layer.borderColor = UIColor.blue.cgColor
        textLabel.layer.borderWidth = 1

        // 通知センターの取得
         let notification =  NotificationCenter.default

         // keyboardのframe変化時
         notification.addObserver(self,
                                  selector: #selector(self.keyboardChangeFrame(_:)),
                                  name: UIResponder.keyboardDidChangeFrameNotification,
                                  object: nil)

         // keyboard登場時
         notification.addObserver(self,
                                  selector: #selector(self.keyboardWillBeShow(_:)),
                                  name: UIResponder.keyboardWillShowNotification,
                                  object: nil)

         // keyboard退場時
         notification.addObserver(self,
                                  selector: #selector(self.keyboardWillBeHide(_:)),
                                  name: UIResponder.keyboardDidHideNotification,
                                  object: nil)
    }

    // キーボードのフレーム変化時の処理
    @objc func keyboardChangeFrame(_ notification: NSNotification) {
        // keyboardのframeを取得
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        // submitFormの最大Y座標と、keybordの最小Y座標の差分を計算
        let diff = self.submitForm.frame.maxY -  keyboardFrame.minY

        if (diff > 0) {
            //submitFormのbottomの制約に差分をプラス
            self.submitFormBottomConstraints.constant += diff + 10
            self.view.layoutIfNeeded()
        }
    }

    // キーボード登場時の処理
    @objc func keyboardWillBeShow(_ notification: NSNotification) {
        // 現在のsubmitFormの最大Y座標を保存
        submitFormY = self.submitForm.frame.maxY
        textField.text = textLabel.text
    }

    //キーボードが退場時の処理
    @objc func keyboardWillBeHide(_ notification: NSNotification) {
        //submitFormのbottomの制約を元に戻す
        self.submitFormBottomConstraints.constant = -submitFormY
        self.view.layoutIfNeeded()
    }

    @IBAction func closeKeyboard(_ sender: Any) {
        // キーボードをしまう
        view.endEditing(true)
    }
    @IBAction func showKeyboard(_ sender: Any) {
        // キーボードを表示
        textField.becomeFirstResponder()
    }
    @IBAction func submitText(_ sender: Any) {
        textLabel.text = textField.text
    }

}

