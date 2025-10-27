# 🦆 Operação Patos Primordiais

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Maps](https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=google-maps&logoColor=white)

**Sistema de Catalogação e Captura de Patos Primordiais**

*Uma missão da DSIN - Divisão Secreta de Investigação*

[Sobre](#-sobre) • [Funcionalidades](#-funcionalidades) • [Pré-requisitos](#-pré-requisitos) • [Instalação](#-instalação) • [Configuração](#️-configuração) • [Uso](#-como-usar)

</div>

---

## 📖 Sobre

O **Operação Patos Primordiais** é um aplicativo Flutter desenvolvido para auxiliar na missão de catalogação, análise e captura de criaturas místicas conhecidas como Patos Primordiais. Equipado com tecnologia alienígena avançada, o sistema permite:

- 🗺️ **Controlar drones** via joystick virtual em mapas do Google Maps
- 📊 **Catalogar informações** detalhadas sobre cada Pato Primordial encontrado
- 📈 **Analisar viabilidade** operacional de missões de captura
- 🎮 **Simular operações** de combate e captura

---

## ✨ Funcionalidades

### 🗺️ Mapa de Drone
- Controle de drone com **joystick virtual** suave e responsivo
- Detecção automática de Patos Primordiais próximos
- Visualização em tempo real com Google Maps
- Sistema de marcadores coloridos (vermelho = desconhecido, azul = catalogado)
- Indicador de velocidade e posição GPS

### 📚 Sistema de Catalogação
- Lista completa de todos os Patos Primordiais encontrados
- **Conversão automática** entre sistemas métrico e imperial
- Expansão de cards com informações detalhadas
- Dados do drone responsável pela descoberta
- Informações sobre super-poderes

### 📊 Análise Operacional
- Cálculo de custo operacional
- Avaliação de poderio militar necessário
- Análise de grau de risco
- Estimativa de ganho científico
- Índice de viabilidade geral

### 🚁 Operação de Captura
- Simulador de drone de combate
- Monitoramento de bateria, combustível e integridade
- Sistema de estratégias de ataque
- Animações de missão em tempo real

---

## 🔧 Pré-requisitos

Antes de começar, certifique-se de ter instalado em sua máquina:

### Obrigatórios

- **Flutter SDK** (versão 3.0 ou superior)
  - [Download Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (incluído com Flutter)
- **Android Studio** ou **VS Code** com extensões Flutter
- **Git** para clonar o repositório

### Para Android

- **Android SDK** (API level 21 ou superior)
- **JDK** (Java Development Kit) versão 11 ou superior
- Emulador Android ou dispositivo físico

### Para iOS (apenas macOS)

- **Xcode** (versão 12 ou superior)
- **CocoaPods**
- Simulador iOS ou dispositivo físico

---

## 📥 Instalação

### 1️⃣ Instalar o Flutter

#### Windows

```bash
# Baixe o Flutter SDK
# https://flutter.dev/docs/get-started/install/windows

# Extraia o arquivo zip para C:\src\flutter

# Adicione ao PATH do sistema
setx PATH "%PATH%;C:\src\flutter\bin"

# Verifique a instalação
flutter doctor
```

#### macOS

```bash
# Instale via Homebrew
brew install flutter

# Ou baixe manualmente
cd ~/development
unzip ~/Downloads/flutter_macos_x.x.x-stable.zip

# Adicione ao PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verifique a instalação
flutter doctor
```

#### Linux

```bash
# Baixe o Flutter SDK
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_x.x.x-stable.tar.xz

# Extraia
tar xf flutter_linux_x.x.x-stable.tar.xz

# Adicione ao PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verifique a instalação
flutter doctor
```

### 2️⃣ Verificar Dependências

Execute o comando abaixo e resolva quaisquer problemas indicados:

```bash
flutter doctor -v
```

**Exemplo de saída esperada:**

```
[✓] Flutter (Channel stable, 3.x.x, on macOS 13.x, locale pt-BR)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.x)
[✓] VS Code (version 1.x.x)
[✓] Connected device (2 available)
```

### 3️⃣ Clonar o Repositório

```bash
git clone https://github.com/caroline-moreno/quack.git
cd quack
```

### 4️⃣ Instalar Dependências do Projeto

```bash
# Limpar cache (opcional, mas recomendado)
flutter clean

# Obter todas as dependências
flutter pub get
```

---

## 🚀 Como Usar

### Executar o Projeto

#### 1. Listar Dispositivos Disponíveis

```bash
flutter devices
```

#### 2. Executar em um Emulador/Dispositivo

```bash
# Executar no dispositivo conectado
flutter run

# Executar em um dispositivo específico
flutter run -d <device_id>

# Executar em modo release (mais rápido)
flutter run --release

# Executar no Chrome (web)
flutter run -d chrome
```

#### 3. Hot Reload durante Desenvolvimento

Enquanto o app está rodando:

- Pressione `r` para hot reload
- Pressione `R` para hot restart
- Pressione `q` para sair

### Gerar Build de Produção

#### Android (APK)

```bash
# Build APK
flutter build apk --release

# APK será gerado em: build/app/outputs/flutter-apk/app-release.apk

# Build App Bundle (para Google Play)
flutter build appbundle --release
```

#### iOS (IPA)

```bash
# Build para iOS
flutter build ios --release

# Abra o Xcode para arquivar
open ios/Runner.xcworkspace
```

---

## 🎮 Guia de Uso do App

### 1️⃣ Tela Inicial

Ao abrir o app, você verá 4 missões disponíveis:

- **🗺️ Mapa de Drone** - Explore o território
- **📚 Catalogação** - Veja patos encontrados
- **📊 Análise Operacional** - Avalie viabilidade de captura
- **🚁 Operação de Captura** - Simule missões de combate

### 2️⃣ Controlar o Drone

1. Acesse **Mapa de Drone**
2. Use o **joystick virtual** no canto inferior direito
3. Arraste o joystick para mover o drone
4. Aproxime-se dos **marcadores vermelhos** (raio de ~1.5 graus)
5. Quando encontrar um pato, um diálogo aparecerá automaticamente

### 3️⃣ Converter Unidades

Nos cards de catalogação:

1. Expanda o card do pato
2. Clique no **botão gradiente** no topo
3. Alterne entre Sistema Métrico (SI) e Imperial (US)
4. Valores de altura, peso e precisão serão convertidos

### 4️⃣ Visualizar Detalhes

- **No mapa**: Toque nos marcadores verdes
- **Na catalogação**: Expanda os cards
- Veja informações completas incluindo super-poderes

---

## 📦 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  cupertino_icons: ^1.0.6
```

---

## 🐛 Solução de Problemas

### ❌ Erro: "SDK location not found"

**Solução:**
```bash
# Crie o arquivo local.properties
cd android
echo "sdk.dir=/caminho/para/android/sdk" > local.properties
```

### ❌ Google Maps não aparece

**Solução:**
- Verifique se a API Key está configurada corretamente
- Confirme que as APIs estão ativadas no Google Cloud Console
- Verifique se há erros no console do Android Studio

### ❌ Permissões de localização negadas

**Solução:**
- Em dispositivos Android: Configurações → Apps → Patos Primordiais → Permissões
- Em iOS: Ajustes → Privacidade → Localização → Patos Primordiais

### ❌ Erro de build no iOS

**Solução:**
```bash
cd ios
pod install --repo-update
cd ..
flutter clean
flutter run
```

### ❌ Hot reload não funciona

**Solução:**
- Pressione `R` para hot restart completo
- Reinicie o app completamente

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 🙏 Agradecimentos

- Tecnologia alienígena fornecida pela **Federação Galáctica**
- Drones desenvolvidos por **TechCorp** e **AeroIndustries**
- Mapas fornecidos por **Google Maps Platform**
- Framework **Flutter** by Google
- Comunidade open-source

---

<div align="center">

**⚠️ CLASSIFICAÇÃO: ALTO SEGREDO ⚠️**

*Este projeto é parte de uma operação secreta da Equipe A10.*
*O uso não autorizado pode resultar em consequências graves.*

---

Feito com 💙 e muita 🦆 pela equipe A10

**[⬆ Voltar ao topo](#-operação-patos-primordiais)**

</div>
