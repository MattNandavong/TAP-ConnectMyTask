import 'package:app/utils/firebase_service.dart';
import 'package:app/widget/login/profile_setup_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:app/model/user.dart';
import 'package:app/utils/auth_service.dart';
import 'package:app/widget/screen/splash_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/utils/connection_helper.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _fcmToken = getFcmToken();
  String _userType = 'user';
  bool _isLogin = true;

  Future<void> handleGoogleLogin() async {
    try {
      // Force logout first to prompt account picker
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      await _googleSignIn.signOut();

      // Force sign-in with fresh web-based flow if supported
      final account = await _googleSignIn.signInSilently(suppressErrors: true);
      final newAccount = account ?? await _googleSignIn.signIn();

      if (newAccount != null) {
        final name = newAccount.displayName ?? '';
        final email = newAccount.email;

        setState(() {
          _nameController.text = name;
          _emailController.text = email;
          _isLogin = false;
        });
      } else {
        print('❌ Google sign-in cancelled.');
      }
    } catch (e) {
      print('❌ Google sign-in failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed. Try again.')),
      );
    }
  }

  Future<void> loginWithGoogleWeb() async {
    final clientId =
        '316575215494-04inmhobrk8ub4vefhcb0dooqvvhs60r.apps.googleusercontent.com';
    final redirectUri =
        'com.googleusercontent.apps.316575215494-04inmhobrk8ub4vefhcb0dooqvvhs60rt'; // ✅ Scheme format
    final authUrl =
        'https://accounts.google.com/o/oauth2/v2/auth?response_type=code'
        '&client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&scope=email%20profile'
        '&access_type=offline'
        '&prompt=select_account'; // ✅ forces account chooser

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme:
            'com.googleusercontent.apps.316575215494-nggvto7m1ggs467na9adr9c4civ3b4mh', // ✅ Must match scheme in redirect URI
      );

      final code = Uri.parse(result).queryParameters['code'];
      print('✅ Auth code: $code');

      // Now exchange this code for an access token
      final tokenResponse = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'code': code,
          'client_id': clientId,
          'client_secret':
              'YOUR_CLIENT_SECRET', // ⚠️ Get this from Google console
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
        },
      );

      final tokenJson = json.decode(tokenResponse.body);
      final accessToken = tokenJson['access_token'];
      print('🔑 Access token: $accessToken');

      // Optionally fetch user profile
      final profileResponse = await http.get(
        Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final profile = json.decode(profileResponse.body);
      print('👤 User profile: $profile');

      // You can now extract: name, email, picture
      // And autofill into your registration fields
    } catch (e) {
      print('❌ Web Auth failed: $e');
    }
  }

  Future<void> submit() async {
    print('submit click');

    // ✅ Block the user with dialog if offline
    final isConnected = await ConnectionHelper.hasConnection();
    if (!isConnected) {
      await ConnectionHelper.showNoConnectionDialog(
        context,
      ); // 👈 FREEZES until connection is restored
      return;
    }

    final isValid = _form.currentState!.validate();
    final token = await getFcmToken(); // Await actual token string
    if (!isValid) return;

    try {
      print('Tokem FCM: $token');

      print({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': _userType,
        // include skills if _userType is 'provider', even as empty string:
        'skills': _userType == 'provider' ? '' : null,
        'fcmToken': token,
      });

      User user;
      if (_isLogin) {
        user = await _authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          token!, //  Correct token here
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      } else {
        user = await _authService.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _userType,
          fcmToken: token,
        );

        print('✅ login user: ${user.id}');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileSetupScreen(user: user)),
        );
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();

      final isKnownInputError =
          errorStr.contains('invalid') ||
          errorStr.contains('credentials') ||
          errorStr.contains('email') ||
          errorStr.contains('already exists') ||
          errorStr.contains('password');

      if (!isKnownInputError) {
        // ✅ Log only unexpected errors
        await FirebaseCrashlytics.instance.recordError(
          e,
          null,
          reason: 'Login/Register unexpected error',
        );
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${e.toString()}')));
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
          child: Column(
            children: [
              Image.asset(
                "lib/image/connectmytask_logo.png",
                width: 250,
                height: 40,
              ),
              SizedBox(height: 60),
              SvgPicture.asset("lib/image/login.svg", height: 200),
              SizedBox(height: 30),
              Text(
                "Get Your Task Done!",
                style: GoogleFonts.oswald(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 60),
              Form(
                key: _form,
                child: Column(
                  children: [
                    if (!_isLogin)
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'username'.tr()),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'pleaseEnterValidName'.tr()
                                    : null,
                      ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'email'.tr()),
                      validator:
                          (value) =>
                              value == null || !value.contains('@')
                                  ? 'enterValidEmail'.tr()
                                  : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'password'.tr()),
                      validator:
                          (value) =>
                              value != null && value.length >= 6
                                  ? null
                                  : 'minSixCharacters'.tr(),
                    ),
                    SizedBox(height: 16),
                    if (!_isLogin)
                      Column(
                        children: [
                          SizedBox(height: 20),

                          Wrap(
                            spacing: 10,
                            children:
                                ['user', 'provider'].map((type) {
                                  return ChoiceChip(
                                    label: Text(type),
                                    selected: _userType == type,
                                    onSelected:
                                        (_) => setState(() => _userType = type),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),

                    SizedBox(height: 24),
                    FilledButton(
                      onPressed: submit,
                      child: Text(_isLogin ? 'login'.tr() : 'register'.tr()),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin
                            ? 'createNewAccount'.tr()
                            : 'alreadyRegisteredLogin'.tr(),
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result =
                            await _authService.signInWithGoogleOnly();

                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Google login failed')),
                          );
                          return;
                        }

                        if (result['status'] == 'login_success') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ),
                          );
                        } else if (result['status'] == 'unregistered') {
                          setState(() {
                            _isLogin = false;
                            _nameController.text = result['name'] ?? '';
                            _emailController.text = result['email'] ?? '';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please complete registration'),
                            ),
                          );
                        }
                      },

                      icon: Icon(Icons.g_mobiledata),
                      label: Text('Sign in with Google'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     FirebaseCrashlytics.instance.crash(); // Force a crash
                    //   },
                    //   child: Text('Crash App'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
