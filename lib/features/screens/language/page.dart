part of 'imports.dart';

class LanguagePage extends GetView<_Controller> {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslationKeys.language.tr),
        elevation: 0,
      ),
      body: Obx(() => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: controller.languages.length,
        separatorBuilder: (context, index) => Divider(
          color: context.dividerColor,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final language = controller.languages[index];
          final locale = language['locale'] as Locale;
          final isSelected = controller.isSelected(locale);

          return _LanguageItem(
            name: language['name'],
            flagCode: language['flag'] ?? language['locale'].countryCode,
            isSelected: isSelected,
            onTap: () => controller.changeLanguage(locale),
          );
        },
      )),
    );
  }
}