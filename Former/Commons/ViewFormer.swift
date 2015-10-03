//
//  HeaderFooterFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/26/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableView: class {
    
    func updateWithViewFormer(viewFormer: ViewFormer)
}

public class ViewFormer {
    
    // MARK: Public
    
    public final lazy var view: UITableViewHeaderFooterView = { [unowned self] in
        var view: UITableViewHeaderFooterView?
        switch self.instantiateType {
        case .Class:
            view = self.viewType.init(reuseIdentifier: nil)
        case .Nib(nibName: let nibName, bundle: let bundle):
            let bundle = bundle ?? NSBundle.mainBundle()
            view = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewHeaderFooterView
            assert(view != nil, "[Former] Failed to load header footer view from nib (\(nibName)).")
        }
        view!.contentView.backgroundColor = .clearColor()
        self.viewSetup(view!)
        self.viewInitialized(view!)
        return view!
        }()
    public var viewHeight: CGFloat = 10.0
    
    public init<T: UITableViewHeaderFooterView>(
        viewType: T.Type,
        instantiateType: Former.InstantiateType,
        viewSetup: (T -> Void)? = nil) {
            self.viewType = viewType
            self.instantiateType = instantiateType
            self.viewSetup = { viewSetup?(($0 as! T)) }
            initialized()
    }
    
    public func initialized() {}
    
    public func viewInitialized(view: UITableViewHeaderFooterView) {}
    
    public func update() {
        if let formableView = view as? FormableView {
            formableView.updateWithViewFormer(self)
        }
    }
    
    // MARK: Private
    
    private final let viewType: UITableViewHeaderFooterView.Type
    private final let instantiateType: Former.InstantiateType
    private final let viewSetup: (UITableViewHeaderFooterView -> Void)
}