//
// Created by majiancheng on 2018/5/28.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

import UIKit

class PlayerCategroiesTableController: MCController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!

    override init(params: Dictionary<String, Any>) {
        super.init(params: params)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataVM = PlayerCategroiesDataVM()

        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PlayerCategroryCell.self, forCellReuseIdentifier: PlayerCategroryCell.identifier())

        self.loadData()
    }

    func loadData() {
        if self.dataVM.isRefresh {
            return
        }
        self.dataVM.refresh()
        self.dataVM.isRefresh = false
        self.tableView.reloadData()
    }

    // MARK: TableViewDataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataVM!.dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCategroryCell.identifier(), for: indexPath) as! PlayerCategroryCell
        cell.loadData(data: self.dataVM!.dataList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dto = self.dataVM!.dataList[indexPath.row] as! PlayerCategroryDto

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlayerCategroryCell.height()
    }
}
