
//
//  LoginViewController.swift
//  GoChat
//
//  Created by 鄭薇 on 2016/12/4.
//  Copyright © 2016年 LilyCheng. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var Name: UITextField!
    
    let uuid: String =  UIDevice.current.identifierForVendor!.uuidString
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("我裝置的uuid: \(uuid)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        print(FIRAuth.auth()?.currentUser)
        //        FIRAuth.auth()?.addStateDidChangeListener({(auth:FIRAuth, user:FIRUser?)in
        //            if user !=nil{
        //                print(user)
        //                Helper.helper.switchToNavigationViewController()
        //            }else{
        //                print("Unauthorized")
        //            }
        //        })
        print("現在這人的uid是: \(FIRAuth.auth()?.currentUser?.uid)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NickNameButton(_ sender: Any) {
        if Name?.text != "" {
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if error != nil{
                    print("create user error " + error!.localizedDescription)
                }else{
                    print("我的暱稱是: " + self.Name.text!)

                    let userName: String = self.Name.text!
//                    let userId:String = (FIRAuth.auth()?.currentUser?.uid)!
                    let userRef = FIRDatabase.database().reference().child("TripGifUsers")
                    print((FIRAuth.auth()?.currentUser?.uid)!)
                    //新增User到資料庫
//                    let newUser = userRef.childByAutoId()
                    let newUser = userRef.child(self.uuid).child("NickName")
//                    let newUserData = ["NickName":userName]
                    newUser.setValue(userName)
                }
            })
        }else{
            //創建失敗小視窗
            let alert = UIAlertController(title: "請務必輸入暱稱", message: "您輸入的名字會作為同夥模式暱稱", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginToApp"){
            super.prepare(for: segue, sender: sender)
            let navVc = segue.destination as! UINavigationController // 1
            let roomVc = navVc.viewControllers.first as! RoomsViewController // 2
            roomVc.senderDisplayName = (Name?.text)! // 3
        }
    }
}
