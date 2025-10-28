# Gerador de Senhas - Projeto Flutter

## 📋 Descrição
Aplicativo Flutter integrado ao Firebase Authentication e Cloud Firestore que permite:
- Login de usuários
- Geração de senhas seguras via webservice
- Armazenamento e gerenciamento de senhas
- Interface moderna e segura

## 🚀 Funcionalidades Implementadas

### ✅ Autenticação
- Login e cadastro de usuários via Firebase Auth
- Tela de introdução com opção "Não mostrar novamente"
- Tela de splash com verificação de autenticação

### ✅ Geração de Senhas
- **Webservice**: Integração com API externa para geração de senhas
- **Fallback local**: Geração local caso o webservice falhe
- **Configurações avançadas**:
  - Tamanho da senha (4-32 caracteres)
  - Incluir/excluir maiúsculas, minúsculas, números e caracteres especiais

### ✅ Gerenciamento de Senhas
- Lista de senhas salvas por usuário
- **Segurança**: Senhas ocultas por padrão com opção de visualizar
- **Ações**: Copiar para área de transferência e excluir senhas
- Armazenamento no Cloud Firestore

### ✅ Interface
- Material Design 3
- Tema azul moderno
- Navegação intuitiva
- Cards responsivos para senhas

## 🛠️ Tecnologias Utilizadas

- **Flutter**: ^3.8.1
- **Firebase Core**: ^4.2.0
- **Firebase Auth**: ^6.1.1
- **Cloud Firestore**: ^6.0.3
- **Shared Preferences**: ^2.2.2
- **HTTP**: ^1.2.1
- **Lottie**: ^3.1.2

## 📱 Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada
├── firebase_options.dart              # Configurações do Firebase
├── services/
│   └── password_service.dart          # Serviço de geração de senhas
└── screens/
    ├── splash/
    │   └── splash_screen.dart         # Tela inicial
    ├── intro/
    │   └── intro_screen.dart          # Introdução do app
    ├── login/
    │   └── login_screen.dart          # Login/Cadastro
    ├── home/
    │   └── home_screen.dart           # Lista de senhas
    └── password/
        └── password_screen.dart       # Geração de senhas
```

## 🔧 Configuração do Firebase

### 1. Configuração do Projeto
O projeto já está configurado com as seguintes credenciais:
- **Project ID**: gerador-de-senha-a4cb8
- **Web App ID**: 1:704660588087:web:c3cf7203e37ed00365a1b2

### 2. Regras do Firestore
Configure as seguintes regras no Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/passwords/{passwordId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3. Autenticação
- Habilite a autenticação por email/senha no Firebase Console
- Configure as regras de segurança conforme necessário

## 🚀 Como Executar

### 1. Instalar Dependências
```bash
flutter pub get
```

### 2. Configurar Firebase (se necessário)
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Fazer login
firebase login

# Configurar projeto (opcional)
firebase use gerador-de-senha-a4cb8
```

### 3. Executar o App
```bash
# Debug
flutter run

# Release
flutter run --release
```

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔒 Segurança

### Recursos de Segurança Implementados:
1. **Senhas ocultas por padrão** na lista principal
2. **Autenticação obrigatória** para acessar funcionalidades
3. **Isolamento de dados** por usuário no Firestore
4. **Geração segura** de senhas com Random.secure()
5. **Validação de entrada** em todos os formulários

### Webservice de Senhas:
- **API**: https://api.passwordwolf.com/
- **Fallback**: Geração local em caso de falha
- **Configurável**: Opções avançadas de personalização

## 🎯 Melhorias Implementadas

### ✅ Correções Realizadas:
1. **Dependências**: Adicionadas todas as dependências necessárias
2. **Firebase**: Configuração completa para todas as plataformas
3. **Splash Screen**: Implementação funcional com verificação de auth
4. **Intro Screen**: Corrigida para usar ícones ao invés de Lottie
5. **Webservice**: Integração completa com API externa
6. **Segurança**: Melhorias na exibição e gerenciamento de senhas

### ✅ Funcionalidades Adicionais:
- Configurações avançadas de geração de senhas
- Interface de cards moderna para senhas
- Ações de copiar e excluir senhas
- Validação robusta de erros
- Feedback visual para todas as ações

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique se todas as dependências estão instaladas
2. Confirme se o Firebase está configurado corretamente
3. Verifique a conexão com internet para o webservice
4. Consulte os logs do Flutter para erros específicos

---

**Desenvolvido com Flutter e Firebase** 🚀
