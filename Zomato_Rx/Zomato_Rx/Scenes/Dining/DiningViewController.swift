//
//  DiningViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class DiningViewController: UIViewController {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var cuisineTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        locationButton.titleLabel?.numberOfLines = 1
        locationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        locationButton.titleLabel?.lineBreakMode = .byClipping

        cuisineTableView.delegate = self
        cuisineTableView.dataSource = self
    }
}

extension DiningViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CuisineCell.self)
        cell.configCell()
        return cell
    }
}
