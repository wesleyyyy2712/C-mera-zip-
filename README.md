# Camera Native

Versão nativa para iOS, reconstruída em SwiftUI/UIKit. O projeto contém somente a interface e as funcionalidades da câmera:

- visualização da câmera em tela cheia;
- captura de fotos;
- salvamento na Fototeca;
- câmera frontal e traseira;
- flash;
- foco e exposição por toque;
- miniatura da última foto;
- ícone próprio e Bundle ID `com.wesleyyyy2712.CameraNative`.

O executável Windows, LuaJIT/Qt e o pacote original foram removidos desta versão. O workflow do GitHub Actions gera `CameraClone-unsigned.ipa`, que pode ser importado no GBox para assinatura.

A assinatura ainda depende do certificado e do provisioning profile configurados no GBox.
