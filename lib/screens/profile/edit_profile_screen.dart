import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_button.dart';
import '../../widgets/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _cityController = TextEditingController(
      text: user?.city ?? 'Jakarta Barat',
    );
    _postalCodeController = TextEditingController(
      text: user?.postalCode ?? '11530',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await context.read<AuthService>().updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data profil & alamat berhasil diperbarui ke Supabase!',
          ),
          backgroundColor: KebuninColors.forestGreen,
        ),
      );
      Navigator.pop(context);
    } else {
      final err =
          context.read<AuthService>().errorMessage ??
          'Gagal memperbarui profil.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: KebuninColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: const CustomAppBar(
        title: 'Ubah Data Diri & Alamat',
        showCartButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: KebuninColors.white,
                  borderRadius: BorderRadius.circular(KebuninRadius.md),
                  border: Border.all(color: KebuninColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: KebuninColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Nama lengkap Anda',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          size: 20,
                          color: KebuninColors.mutedGrey,
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Nomor Handphone (WhatsApp)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: KebuninColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '0812-xxxx-xxxx',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          size: 20,
                          color: KebuninColors.mutedGrey,
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'No HP wajib diisi'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Alamat Lengkap Rumah',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: KebuninColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Nama jalan, nomor rumah, RT/RW, patokan',
                        prefixIcon: Icon(
                          Icons.home_outlined,
                          size: 20,
                          color: KebuninColors.mutedGrey,
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Alamat wajib diisi'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kota / Kabupaten',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: KebuninColors.charcoal,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  hintText: 'Contoh: Jakarta Barat',
                                ),
                                validator: (val) =>
                                    val == null || val.trim().isEmpty
                                    ? 'Kota wajib diisi'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kode Pos',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: KebuninColors.charcoal,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _postalCodeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '11530',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              CommonButton(
                text: 'Simpan Perubahan',
                icon: Icons.save_outlined,
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
