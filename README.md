# Clone da câmera do iOS

Este repositório contém o pacote original e uma **primeira reconstrução nativa para iOS** da interface de câmera.

## Projeto iOS

A pasta [`ios-camera-clone`](./ios-camera-clone) contém um app SwiftUI/UIKit que implementa:

- pré-visualização da câmera em tela cheia;
- captura de fotos e salvamento na Fototeca;
- alternância entre câmera frontal e traseira;
- flash;
- foco e exposição por toque;
- miniatura da última foto capturada.

O arquivo `project.yml` pode ser usado com [XcodeGen](https://github.com/yonaskolb/XcodeGen) para gerar o projeto Xcode.

## Compilação

O workflow [`Build iOS IPA`](./.github/workflows/build-ios.yml) está configurado para gerar um artefato `CameraClone-unsigned.ipa` em um runner macOS do GitHub Actions. Esse IPA é **não assinado**; para instalar em um iPhone é necessário assinar o aplicativo com uma conta Apple Developer e um provisioning profile.

## Pacote original

O ZIP original `clone_O_i_v3.2.zip` contém:

- `gcc.exe`: executável Windows 32-bit que aparenta incluir um runtime LuaJIT/Qt;
- `ptd.txt`: código Lua/LuaJIT ofuscado;
- `Launch.cmd`: script que inicia `gcc.exe ptd.txt`.

O pacote original não contém um projeto iOS compilável. Por isso a versão iOS foi reconstruída, em vez de convertida automaticamente.
