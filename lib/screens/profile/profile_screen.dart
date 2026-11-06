import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final orderService = context.watch<OrderService>();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: AppBar(
        backgroundColor: KebuninColors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: KebuninColors.charcoal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: KebuninColors.forestGreen),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: KebuninColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Card Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.lg),
                border: Border.all(color: KebuninColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: KebuninColors.forestGreen, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(user?.avatarUrl ??
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Budi Santoso',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: KebuninColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? 'budi.santoso@kebunin.id',
                              style: const TextStyle(
                                fontSize: 12,
                                color: KebuninColors.mutedGrey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0E0),
                                borderRadius:
                                    BorderRadius.circular(KebuninRadius.pill),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.stars_rounded,
                                      size: 13,
                                      color: KebuninColors.carrotOrange),
                                  const SizedBox(width: 4),
                                  Text(
                                    user?.memberTier ?? 'Sahabat Petani Gold',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: KebuninColors.carrotOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Points & Orders Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.monetization_on_outlined,
                          title: '${user?.points ?? 480} Poin',
                          subtitle: 'Poin Segar KEBUNIN',
                          color: KebuninColors.forestGreen,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: KebuninColors.border,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.receipt_long_outlined,
                          title: '${orderService.orders.length} Pesanan',
                          subtitle: 'Total Riwayat Belanja',
                          color: KebuninColors.carrotOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Profile Menus Container
            Container(
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.lg),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.edit_note_rounded,
                    title: 'Ubah Data Diri',
                    subtitle: 'Nama, nomor telepon, dan email',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Alamat Pengiriman Utama',
                    subtitle: user?.address ?? 'Jl. Kebon Jeruk No. 12',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.receipt_outlined,
                    title: 'Riwayat Pesanan',
                    subtitle: 'Cek status pesanan aktif & riwayat lalu',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.orders);
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.support_agent_rounded,
                    title: 'Layanan Bantuan Pelanggan',
                    subtitle: 'Hubungi tim KEBUNIN via WhatsApp (24 Jam)',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Menghubungkan ke layanan bantuan KEBUNIN...'),
                          backgroundColor: KebuninColors.forestGreen,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang Aplikasi KEBUNIN',
                    subtitle: 'Aplikasi belanja sayur petani lokal nusantara',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'KEBUNIN',
                        applicationVersion: '2.4.0',
                        applicationLegalese:
                            '© 2026 KEBUNIN Indonesia • Belanja Sayur Segar Lebih Mudah.',
                        children: const [
                          SizedBox(height: 10),
                          Text(
                              'Aplikasi mobile e-commerce sayur segar yang memberdayakan petani nusantara langsung ke rumah pelanggan.'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: const Color(0xFFFDE8E8)),
              ),
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Keluar dari Akun?'),
                      content: const Text(
                          'Anda akan kembali ke halaman awal masuk akun.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            authService.logout();
                            Navigator.pop(ctx);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.login,
                              (route) => false,
                            );
                          },
                          child: const Text('Keluar',
                              style: TextStyle(color: KebuninColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded,
                    color: KebuninColors.error, size: 20),
                label: const Text(
                  'Keluar dari Akun',
                  style: TextStyle(
                    color: KebuninColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10.5,
            color: KebuninColors.mutedGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: KebuninColors.warmCream,
          borderRadius: BorderRadius.circular(KebuninRadius.sm),
        ),
        child: Icon(icon, size: 20, color: KebuninColors.forestGreen),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: KebuninColors.charcoal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
          color: KebuninColors.mutedGrey,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          size: 20, color: KebuninColors.mutedGrey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

