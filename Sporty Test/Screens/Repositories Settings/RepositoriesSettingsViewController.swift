import UIKit

protocol RepositoriesSettingsViewControllerDelegate {
    func newTokenSaved()
}

/// A view controller that displays the options for RepositoriesViewController
final class RepositoriesSettingsViewController: UIViewController {
    
    var delegate: RepositoriesSettingsViewControllerDelegate? = nil
    
    private let backButton: UIButton = {
        
        let buttonImage = UIImage(systemName: "arrowshape.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        button.sizeToFit()
        
        return button
    }()
    
    private let tokenLabel: UILabel = {
        let label = UILabel()
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let boldDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold)
        label.font = boldDescriptor.flatMap { UIFont(descriptor: $0, size: 0) } ?? baseFont
        label.adjustsFontForContentSizeCategory = true
        label.text =  String(localized: "Authorisation Token")
        
        return label
    }()
    
    private let tokenTextView: UITextView = {
        
        let textView = UITextView(frame: CGRect.zero)
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.layer.cornerRadius = 5
        textView.autocapitalizationType = .none
        if let potentialString = UserDefaults.standard.value(forKey: Constants.UserDefaults.authorisationToken) as? String {
            textView.text = potentialString
        }
        
        return textView
        
    }()
    
    private let saveTokenButton: UIButton = {
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = String(localized: "Save")
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        
        if let potentialString = UserDefaults.standard.value(forKey: Constants.UserDefaults.authorisationToken) as? String {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
        
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nil, bundle: nil)
        title = "Options"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray5
        
        backButton.addTarget(self, action: #selector(backBtnPressed(sender:)), for: .touchUpInside)
        saveTokenButton.addTarget(self, action: #selector(saveAuthTokenPressed(sender:)), for: .touchUpInside)
        tokenTextView.delegate = self
        
        //add views and constraints
        setViews()
    }
    
    func setViews(){
        
        //custom back button, system blue looks weird
        let backItem = UIBarButtonItem(customView: backButton)
        backItem.style = .plain
        navigationItem.leftBarButtonItem = backItem
        
        self.view.addSubview(tokenLabel)
        self.view.addSubview(tokenTextView)
        self.view.addSubview(saveTokenButton)
        
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        tokenTextView.translatesAutoresizingMaskIntoConstraints = false
        saveTokenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tokenLabel
                .leadingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            tokenLabel
                .firstBaselineAnchor
                .constraint(equalToSystemSpacingBelow: self.view.layoutMarginsGuide.topAnchor, multiplier: 1),
            
            tokenTextView
                .leadingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            tokenTextView
                .trailingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            tokenTextView
                .firstBaselineAnchor
                .constraint(equalToSystemSpacingBelow: tokenLabel.bottomAnchor, multiplier: 1),
            tokenTextView.heightAnchor.constraint(equalToConstant: 100),
            
            saveTokenButton
                .trailingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            saveTokenButton
                .topAnchor
                .constraint(equalToSystemSpacingBelow: tokenTextView.bottomAnchor, multiplier: 1),
        ])
        
    }
    
    @objc func backBtnPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAuthTokenPressed(sender: UIBarButtonItem) {
        
        UserDefaults.standard.setValue(tokenTextView.text, forKey: Constants.UserDefaults.authorisationToken)
        
        //tell parent new token is saved
        if let delegate = self.delegate {
            delegate.newTokenSaved()
        }
        
    }
}

extension RepositoriesSettingsViewController:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        guard let textFieldText = textView.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return true
        }
        
        let currentText = textFieldText.replacingCharacters(in: rangeOfTextToReplace, with: text)
        print("word typed: " + currentText)
        saveTokenButton.isEnabled = !currentText.isEmpty
        
        return true
    }
    
}
