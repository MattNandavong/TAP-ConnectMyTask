import 'dart:io';
import 'package:flutter/material.dart';

class ConnectionHelper {
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<void> showNoConnectionDialog(BuildContext context) async {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _NoConnectionDialog();
      },
    );
  }
}

class _NoConnectionDialog extends StatefulWidget {
  @override
  State<_NoConnectionDialog> createState() => _NoConnectionDialogState();
}

class _NoConnectionDialogState extends State<_NoConnectionDialog> {
  bool _checking = false;

  Future<void> _tryReconnect() async {
    setState(() => _checking = true);

    final connected = await ConnectionHelper.hasConnection();
    await Future.delayed(Duration(milliseconds: 500)); // UX delay
    setState(() => _checking = false);

    if (connected && mounted) {
      Navigator.of(context).pop(); // ✅ Only close if online
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Back online'), backgroundColor: Colors.green),
      );
    } else {
      // ❌ Still offline — keep dialog open
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Still no connection.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No Internet Connection'),
      content: Text('Please check your network settings and try again.'),
      actions: [
        TextButton(
          onPressed: _checking ? null : _tryReconnect,
          child:
              _checking
                  ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text('Try Again'),
        ),
      ],
    );
  }
}
