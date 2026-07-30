// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Dispara o download de um arquivo binário no navegador.
/// Só funciona em Flutter Web (usa dart:html)
void baixarArquivo(List<int> bytes, String nomeArquivo, {String mimeType = 'application/pdf'}) {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute('download', nomeArquivo)
    ..click();

  html.Url.revokeObjectUrl(url);
}