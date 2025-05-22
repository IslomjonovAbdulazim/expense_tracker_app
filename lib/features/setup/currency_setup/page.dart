part of 'imports.dart';

// part of 'imports.dart'; - Add this to the imports file

class CurrencySetupPage extends GetView<CurrencySetupController> {
  const CurrencySetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: 24),

              // Search bar
              _buildSearchBar(context),

              const SizedBox(height: 16),

              // Currency list
              Expanded(
                child: _buildCurrencyList(context),
              ),

              const SizedBox(height: 24),

              // Action buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.monetization_on,
            size: 40,
            color: context.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Choose Your Currency',
          style: context.headingLarge.copyWith(
            color: context.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Select your preferred currency for tracking expenses',
          style: context.bodyMedium.copyWith(
            color: context.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SearchTextField(
      controller: controller.searchController,
      hint: 'Search currencies...',
      onChanged: (value) {
        // Controller already handles this through listener
      },
    );
  }

  Widget _buildCurrencyList(BuildContext context) {
    return Obx(() {
      final currencies = controller.filteredCurrencies;

      if (currencies.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: context.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No currencies found',
                style: context.bodyLarge.copyWith(
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try a different search term',
                style: context.bodyMedium.copyWith(
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: currencies.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final currency = currencies[index];

          return Obx(() => _CurrencyCard(
            currency: currency,
            isSelected: controller.isSelected(currency),
            onTap: () => controller.selectCurrency(currency),
          ));
        },
      );
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    return Obx(() => Column(
      children: [
        // Continue button
        PlatformButton.primary(
          text: controller.isFromSettings.value ? 'Update Currency' : 'Continue',
          onPressed: controller.selectedCurrency.value != null
              ? controller.confirmSelection
              : null,
          isLoading: controller.isLoading.value,
          expanded: true,
          height: 56,
        ),

        if (!controller.isFromSettings.value) ...[
          const SizedBox(height: 12),

          // Skip button
          PlatformButton.text(
            text: 'Skip for now',
            onPressed: controller.skipCurrencySetup,
          ),
        ],
      ],
    ));
  }
}

