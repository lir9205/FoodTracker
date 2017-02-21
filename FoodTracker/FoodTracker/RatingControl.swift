//
//  RatingControl.swift
//  FoodTracer
//
//  Created by 李芮 on 17/2/20.
//  Copyright © 2017年 7feel. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK:- Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    
    @IBInspectable var starSize: CGSize = CGSizeMake(40, 40) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK:- Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = NSBundle(forClass: self.dynamicType)
        _ = UINib(nibName: String(RatingControl), bundle: bundle)
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bundle = NSBundle(forClass: self.dynamicType)
        _ = UINib(nibName: String(RatingControl), bundle: bundle)
        setupButtons()
    }
    
    //MARK:- Private Methods
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let filedStar = UIImage(named: "rate-s", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        let emptyStar = UIImage(named: "rate-n", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        let highlighedStar = UIImage(named: "rate-s", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()

            button.setImage(emptyStar, forState: .Normal)
            button.setImage(filedStar, forState: .Selected)
            button.setImage(highlighedStar, forState: .Highlighted)
            button.setImage(highlighedStar, forState: [.Highlighted,.Selected])
            //UIStackView 会自动定义button的位置，我们需要添加约束来定义button的大小
            //translatesAutoresizingMaskIntoConstraints 表示是否自动生成约束，当你使用程序初始化一个View时，它的 translatesAutoresizingMaskIntoConstraints 属性默认是 true，当不需要时可设为 false。
            //在这里可以不用手动设为false，因为往stackView上天剑View，stackView会自动将translatesAutoresizingMaskIntoConstraints设置为false。当使用自动布局的时候，将translatesAutoresizingMaskIntoConstraints设置为false是一个良好的习惯。
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraintEqualToConstant(starSize.width).active = true
            button.heightAnchor.constraintEqualToConstant(starSize.height).active = true
            
            //添加附加标签
            button.accessibilityLabel  = "Set \(index + 1) star rating"
            
            button.addTarget(self, action: #selector(ratingButtonTapped), forControlEvents:UIControlEvents.TouchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //MARK:- Button Action
    
    func ratingButtonTapped(button: UIButton) {
        print("button tapped")
        
        guard let index = ratingButtons.indexOf(button) else {
            fatalError("The button, \(button) is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
        
        
        
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
           
            button.selected =  index < rating
            
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            let valueString: String
            
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
    }
}
