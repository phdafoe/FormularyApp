//
//  UserViewModel.swift
//  FormularyApp
//
//  Created by Andres Felipe Ocampo Eljaiek on 04/03/2021.
//

import Foundation
import Combine
import Vera

class UserViewModel: ObservableObject {
    
    // Input
    @Published var name = ""
    @Published var lastname = ""
    @Published var email = ""
    
    @Published var username = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    // Output
    @Published var isValid = false
    @Published var nameMessage = ""
    @Published var lastnameMessage = ""
    @Published var emailMessage = ""
    @Published var usernameMessage = ""
    @Published var passwordMessage = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isNameValidPublisher: AnyPublisher<Bool, Never> {
        $name
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 5
            }
            .eraseToAnyPublisher()
    }
    
    private var isLastNameValidPublisher: AnyPublisher<Bool, Never> {
        $lastname
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 5
            }
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailPred.evaluate(with: input)
            }
            .eraseToAnyPublisher()
    }
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 5
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
      $password
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { password in
          return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest($password, $passwordAgain)
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .map { password, passwordAgain in
          return password == passwordAgain
        }
        .eraseToAnyPublisher()
    }
    
    private var passwordStrengthPublisher: AnyPublisher<PasswordStrength, Never> {
      $password
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { input in
          return Vera.strength(ofPassword: input)
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
      passwordStrengthPublisher
        .map { strength in
          print(Vera.localizedString(forStrength: strength))
          switch strength {
          case .reasonable, .strong, .veryStrong:
            return true
          default:
            return false
          }
        }
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Final Validation
    enum PasswordCheck {
      case valid
      case empty
      case noMatch
      case notStrongEnough
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
      Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongEnoughPublisher)
        .map { passwordIsEmpty, passwordsAreEqual, passwordIsStrongEnough in
          if (passwordIsEmpty) {
            return .empty
          }
          else if (!passwordsAreEqual) {
            return .noMatch
          }
          else if (!passwordIsStrongEnough) {
            return .notStrongEnough
          }
          else {
            return .valid
          }
        }
        .eraseToAnyPublisher()
    }

    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest4(isNameValidPublisher,
                                isEmailValidPublisher,
                                isUsernameValidPublisher,
                                isPasswordValidPublisher)
        .map { nameIsValid, emailIsValid, userNameIsValid, passwordIsValid in
          return nameIsValid && emailIsValid && userNameIsValid && (passwordIsValid == .valid)
        }
      .eraseToAnyPublisher()
    }
    
    init() {
        //Validate Name
        isNameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Name must at least have 5 characters"
            }
            .assign(to: \.nameMessage, on: self)
            .store(in: &cancellableSet)
        
        isLastNameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "LastName must at least have 5 characters"
            }
            .assign(to: \.lastnameMessage, on: self)
            .store(in: &cancellableSet)
        
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Email must have @ and extension .com for example"
            }
            .assign(to: \.emailMessage, on: self)
            .store(in: &cancellableSet)
        
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "User name must at least have 3 characters"
            }
            .assign(to: \.usernameMessage, on: self)
            .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return "Password must not be empty"
                case .noMatch:
                    return "Passwords don't match"
                case .notStrongEnough:
                    return "Password not strong enough"
                default:
                    return ""
                }
            }
            .assign(to: \.passwordMessage, on: self)
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
}
