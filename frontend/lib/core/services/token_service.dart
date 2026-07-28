class TokenService {
  TokenService._();

  static final TokenService instance = TokenService._();

  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  void salvarToken(String token) {
    _token = token;
  }

  void limpar() {
    _token = null;
  }
}