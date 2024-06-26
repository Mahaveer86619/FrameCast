import 'package:flutter/material.dart';
import 'package:framecast/features/auth/view/screens/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FrameCast'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {
                Supabase.instance.client.auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Main',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
      ),
    );
  }
}
