import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_task_manager/core/theme/theme_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .get();

    final data = doc.data();
    if (data != null) {
      _nameController.text = data["name"] ?? "";
    }

    setState(() {
      _loading = false;
if (data?["darkMode"] != null) {
  ref.read(themeModeProvider.notifier).state =
      data?["darkMode"];
}


    });
  }

  Future<void> _saveProfile() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .update({
      "name": _nameController.text,
      "darkMode": ref.read(themeModeProvider),
    });

    Navigator.pop(context);
  }
@override
Widget build(BuildContext context) {
  if (_loading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  final user = FirebaseAuth.instance.currentUser;

  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),

          
          CircleAvatar(
            radius: 45,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          
          Text(
            _nameController.text.isEmpty
                ? "User"
                : _nameController.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          
          Text(
            user?.email ?? "",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 24),

         
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Update Name",
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

        
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
    }