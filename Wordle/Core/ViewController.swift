//
//  ViewController.swift
//  Wordle
//
//  Created by Vergil Wang on 2023/11/9.
//

import UIKit



class ViewController: UIViewController {
    
    let questions = ["AFTER", "ULTRA", "BROOK", "LATER"]
    
    var answer = "AFTER"
    private var guesses:[[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        keyboardVC.delegate = self
        addChildren()
        
        answer = questions.randomElement() ?? "AFTER"
    }

    
    func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        boardVC.dataSource = self
        setUpConstraint()
    }
    
    func setUpConstraint() {
        boardVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        boardVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        boardVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        boardVC.view.bottomAnchor.constraint(equalTo: self.keyboardVC.view.topAnchor, constant: 0).isActive = true
        boardVC.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        
        
        keyboardVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        keyboardVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        keyboardVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
      
    }

}

extension ViewController: KeyboardViewControllerDelegate{
    func keyBoardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        var stop = false
        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            
            if stop {
                break
            }
        }
        boardVC.reloadData()
    }
}

extension ViewController: BoardViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        let count = guesses[rowIndex].compactMap({$0})
        
        guard count.count == 5 else {
            return nil
        }
        
        let indexAnwser = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row], indexAnwser.contains(letter) else {
            return .red
        }
        
        if indexAnwser[indexPath.row] == letter {
            return .green
        }
        return .orange
    }
}
