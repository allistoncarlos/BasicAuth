import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        Form {
            Section(header: Text("Informações Pessoais")) {
                TextField("Nome", text: $firstName)
                TextField("Sobrenome", text: $lastName)
            }
            
            Section(header: Text("Credenciais")) {
                TextField("Usuário (E-mail)", text: $username)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Senha", text: $password)
                SecureField("Confirmar Senha", text: $confirmPassword)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button {
                Task {
                    await viewModel.register(
                        firstName: firstName,
                        lastName: lastName,
                        username: username,
                        password: password
                    )
                }
            } label: {
                HStack {
                    Spacer()
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Cadastrar")
                    }
                    Spacer()
                }
            }
            .disabled(isRegisterButtonDisabled)
        }
        .onChange(of: viewModel.state, {
            if viewModel.state == .success {
                dismiss()
            }
        })
        .navigationTitle("Novo Cadastro")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar") {
                    dismiss()
                }
            }
        }
    }
    
    var isRegisterButtonDisabled: Bool {
        return firstName.isEmpty
        || lastName.isEmpty
        || username.isEmpty
        || password.isEmpty
        || password != confirmPassword
        || isLoading
    }
}
