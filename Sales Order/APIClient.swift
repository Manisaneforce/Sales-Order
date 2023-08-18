//
//  APIClient.swift
//  Sales Order
//
//  Created by San eforce on 17/08/23.
//

import UIKit


class CardView: UIView {
override func layoutSubviews() {
super.layoutSubviews()

layer.cornerRadius = 8.0
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.5
layer.shadowOffset = CGSize(width: 0, height: 2)
layer.shadowRadius = 4.0
}
}
