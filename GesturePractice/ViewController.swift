//
//  ViewController.swift
//  GesturePractice
//
//  Created by Javier Porras jr on 10/16/19.
//  Copyright © 2019 Javier Porras jr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var fileViewOrigin: CGPoint!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupViews()
        fileIcon.frame.origin = CGPoint(x: 24, y: 34.0) //already set the anchors, but this will set the origin again, and therefor will be able to be read below.
        fileViewOrigin = fileIcon.frame.origin //CGPoint(x: 24, y: 34.0) //fileIcon.frame.origin
        print(fileIcon.frame.origin)
    }
    
    lazy var trashCan: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TrashCan")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(replaceFile)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var fileIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FileImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:))))
        return imageView
    }()
    
    func setupViews(){
        view.addSubviews(trashCan, fileIcon)
        //addPanGestureTo(view: fileIcon)
        //addTapGestureTo(view: trashCan)
        view.bringSubviewToFront(fileIcon)
        //view.bringSubviewToFront(trashCan)
        
        trashCan.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        trashCan.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        trashCan.widthAnchor.constraint(equalToConstant: 80).isActive = true
        trashCan.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        fileIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 34).isActive = true
        fileIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        fileIcon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        fileIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    //Refactor
    @objc func handlePan(sender: UIPanGestureRecognizer){
        let fileView = sender.view!
        
        switch sender.state {
        case .began, .changed:
            moveViewWithPan(view: fileView, sender: sender)
            break
        case .ended:
            if fileView.frame.intersects(trashCan.frame){
                deleteView(view: fileView)
            }else{
                returnViewToOrigin(view: fileView)
            }
            break
        default:
            break
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer){
        let tranlation = sender.translation(in: view)
        
        view.center = CGPoint(x: view.center.x + tranlation.x, y: view.center.y + tranlation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func returnViewToOrigin(view: UIView){
        UIView.animate(withDuration: 0.3) {
            view.frame.origin = self.fileViewOrigin
        }
    }
    
    func deleteView(view: UIView){
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0.0
        }
    }
    @objc func replaceFile(){
        print("i was pushed")
        
        UIView.animate(withDuration: 0.3) {
            self.fileIcon.alpha = 1.0
            self.fileIcon.frame.origin = self.fileViewOrigin
        }
    }
    
    //this method was never used, becasue I changed the fileIcon to a lazy var which allowed the pan gesture to be added to it during instantiation.
    func addPanGestureTo(view: UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
}
extension UIView{
    func addSubviews(_ views: UIView...){
        views.forEach{self.addSubview($0)}
    }
}

