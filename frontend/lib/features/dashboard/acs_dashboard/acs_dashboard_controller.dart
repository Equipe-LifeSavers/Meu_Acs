class AcsDashboardController {
  String get saudacao {
    final hora = DateTime.now().hour;

    if (hora < 12) {
      return 'Bom dia';

    }else if (hora < 18) {
      return 'Boa tarde';
    }
    return 'Boa noite';
  }
}
