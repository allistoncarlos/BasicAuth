import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showingRegisterSheet = false

    var body: some View {
        ZStack {
            if case .success = viewModel.state {
                viewModel.contentView()
            } else {
                NavigationView {
                    VStack {
                        Text("Basic Auth")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 40)
                        
                        VStack(spacing: 15) {
                            TextField("Usuário (E-mail)", text: $username)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                            
                            SecureField("Senha", text: $password) {
                                Task {
                                    await viewModel.login(
                                        username: username,
                                        password: password
                                    )
                                }
                            }
                            .textFieldStyle(.roundedBorder)
                        }
                        .padding(.horizontal)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.top, 10)
                        }
                        
                        Button {
                            Task {
                                await viewModel.login(
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
                                    Text("Entrar")
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(username.isEmpty || password.isEmpty || isLoading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Divider().padding(.vertical, 20)
                        
                        Text("Ou entre com:")
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 10) {
                            Button(action: {
#if DEBUG
                                viewModel.loginWithApple(mock: true)
#else
                                viewModel.loginWithApple()
#endif
                            }) {
                                HStack {
                                    Image(systemName: "applelogo")
                                    Text("Entrar com Apple")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            
                            Button(action: {
                                Task { await viewModel.signInWithGoogle() }
                            }) {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                    Text("Entrar com Google")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button("Não tem conta? Cadastre-se") {
                            showingRegisterSheet = true
                        }
                        .padding(.bottom, 20)
                        .sheet(isPresented: $showingRegisterSheet) {
                            RegisterView(viewModel: RegisterViewModel())
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
