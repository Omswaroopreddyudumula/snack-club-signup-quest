import 'package:flutter/material.dart';

void main() => runApp(const SnackClubApp());

class SnackClubApp extends StatelessWidget {
  const SnackClubApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Snack Club',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const SignupPage(),
  );
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const _category = 'password_help';
  static const _tips = <String>[
    'Use a long password that you do not use for another account.',
    'A few unrelated words can make a password easier to remember.',
    'Avoid using your name or birthday in your password.',
  ];
  int _nextTip = 0;
  bool _loadingTip = false;
  String? _tip;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Demo signup complete — your form passed validation!'),
      ),
    );
  }

  Future<void> _getTip() async {
    if (_loadingTip) return;
    setState(() => _loadingTip = true);
    // This delay only simulates work; no network service is called.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _tip = _tips[_nextTip];
      _nextTip = (_nextTip + 1) % _tips.length;
      _loadingTip = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Snack Club')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.cookie, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Join the snack break.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A little club for people who always bring snacks.',
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter your full name.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                          .hasMatch(email)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signUp(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password.';
                      }
                      if (value.length < 6) {
                        return 'Use at least six characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Demo only. No account is created and credentials are not saved.',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Local signup tip simulation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Category: $_category • Stored tips; no network request.',
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _loadingTip ? null : _getTip,
                    child: Text(
                      _loadingTip ? 'Loading tip…' : 'Get a signup tip',
                    ),
                  ),
                  if (_loadingTip)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (_tip != null)
                    Semantics(
                      liveRegion: true,
                      child: Text(_tip!, key: const Key('signup-tip')),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
