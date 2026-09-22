# Clone da câmera do iOS

Este repositório recebe o pacote original `clone_O_i_v3.2.zip` enviado pelo proprietário.

## Conteúdo original

O ZIP contém:

- `gcc.exe`: executável Windows 32-bit que aparenta incluir um runtime LuaJIT/Qt;
- `ptd.txt`: código Lua/LuaJIT ofuscado;
- `Launch.cmd`: script que inicia `gcc.exe ptd.txt`.

## Estado da conversão para iOS

O pacote original não contém um projeto iOS compilável (`.xcodeproj`, `.xcworkspace`, código Swift ou Objective-C). Portanto, ele não pode ser convertido automaticamente em um `.ipa` apenas renomeando ou compilando os arquivos existentes.

Para gerar um IPA será necessário reconstruir a interface e os recursos em Swift/SwiftUI, UIKit ou outro framework compatível com iOS, e então compilar com o SDK/Xcode da Apple em macOS. Este repositório mantém o material original como referência para essa reconstrução.

> O executável não deve ser executado em um computador confiável sem verificação de segurança, pois seu código está ofuscado e foi compilado para Windows.
