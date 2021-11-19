//
//  ListViewController.swift
//  TxMaster
//
//  Created by Ramanan on 11/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    //var listVM = ListViewModel.shared
    
    var viewVM = ViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       //listVM.loadData()
        
        title = "List"
        
        RxTable()
    }
    
    
   func RxTable(){
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Any>> { dataSource, table, indexPath, dataSourceItem in
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = dataSourceItem as? String
        return cell!
    }
    titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
    }
    
    viewVM.totalSectionList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    
       // when using "ListViewModel"
    //listVM.totalList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    
   }

  

}
