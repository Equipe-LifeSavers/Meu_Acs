import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'login_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController controller;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    controller = LoginController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (controller.formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login validado com sucesso!.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop) const Expanded(child: _LoginLeftPanel()),
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.authCardWidth,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _LoginHeader(),
                            const SizedBox(height: AppSizes.xl),

                            // CPF
                            TextFormField(
                              controller: controller.cpfController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: AppStrings.cpfLabel,
                                hintText: 'Digite seu CPF',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe o CPF';
                                }
                                if (value.trim().length < 11) {
                                  return 'CPF inválido';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: AppSizes.lg),

                            // Senha
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                labelText: AppStrings.passwordLabel,
                                hintText: 'Digite sua senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe a senha';
                                }
                                if (value.trim().length < 3) {
                                  return 'Senha inválida';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: AppSizes.sm),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Esqueci minha senha'),
                              ),
                            ),

                            const SizedBox(height: AppSizes.md),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitLogin,
                                child: const Text(AppStrings.loginButton),
                              ),
                            ),

                            const SizedBox(height: AppSizes.lg),

                            Center(
                              child: Text(
                                'Acesso restrito a agentes comunitários e UBS.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginLeftPanel extends StatelessWidget {
  const _LoginLeftPanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg_salgueiro.png',
            fit: BoxFit.cover,
          ),
        ),

        // Overlay principal verde
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDark.withValues(alpha: 1),
                  AppColors.secondary.withValues(alpha: 0.88),
                  AppColors.secondary.withValues(alpha: 0.96),
                ],
              ),
            ),
          ),
        ),

        // Luz suave no topo esquerdo
        Positioned(
          top: -120,
          left: -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.06),
            ),
          ),
        ),

        // Luz suave inferior esquerda
        Positioned(
          bottom: -90,
          left: 530,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.04),
            ),
          ),
        ),

        // Onda inferior 1
        Positioned(
          bottom: -60,
          left: -40,
          right: 100,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.55),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(100),
              ),
            ),
          ),
        ),

        // Onda inferior 2
        Positioned(
          bottom: -10,
          left: -40,
          right: 400,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.45),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(100),
              ),
            ),
          ),
        ),

        // Bolinhas decorativas topo esquerdo
        const Positioned(top: 25, left: 25, child: _DotsPattern()),

        // Bolinhas decorativas canto inferior direito
        const Positioned(bottom: 25, right: 25, child: _DotsPattern()),

        // Conteúdo principal
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.xxl,
              25,
              AppSizes.xxl,
              AppSizes.xxl,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_meu_acs.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 0),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 50,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Meu ',
                            style: TextStyle(color: AppColors.white),
                          ),
                          TextSpan(
                            text: 'ACS',
                            style: TextStyle(color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      AppStrings.appSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.white.withValues(alpha: 1),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: 150,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      'Organize cadastros familiares, acompanhe visitas domiciliares e facilite o envio de informações para a UBS da região.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white.withValues(alpha: 1),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DotsPattern extends StatelessWidget {
  const _DotsPattern();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(
          23,
          (_) => Container(
            width: 5,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          'Informe suas credenciais para acessar o sistema.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
