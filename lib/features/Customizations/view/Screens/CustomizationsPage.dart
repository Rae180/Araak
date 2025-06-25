import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomDetailsBloc(client: NetworkApiServiceHttp())
        ..add(GetRoomDetailes(roomId: widget.id)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Customize Your Item',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Times new Roman',
              letterSpacing: 0.0,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<RoomDetailsBloc, RoomDetailsState>(
          builder: (context, state) {
            if (state is RoomDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is RoomDetailsSuccess) {
              int? _selectedItemIndex;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://th.bing.com/th/id/OIP.tcSQ-uvCb_Z1uCLSHDiYXQHaE8?r=0&rs=1&pid=ImgDetMain&cb=idpwebp2&o=7&rm=3',
                              // state.room.room!.imageUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 17,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.room.room!.name!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.0,
                                      fontFamily: 'Times new Roman'),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: Text(
                                    'Base Price: \$${state.room.room!.price!}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black,
                                      letterSpacing: 0.0,
                                      fontFamily: 'Times new Roman',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: Text(
                                    'Assembly Time: ${state.room.room!.time!}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'Times new Roman',
                                      color: Colors.black,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Select Item to Customize:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      150, // Fixed height for horizontal list
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.room.room!.items!.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          state.room.room!.items![index];
                                      final isSelected =
                                          _selectedItemIndex == index;

                                      return GestureDetector(
                                        onTap: () => setState(
                                            () => _selectedItemIndex = index),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.blue
                                                  : Colors.grey,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    item.imageUrl ??
                                                        'https://via.placeholder.com/100',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Container(
                                                      width: 100,
                                                      height: 100,
                                                      color: Colors.grey[300],
                                                      child: Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 17),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain text column width
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4),
                                                        child: Text(
                                                          'ID: ${item.id}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            fontFamily:
                                                                'Times New Roman',
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        item.name!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'Times New Roman',
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4),
                                                        child: Text(
                                                          'Price: \$${item.price!.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            fontFamily:
                                                                'Times New Roman',
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      if (isSelected)
                                                        Text(
                                                          'Selected',
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Times New Roman',
                                                          ),
                                                        ),
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
                    if (_selectedItemIndex == null)
                      Center(
                        child: Text(
                          'Choose an item to customize',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 700,
                        child: SingleChildScrollView(
                          child: Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Wood Customization',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.0,
                                        fontFamily: 'Times new Roman',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x1A000000),
                                              offset: Offset(
                                                0,
                                                2,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                DropdownButton<String>(
                                                  value: selectedValue,
                                                  hint: Text(
                                                    'Select wood type',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Times new Roman',
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      selectedValue = value;
                                                    });
                                                  },
                                                  items: options.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  child: TextFormField(
                                                    controller: _woodColor,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Wood Color (e.g. Black)',
                                                      hintStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        color: Colors.grey,
                                                        letterSpacing: 0.0,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black26,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.redAccent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors.redAccent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        letterSpacing: 0.0,
                                                        fontFamily:
                                                            'Times new Roman'),
                                                    cursorColor:
                                                        Colors.grey[700],
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Fabric Customization',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.0,
                                        fontFamily: 'Times new Roman',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x1A000000),
                                              offset: Offset(
                                                0,
                                                2,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              DropdownButton<String>(
                                                value: selectedValue,
                                                hint: Text(
                                                  'Select Fabric type',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Times new Roman',
                                                  ),
                                                ),
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                ),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    selectedValue = value;
                                                  });
                                                },
                                                items: options.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: _FabricColors,
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Fabric Color (e.g. #4682B4)',
                                                    hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: Colors.grey,
                                                      letterSpacing: 0.0,
                                                      fontFamily:
                                                          'Times new Roman',
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.redAccent,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.redAccent,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w100,
                                                    letterSpacing: 0.0,
                                                    fontFamily:
                                                        'Times new Roman',
                                                  ),
                                                  cursorColor: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Dimension Adjustments',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.0,
                                        fontFamily: 'Times new Roman',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x1A000000),
                                              offset: Offset(
                                                0,
                                                2,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Length (cm)',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.0,
                                                            fontFamily:
                                                                'Times new Roman',
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _Length,
                                                            autofocus: false,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: '0',
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontFamily:
                                                                    'Times new Roman',
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontFamily:
                                                                  'Times new Roman',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            cursorColor: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Width (cm)',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.0,
                                                            fontFamily:
                                                                'Times new Roman',
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _Width,
                                                            autofocus: false,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: '0',
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontFamily:
                                                                    'Times new Roman',
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontFamily:
                                                                  'Times new Roman',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            cursorColor: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Height (cm)',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.0,
                                                            fontFamily:
                                                                'Times new Roman',
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _Hieght,
                                                            autofocus: false,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: '0',
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontFamily:
                                                                  'Times new Roman',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            cursorColor:
                                                                Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0x00FFF8E6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.warning_rounded,
                                                color: Color(0x00FFA000),
                                                size: 24,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Wood type not found. Please select a valid option.',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    color: Color(0x00FFA000),
                                                    letterSpacing: 0.0,
                                                    fontFamily:
                                                        'Times new Roman',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is RoomDetailesError) {
              return Center(
                child: Text(state.message),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
