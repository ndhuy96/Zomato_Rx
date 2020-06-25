//
//  LoadMoreTableView.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/25/20.
//  Copyright © 2020 sun. All rights reserved.
//

import MJRefresh

final class LoadMoreTableView: UITableView {
    private let _refreshControl = UIRefreshControl()

    var refreshing: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView._refreshControl.beginRefreshing()
            } else {
                if collectionView._refreshControl.isRefreshing {
                    collectionView._refreshControl.endRefreshing()
                }
            }
        }
    }

    var loadingMore: Binder<Bool> {
        return Binder(self) { collectionView, loading in
            if loading {
                collectionView.mj_footer?.beginRefreshing()
            } else {
                collectionView.mj_footer?.endRefreshing()
            }
        }
    }

    var refreshTrigger: Driver<Void> {
        return _refreshControl.rx.controlEvent(.valueChanged).asDriver()
    }

    private var _loadMoreTrigger = PublishSubject<Void>()

    var loadMoreTrigger: Driver<Void> {
        return _loadMoreTrigger.asDriver(onErrorJustReturn: ())
    }

    var refreshFooter: MJRefreshFooter? {
        didSet {
            mj_footer = refreshFooter
            mj_footer?.refreshingBlock = { [weak self] in
                self?._loadMoreTrigger.onNext(())
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(_refreshControl)
        refreshFooter = RefreshAutoFooter()
    }
}
