import 'package:dartproyect/models/User.dart';
import 'package:dartproyect/services/user_service.dart';
import 'package:dartproyect/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Accountscreen extends StatefulWidget {
  const Accountscreen({super.key});

  @override
  State<Accountscreen> createState() => _AccountscreenState();
}

class _AccountscreenState extends State<Accountscreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await UserService.getCurrentUser();

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await UserService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Fecha no disponible';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    if (_user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No has iniciado sesión',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        color: Colors.orange,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16),

            // Profile image and name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange.shade100,
                    child: Text(
                      _user!.name.isNotEmpty
                          ? _user!.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user!.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Miembro desde: ${_formatDate(_user!.createdAt)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),

            // Account options
            _buildOptionItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Mis pedidos',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),

            _buildOptionItem(
              icon: Icons.location_on_outlined,
              title: 'Mis direcciones',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),

            _buildOptionItem(
              icon: Icons.payment_outlined,
              title: 'Métodos de pago',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),

            const Divider(),

            _buildOptionItem(
              icon: Icons.settings_outlined,
              title: 'Configuración',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),

            _buildOptionItem(
              icon: Icons.help_outline,
              title: 'Ayuda y soporte',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),

            const Divider(),

            _buildOptionItem(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              textColor: Colors.red,
              onTap: _logout,
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'PediYa v1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
