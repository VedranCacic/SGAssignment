import Foundation
import MockLiveServer
import GitHubAPI

public class RepositoriesViewModel {
    
    
    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer
    
    var repositories: Box<[GitHubMinimalRepository]> = Box([])
    var repositoryType:RepositoryType = RepositoryType(rawValue: UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryType) as! String)!{
        didSet {
            // saving repository type
            UserDefaults.standard.setValue(repositoryType.rawValue, forKey: Constants.UserDefaults.repositoryType)
            self.callApi()
        }
    }
    
    var repositoryName:String = UserDefaults.standard.value(forKey: Constants.UserDefaults.repositoryName) as! String{
        didSet {
            // saving organization or user name
            UserDefaults.standard.setValue(repositoryName, forKey: Constants.UserDefaults.repositoryName)
            self.callApi()
        }
    }
    
    var authorizatonToken:String? = UserDefaults.standard.value(forKey: Constants.UserDefaults.authorisationToken) as? String {
        didSet {
            // saving organization or user name
            UserDefaults.standard.setValue(authorizatonToken, forKey: Constants.UserDefaults.authorisationToken)
            self.callApiWithNewToken(token: authorizatonToken!)
        }
    }
    
    init(gitHubAPI: GitHubAPI, mockLiveServer: MockLiveServer) {
        self.gitHubAPI = gitHubAPI
        self.mockLiveServer = mockLiveServer
    }
    
    func callApi(){
        Task{
            await loadRepositories()
        }
    }
    
    func callApiWithNewToken(token:String){
        Task{
            await loadRepositoriesWithToken(token: token)
        }
    }
    
    private func loadRepositories() async {
        do {
            let api = GitHubAPI()
            repositories.value = try await api.repositoriesForOrganisation(repositoryName, type: repositoryType)
           
        } catch {
            print("Error loading repositories: \(error)")
            repositories.value = []
           
        }
    }
    
    private func loadRepositoriesWithToken(token:String) async {
        do {
            let api = GitHubAPI()
            repositories.value = try await api.repositoriesForOrganisation(repositoryName, type: repositoryType, authToken: token)
           
        } catch {
            print("Error loading repositories: \(error)")
            repositories.value = []
           
        }
    }

}

