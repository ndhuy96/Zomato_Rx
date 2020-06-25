//
//  RefreshAutoFooter.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/25/20.
//  Copyright © 2020 sun. All rights reserved.
//

import MJRefresh

final class RefreshAutoFooter: MJRefreshAutoFooter {
    var activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray {
        didSet {
            _loadingView = nil
            setNeedsLayout()
        }
    }

    private var _loadingView: UIActivityIndicatorView?

    var loadingView: UIActivityIndicatorView {
        guard let loadingView = _loadingView else {
            let view = UIActivityIndicatorView(style: self.activityIndicatorViewStyle)
            view.hidesWhenStopped = true
            self.addSubview(view)
            _loadingView = view
            return view
        }
        return loadingView
    }

    override func prepare() {
        super.prepare()
        activityIndicatorViewStyle = .gray
    }

    override func placeSubviews() {
        super.placeSubviews()
        let center = CGPoint(x: mj_w * 0.5, y: mj_h * 0.5)
        if loadingView.constraints.isEmpty {
            loadingView.center = center
        }
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                if oldValue == .refreshing {
                    UIView.animate(
                        withDuration: TimeInterval(MJRefreshSlowAnimationDuration),
                        animations: {
                            self.loadingView.alpha = 0
                        }, completion: { _ in
                            self.loadingView.alpha = 1
                            self.loadingView.stopAnimating()
                        }
                    )
                } else {
                    loadingView.stopAnimating()
                }
            case .pulling:
                loadingView.stopAnimating()
            case .refreshing:
                loadingView.startAnimating()
            case .noMoreData:
                loadingView.stopAnimating()
            default:
                break
            }
        }
    }
}
