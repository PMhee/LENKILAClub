//
//  SegueFromRight.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 7/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class SegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,delay: 0.0,options: UIViewAnimationOptions(),animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },completion: {
                finished in src.present(dst, animated: false, completion: nil)
        })
    }
}

