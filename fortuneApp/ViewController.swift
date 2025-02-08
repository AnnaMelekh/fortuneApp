//
//  ViewController.swift
//  fortuneApp
//
//  Created by Anna Melekhina on 06.02.2025.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    
    var networkManager = NetworkManager()

    let searchBar: UISearchBar = {
            let search = UISearchBar()
            search.placeholder = "Введите ваш запрос"
            search.searchBarStyle = .minimal
            return search
        }()
        
         let predictionButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("ПОЛУЧИТЬ ПРЕДСКАЗАНИЕ", for: .normal)
            button.backgroundColor = UIColor.purple
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 10
            return button
        }()
        
         let predictionImageView: UIImageView = {
            let imageView = UIImageView()
             imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "cover")
            return imageView
        }()
        
         let thumbsDownButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("👎", for: .normal)
            button.backgroundColor = UIColor.systemRed
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.layer.cornerRadius = 15
             button.isHidden = true
            return button
        }()
        
        let thumbsUpButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("👍", for: .normal)
            button.backgroundColor = UIColor.systemGreen
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.layer.cornerRadius = 15
            button.isHidden = true
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupUI()
            
            networkManager.delegate = self
            searchBar.delegate = self
            
            predictionButton.addTarget(self, action: #selector(getPrediction), for: .touchUpInside)
            thumbsDownButton.addTarget(self, action: #selector(getPrediction), for: .touchUpInside)
            thumbsUpButton.addTarget(self, action: #selector(likePressed), for: .touchUpInside)

        }
        
      private func setupUI() {
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            predictionButton.translatesAutoresizingMaskIntoConstraints = false
            predictionImageView.translatesAutoresizingMaskIntoConstraints = false
            thumbsDownButton.translatesAutoresizingMaskIntoConstraints = false
            thumbsUpButton.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(searchBar)
            view.addSubview(predictionButton)
            view.addSubview(predictionImageView)
            
             let buttonsStackView = UIStackView(arrangedSubviews: [thumbsDownButton, thumbsUpButton])
            buttonsStackView.axis = .horizontal
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.spacing = 20
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonsStackView)
            
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                searchBar.heightAnchor.constraint(equalToConstant: 40),
                
                predictionButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
                predictionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                predictionButton.widthAnchor.constraint(equalToConstant: 250),
                predictionButton.heightAnchor.constraint(equalToConstant: 50),
                
                predictionImageView.topAnchor.constraint(equalTo: predictionButton.bottomAnchor, constant: 60),
                predictionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                predictionImageView.widthAnchor.constraint(equalToConstant: 200),
                predictionImageView.heightAnchor.constraint(equalToConstant: 300),
                
                buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
                buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonsStackView.widthAnchor.constraint(equalToConstant: 200),
                buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
                
                thumbsDownButton.widthAnchor.constraint(equalToConstant: 60),
                thumbsDownButton.heightAnchor.constraint(equalToConstant: 60),
                thumbsUpButton.widthAnchor.constraint(equalToConstant: 60),
                thumbsUpButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        }

    @objc private func getPrediction() {
        if searchBar.text != ""  {
            networkManager.performRequest()
        }
        thumbsDownButton.isHidden = false
        thumbsUpButton.isHidden = false
    }
    
    @objc func likePressed() {
        

        let alert = UIAlertController(title: nil, message: "Fate accepted!\nAsk again", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(okAction)
           
        self.present(alert, animated: true)
        searchBar.text = ""
        predictionImageView.image = UIImage(named: "cover")
        thumbsDownButton.isHidden = true
        thumbsUpButton.isHidden = true
          }
    

    private func rotateImageView() {
        UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    self.predictionImageView.layer.transform = CATransform3DMakeRotation(.pi, 0, 0.1, 0)
//                    self.predictionImageView.alpha = 0.3
                })
                    }
                 
               
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        predictionImageView.image = UIImage(named: "cover")

     }
}

extension ViewController: NetworkServiceDelegate {
    
    func didUpdateData(meme: MemModel) {
        print(meme.urlMem)
        
        DispatchQueue.main.async {
            let url = URL(string: meme.urlMem)
            self.predictionImageView.kf.setImage(with: url)
        }
    }
        
    
    func didFailWithError(error: any Error) {
        print(error.localizedDescription)
    }
    
    
}

#Preview { ViewController () }

