import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../blocs/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final AppUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        context.read<ProfileCubit>().loadProfile(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = state.user ?? widget.user;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 58,
                      backgroundImage: user.photoUrl == null ? null : NetworkImage(user.photoUrl!),
                      child: user.photoUrl == null ? const Icon(Icons.person, size: 58) : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: IconButton.filled(
                        onPressed: state.loading ? null :
                          () => context.read<ProfileCubit>().changePhoto(user.id),
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(child: Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall)),
              Center(child: Text(user.email)),
              const SizedBox(height: 32),
              const ListTile(leading: Icon(Icons.phone_android), title: Text('Device')),
              ListTile(title: Text(state.deviceInfo.isEmpty ? 'Loading device information...' : state.deviceInfo)),
              if (state.message != null)
                Text(state.message!, style: const TextStyle(color: Colors.red)),
              if (state.loading) const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}
