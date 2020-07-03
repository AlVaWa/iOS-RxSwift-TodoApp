//
//  TaskListViewController.swift
//  RxSwift-TodoList
//
//  Created by Aleksander Waage on 03/07/2020.
//  Copyright © 2020 Waageweb. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var prioritySegmentedControll: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        print("priorityValueChanged")
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex-1)
        filterTasks(by: priority)
    }
    
    // Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let addTaskVC = navC.viewControllers.first as? AddTaskViewController else {
                fatalError("Controller not found...")
        }
        
        addTaskVC.taskSubjectObservable.subscribe( onNext: { [unowned self] task in
            
            let priority = Priority(rawValue: self.prioritySegmentedControll.selectedSegmentIndex-1 )
            
            var exsistingTasks = self.tasks.value
            exsistingTasks.append(task)
            self.tasks.accept(exsistingTasks)
            self.filterTasks(by: priority)

        }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter {$0.priority == priority!}
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
                }).disposed(by: disposeBag)
        }
        print("FilterTasks by prioirty: \(priority)")
        print("Tasks: \(self.filteredTasks)")
    }
    
    private func updateTableView(){
        DispatchQueue.main.async {
            print("Update tabelview")
            self.tableView.reloadData()
        }
    }
}
