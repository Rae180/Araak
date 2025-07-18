import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/ProductsFolder/Bloc/RoomDetailesBloc/room_details_bloc.dart';

class CustomizationsPage extends StatefulWidget {
  static const String routeName = '/customizations_screen';
  final int? id;
  const CustomizationsPage({super.key, this.id});

  @override
  State<CustomizationsPage> createState() => _CustomizationsPageState();
}

class _CustomizationsPageState extends State<CustomizationsPage> {
  final TextEditingController _woodType = TextEditingController();
  final TextEditingController _woodColor = TextEditingController();
  final TextEditingController _FabricType = TextEditingController();
  final TextEditingController _FabricColors = TextEditingController();
  final TextEditingController _Length = TextEditingController();
  final TextEditingController _Width = TextEditingController();
  final TextEditingController _Hieght = TextEditingController();
  String? selectedValue;
  List<String> options = ["Wood", "Fabric", "Metal", "Glass"];
  int? _selectedItemIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => RoomDetailsBloc(client: NetworkApiServiceHttp())
        ..add(GetRoomDetailes(roomId: widget.id)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Customize Your Item',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<RoomDetailsBloc, RoomDetailsState>(
          builder: (context, state) {
            if (state is RoomDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            } else if (state is RoomDetailsSuccess) {
              return Column(
                children: [
                  // Item Selection Section
                  _buildItemSelectionPanel(context, state, theme),

                  // Customization Form
                  if (_selectedItemIndex != null)
                    Expanded(child: _buildCustomizationForm(theme))
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Choose an item to customize',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            } else if (state is RoomDetailesError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildItemSelectionPanel(
      BuildContext context, RoomDetailsSuccess state, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.tcSQ-uvCb_Z1uCLSHDiYXQHaE8?r=0&rs=1&pid=ImgDetMain&cb=idpwebp2&o=7&rm=3',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.room.room!.name!,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Base Price: \$${state.room.room!.price!}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'Assembly Time: ${state.room.room!.time!}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Item Selection Title
                    Text(
                      'Select Item to Customize:',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    // Items List
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.room.room!.items!.length,
                        itemBuilder: (context, index) {
                          final item = state.room.room!.items![index];
                          final isSelected = _selectedItemIndex == index;

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedItemIndex = index),
                            child: Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.1)
                                    : theme.cardTheme.color,
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.dividerTheme.color!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Item Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.imageUrl ??
                                            'https://via.placeholder.com/100',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 80,
                                          height: 80,
                                          color:
                                              theme.colorScheme.surfaceVariant,
                                          child: Icon(
                                            Icons.error,
                                            color: theme.colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Item Details
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name!,
                                            style: theme.textTheme.bodyLarge,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'ID: ${item.id}',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                          Text(
                                            'Price: \$${item.price!.toStringAsFixed(2)}',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                          if (isSelected) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              'Selected',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationForm(ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.sectionPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wood Customization
            _buildCustomizationSection(
              title: 'Wood Customization',
              theme: theme,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedValue,
                  decoration: InputDecoration(
                    labelText: 'Wood Type',
                    prefixIcon:
                        Icon(Icons.forest, color: theme.iconTheme.color),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                    ),
                  ),
                  icon:
                      Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
                  onChanged: (value) => setState(() => selectedValue = value),
                  items: options
                      .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _woodColor,
                  decoration: InputDecoration(
                    labelText: 'Wood Color',
                    hintText: 'e.g. Ebony Black',
                    prefixIcon:
                        Icon(Icons.color_lens, color: theme.iconTheme.color),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius)),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            // Fabric Customization
            _buildCustomizationSection(
              title: 'Fabric Customization',
              theme: theme,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedValue,
                  decoration: InputDecoration(
                    labelText: 'Fabric Type',
                    prefixIcon:
                        Icon(Icons.texture, color: theme.iconTheme.color),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                    ),
                  ),
                  icon:
                      Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
                  onChanged: (value) => setState(() => selectedValue = value),
                  items: options
                      .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _FabricColors,
                  decoration: InputDecoration(
                    labelText: 'Fabric Color',
                    hintText: 'e.g. Navy Blue',
                    prefixIcon:
                        Icon(Icons.color_lens, color: theme.iconTheme.color),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            // Dimensions
            _buildCustomizationSection(
              title: 'Dimension Adjustments',
              theme: theme,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _Length,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Length (cm)',
                          prefixIcon: Icon(Icons.straighten,
                              color: theme.iconTheme.color),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _Width,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Width (cm)',
                          prefixIcon: Icon(Icons.straighten,
                              color: theme.iconTheme.color),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _Hieght,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon:
                        Icon(Icons.height, color: theme.iconTheme.color),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                    ),
                  ),
                ),
              ],
            ),

            // Warning Banner
            _buildWarningBanner(theme),

            // Action Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.check, color: theme.colorScheme.onPrimary),
                label: Text(
                  'Confirm Customizations',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.cardRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationSection({
    required String title,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner(ThemeData theme) {
    return Card(
      color: theme.colorScheme.errorContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Wood type not found. Please select a valid option.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
