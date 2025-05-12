import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'language'.tr(),
          style: GoogleFonts.figtree(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.surface),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildLanguageTile(
                  context,
                  label: 'English (EN)',
                  locale: const Locale('en'),
                  selected: currentLocale.languageCode == 'en',
                ),
                Divider(indent: 15, endIndent: 15,),
                _buildLanguageTile(
                  context,
                  label: 'Lao (LO)',
                  locale: const Locale('lo'),
                  selected: currentLocale.languageCode == 'lo',
                ),
                Divider(indent: 15, endIndent: 15,),
                _buildLanguageTile(
                  context,
                  label: 'Thai (TH)',
                  locale: const Locale('th'),
                  selected: currentLocale.languageCode == 'th',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String label,
    required Locale locale,
    required bool selected,
  }) {
    return ListTile(
      leading: Icon(FluentIcons.local_language_20_filled),
      title: Text(label, style: GoogleFonts.figtree()),
      trailing: selected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
      onTap: () async {
        await context.setLocale(locale);
        Navigator.pop(context); // Close the screen
      },
    );
  }
}
