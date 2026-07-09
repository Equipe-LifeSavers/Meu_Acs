import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/session_service.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.primary,
      child: Column(
        children: [
          const SizedBox(height: 30),

          Image.asset('assets/images/logo_meu_acs.png', height: 90),

          const SizedBox(height: 30),

          const _SidebarItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            selected: true,
          ),

          const _SidebarItem(
            icon: Icons.home_work_outlined,
            title: 'Residências',
          ),

          const _SidebarItem(icon: Icons.family_restroom, title: 'Famílias'),

          const _SidebarItem(icon: Icons.people_outline, title: 'Moradores'),

          const _SidebarItem(icon: Icons.assignment_outlined, title: 'Visitas'),

          const _SidebarItem(
            icon: Icons.bar_chart_outlined,
            title: 'Relatórios',
          ),

          const Spacer(),

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

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
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
