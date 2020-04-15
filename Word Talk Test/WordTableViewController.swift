//
//  WordTableViewController.swift
//  Word Talk Test
//
//  Created by Jack Vaughn on 4/14/20.
//  Copyright © 2020 vaughn0523. All rights reserved.
//

import UIKit

class WordTableViewController: UIViewController {
    
    class superUITableView : UITableView {
        override func cellForRow(at indexPath: IndexPath) -> WordTableViewCell {
            return super.cellForRow(at: indexPath) as! WordTableViewCell
        }
    }
    
    @IBOutlet weak var wordTableView: superUITableView!
    @IBOutlet weak var addWordButton: UIButton!
    
    
//    var words = [String]()

    var defaults = UserDefaults.standard
    lazy var words = defaults.object(forKey: "words") as! [String]
    
    @IBAction func addWordButtonPrewssed(_ sender: Any) {
//        addNewWord()
        print("Buttom pressed")
//        pleaseWork()
        
        addNewWord()
        var topDog = wordTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        topDog.textField.isEnabled = true
        topDog.textField.becomeFirstResponder()
    }
    
    @IBAction func doneWIthEditing(_ sender: Any) {
//        var topDog = wordTableView.cellForRow(at: IndexPath(row: 0, section: 0))
//        topDog.textField.resignFirstResponder()
//        words[0] = topDog.textField.text!
        var word = (sender as! UIView).superview!.superview as! WordTableViewCell
        words[wordTableView.indexPath(for: word)!.row] = word.textField.text!
        wordTableView.reloadData()
        defaults.set(words, forKey: "words")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wordTableView.tableFooterView = UIView(frame: CGRect.zero)
//        loadWords()
    }
    
    private func loadWords() {
        let word1 = "Mom"
        let word2 = "Dad"
        let word3 = "love"
        
        words += [word1, word2, word3]
    }
    
    private func addNewWord() {
        words.insert("", at: 0)
        wordTableView.reloadData()
        
//        let indexPath = IndexPath(row: words.count - 1, section: 0)
//
//        wordTableView.beginUpdates()
//        wordTableView.insertRows(at: [indexPath], with: .automatic)
//        wordTableView.endUpdates()
    }
}

extension WordTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func pleaseWork() {
//        self.tableView(wordTableView, cellForRowAt: IndexPath(row: 0, section: 0)).
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as? WordTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let word = words[indexPath.row]
        
        cell.textField.text = word

         //Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(defaults.object(forKey: "words") as! [String])
            defaults.set(words, forKey: "words")
            print(defaults.object(forKey: "words") as! [String])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
