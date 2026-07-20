import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/session_service.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_routes.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final rotaAtual = GoRouterState.of(context).uri.toString();

    return Container(
      width: 250,
      color: AppColors.primary,
      child: SafeArea(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              Image.asset('assets/images/logo_meu_acs.png', height: 90),

              const SizedBox(height: 30),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    _SidebarItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Dashboard',
                      selected: rotaAtual == AppRoutes.dashboard,
                      onTap: () => context.go(AppRoutes.dashboard),
                    ),

                    _SidebarItem(
                      icon: Icons.home_work_outlined,
                      title: 'Residências',
                      selected: rotaAtual == AppRoutes.residencias,
                      onTap: () => context.go(AppRoutes.residencias),
                    ),

                    _SidebarItem(
                      icon: Icons.family_restroom,
                      title: 'Famílias',
                      selected: rotaAtual == AppRoutes.familias,
                      onTap: () => context.go(AppRoutes.familias),
                    ),

                    _SidebarItem(
                      icon: Icons.people_outline,
                      title: 'Moradores',
                      selected: rotaAtual == AppRoutes.moradores,
                      onTap: () => context.go(AppRoutes.moradores),
                    ),

                    _SidebarItem(
                      icon: Icons.assignment_outlined,
                      title: 'Visitas',
                      selected: rotaAtual == AppRoutes.visitas,
                      onTap: () => context.go(AppRoutes.visitas),
                    ),

                    _SidebarItem(
                      icon: Icons.bar_chart_outlined,
                      title: 'Relatórios',
                      selected: rotaAtual == AppRoutes.relatorios,
                      onTap: () => context.go(AppRoutes.relatorios),
                    ),

                    _SidebarItem(
                      icon: Icons.settings_outlined,
                      title: 'Configurações',
                      selected: rotaAtual == AppRoutes.configuracoes,
                      onTap: () => context.go(AppRoutes.configuracoes),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24, indent: 20, endIndent: 20),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  SessionService.instance.usuario!.nome,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  SessionService.instance.usuario!.perfil,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      SessionService.instance.logout();

                      context.go(AppRoutes.login);
                    },

                    icon: const Icon(Icons.logout, color: Colors.white),

                    label: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.white),
                    ),

                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.white.withOpacity(.18) : Colors.transparent,
        border: selected ? Border.all(color: Colors.white24) : null,
        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(
        onTap: onTap,
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Icon(icon, color: Colors.white),
        ),
        
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
