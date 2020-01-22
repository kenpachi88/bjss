//
//  ViewController.swift
//  bjssKennyChen
//
//  Created by NYCDOE on 1/22/20.
//  Copyright © 2020 hireMeKennyChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var products = Products()
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        guard let url = URL(string: "http://bjss-basket.appspot.com/goods") else {return}
        let task = URLSession.shared.productsTask(with: url) {[weak self] (products, response, err) in
            if let products = products {
                self?.products = products
                print(products)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        task.resume()
        tableView.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.size.width, height: 0, enableInsets: true)
               tableView.translatesAutoresizingMaskIntoConstraints = false
               tableView.rowHeight = UITableView.automaticDimension

    }


}
extension ViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ProductViewCell
        print(cell?.productNameLabel.text ?? "hi")
        tableView.delegate?.tableView?(tableView, contextMenuConfigurationForRowAt: tableView.indexPath(for: cell!)!, point: cell!.contentView.center)
    }
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath else { return }
        print(indexPath.count)
        let vc = UIViewController()
        animator.preferredCommitStyle = .pop
        print("preview")
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let product = products[indexPath.row]
        
        print(product.name)
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { suggestedActions in

            // Create an action for sharing
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Sharing \(product)")
            }
            let buy = UIAction(title: "Buy", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Buy \(product)")
            }
            let cancel = UIAction(title: "Cancel", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                print("Cancel \(product)")
            }
            print("second")
            // Create other actions...

            return UIMenu(title: "", children: [share, buy, cancel])
        }
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductViewCell else {return UITableViewCell()}
        cell.productNameLabel.text = products[indexPath.row].name
        cell.productPriceLabel.text = String(products[indexPath.row].price.amount)
        return cell
    }
    
    
}
