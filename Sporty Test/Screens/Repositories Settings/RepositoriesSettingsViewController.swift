import UIKit

protocol RepositoriesSettingsViewControllerDelegate {
    func newTokenSaved()
    func newRepoChosen()
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
        textView.font = UIFont.systemFont(ofSize: 16)
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
        
        return button
    }()
    
    private let repositoryLabel: UILabel = {
        
        let label = UILabel()
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let boldDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold)
        label.font = boldDescriptor.flatMap { UIFont(descriptor: $0, size: 0) } ?? baseFont
        label.adjustsFontForContentSizeCategory = true
        label.text =  String(localized: "Repository Name")
        
        return label
    }()
    
    private let repositoryTextField: UITextField = {
        
        let textField =  UITextField(frame:.zero)
        textField.placeholder = String(localized: "Repository name (cannot be empty)")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocapitalizationType = .none
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        if let repoName = UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryName) as? String {
            textField.text = repoName
        }
        
        return textField
    }()
    
    private let saveRepositoryButton: UIButton = {
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = String(localized: "Save")
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        
        return button
    }()
    
    private let defaultRepositoryButton: UIButton = {
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = String(localized: "Default")
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        
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
        repositoryTextField.delegate = self
        saveRepositoryButton.addTarget(self, action: #selector(saveRepoNamePressed(sender:)), for: .touchUpInside)
        defaultRepositoryButton.addTarget(self, action: #selector(defaultRepoNamePressed(sender:)), for: .touchUpInside)
        
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
        self.view.addSubview(repositoryLabel)
        self.view.addSubview(repositoryTextField)
        self.view.addSubview(saveRepositoryButton)
        self.view.addSubview(defaultRepositoryButton)
        
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        tokenTextView.translatesAutoresizingMaskIntoConstraints = false
        saveTokenButton.translatesAutoresizingMaskIntoConstraints = false
        repositoryLabel.translatesAutoresizingMaskIntoConstraints = false
        repositoryTextField.translatesAutoresizingMaskIntoConstraints = false
        saveRepositoryButton.translatesAutoresizingMaskIntoConstraints = false
        defaultRepositoryButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            repositoryLabel
                .leadingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            repositoryLabel
                .topAnchor
                .constraint(equalToSystemSpacingBelow: saveTokenButton.bottomAnchor, multiplier: 1),
            
            repositoryTextField
                .leadingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            repositoryTextField
                .trailingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            repositoryTextField
                .topAnchor
                .constraint(equalToSystemSpacingBelow: repositoryLabel.bottomAnchor, multiplier: 1),
            repositoryTextField.heightAnchor.constraint(equalToConstant: 30),
            
            saveRepositoryButton
                .trailingAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            saveRepositoryButton
                .topAnchor
                .constraint(equalToSystemSpacingBelow: repositoryTextField.bottomAnchor, multiplier: 1),
            
            defaultRepositoryButton
                .trailingAnchor
                .constraint(equalTo: saveRepositoryButton.leadingAnchor, constant: -10),
            defaultRepositoryButton
                .topAnchor
                .constraint(equalToSystemSpacingBelow: repositoryTextField.bottomAnchor, multiplier: 1)
        ])
        
    }
    
    @objc func backBtnPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAuthTokenPressed(sender: UIBarButtonItem) {
        //saving authorization token
        UserDefaults.standard.setValue(tokenTextView.text, forKey: Constants.UserDefaults.authorisationToken)
        
        //tell parent new token is saved
        if let delegate = self.delegate {
            delegate.newTokenSaved()
        }
        
    }
    
    @objc func saveRepoNamePressed(sender: UIBarButtonItem) {
        // saving organisation or user name
        UserDefaults.standard.setValue(repositoryTextField.text, forKey: Constants.UserDefaults.repositoryName)
        
        //tell parent new repository is chosen
        if let delegate = self.delegate {
            delegate.newRepoChosen()
        }
        
    }
    
    @objc func defaultRepoNamePressed(sender: UIBarButtonItem) {
        
        repositoryTextField.text = Constants.Repository.baseRepository
        
    }
}

extension RepositoriesSettingsViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        // delegate checks if user wants to save empty string and disables button if that is the case
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        saveRepositoryButton.isEnabled = !updatedText.isEmpty
       
        return true
    }

}
