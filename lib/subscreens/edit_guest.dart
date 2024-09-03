import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mango_haus/models/models.dart';
import 'package:provider/provider.dart';
import 'package:mango_haus/managers/managers.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditGuest extends StatefulWidget {
  final List<Guest> suggestions;

  const EditGuest({super.key, required this.suggestions});

  @override
  State<EditGuest> createState() => _EditGuestState();
}

class _EditGuestState extends State<EditGuest> {
  Guest? guest;
  TextEditingController guestNameTEC = TextEditingController();
  TextEditingController guestName_tec = TextEditingController();
  TextEditingController phone_tec = TextEditingController();
  FocusNode node1 = FocusNode();
  File? fileImage;
  String countryName = '', countryFlag = '', phoneNumber = '', countryKey = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orange, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.5, 0.9],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Edit Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.orangeAccent, width: 1),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(-2, -2)),
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(2, 2))
                    ]),
                child: RawAutocomplete(
                  textEditingController: guestNameTEC,
                  focusNode: node1,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      for (int i = 0; i < widget.suggestions.length; i++)
                        matches.add(widget.suggestions[i].name);
                      matches.retainWhere((s) {
                        return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                      return matches;
                    }
                  },
                  onSelected: (String selection) async {
                    guest = await Provider.of<GuestManager>(context, listen: false)
                        .getGuest(selection.toLowerCase().trim());
                    if (guest != null) {
                      guestName_tec.text = guest!.name;
                      phoneNumber = guest!.phoneNumber;
                    }
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          labelText: 'guest name',
                          labelStyle: TextStyle(fontSize: 20, color: Colors.green),
                          prefixIcon: Icon(Icons.contact_page_outlined, color: Colors.green),
                          border: InputBorder.none),
                    );
                  },
                  optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                      Iterable<String> options) {
                    return Material(
                        child: SizedBox(
                            height: 200,
                            child: SingleChildScrollView(
                                child: Column(
                              children: options.map((opt) {
                                return InkWell(
                                    onTap: () {
                                      onSelected(opt);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.only(right: 60),
                                        child: Card(
                                            child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          child: Text(opt),
                                        ))));
                              }).toList(),
                            ))));
                  },
                ),
              ),
              Container(
                width: 350,
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black)),
                      ),
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            'Guest Name: ',
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(border: Border.all(), color: Colors.grey),
                              child: TextField(
                                controller: guestName_tec,
                                decoration: InputDecoration(
                                    labelText: guest?.name != null ? guest?.name : 'Guest Name',
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    filled: true,
                                    fillColor: Colors.grey,
                                    disabledBorder: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          guest?.phoneNumber != null
                              ? Text('Phone Number: ${guest?.phoneNumber}')
                              : Text('Phone Number: None'),
                          SizedBox(
                            width: 4,
                          ),
                          guest?.nationality != null
                              ? Text(' - Nationality: ${guest?.nationality}')
                              : Text(' -  Nationality : None'),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black)),
                      ),
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                blurStyle: BlurStyle.inner,
                                offset: Offset(-2, -2)),
                            BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                blurStyle: BlurStyle.inner,
                                offset: Offset(2, 2))
                          ],
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(countryFlag),
                                Text('+$countryKey'),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 160,
                                  child: TextField(
                                    controller: phone_tec,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) => setState(() {
                                      phoneNumber = '+$countryKey $value';
                                    }),
                                    decoration: InputDecoration(
                                      hintText: 'phone number',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () => showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  onSelect: (Country country) {
                                    setState(() {
                                      countryName = country.name;
                                      countryFlag = country.flagEmoji;
                                      countryKey = country.phoneCode;
                                    });
                                  }),
                              child: Text('Country'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                          BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurStyle: BlurStyle.outer),
                          BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.white.withOpacity(0.4),
                              offset: Offset(2, 2),
                              blurStyle: BlurStyle.inner)
                        ]),
                        child:
                            fileImage == null && (guest == null || guest!.passportImagePath.isEmpty)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                pickImage(ImageSource.camera);
                                              },
                                              icon: Icon(
                                                Icons.camera_alt_sharp,
                                                size: 50,
                                              ),
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  pickImage(ImageSource.gallery);
                                                },
                                                icon: Icon(
                                                  Icons.drive_folder_upload,
                                                  size: 50,
                                                )),
                                            Spacer()
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : fileImage == null &&
                                        guest != null &&
                                        guest!.passportImagePath.isNotEmpty
                                    ? Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                fileImage = null;
                                                guest?.passportImagePath = '';
                                              });
                                            },
                                            icon: const Icon(Icons.highlight_remove_sharp),
                                            iconSize: 30,
                                          ),
                                          Image.network('${guest?.passportImagePath}'),
                                        ],
                                      )
                                    : fileImage != null
                                        ? Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    fileImage = null;
                                                    guest?.passportImagePath = '';
                                                  });
                                                },
                                                icon: const Icon(Icons.highlight_remove_sharp),
                                                iconSize: 30,
                                              ),
                                              Image.file(
                                                fileImage!,
                                                fit: BoxFit.fill,
                                              )
                                            ],
                                          )
                                        : Text('No Document Available'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 50,
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.orange))),
                  ),
                  onPressed: () async {
                    if (guestNameTEC.text.isNotEmpty) {
                      if (fileImage != null) {
                        if (guest != null && guest!.passportImagePath.isNotEmpty)
                          FirebaseStorage.instance.ref().child(guest!.passportImagePath).delete();
                        FirebaseStorage storage = FirebaseStorage.instance;
                        Reference ref =
                            storage.ref().child('passports').child('${guest!.name}.jpg');
                        UploadTask uploadTask = ref.putFile(fileImage!);
                        TaskSnapshot snapshot = await uploadTask;
                        String downloadUrl = await snapshot.ref.getDownloadURL();
                        guest?.passportImagePath = downloadUrl;
                      }
                      if (guest != null) {
                        Guest updatedGuest = Guest(
                            guest!.passportImagePath, phoneNumber, countryName,
                            name: guestName_tec.text);
                        await Provider.of<GuestManager>(context, listen: false)
                            .changeGuestInfo(guest!, updatedGuest);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: Text('Info Changed'),
                                    content: Text('${guest?.name} info successfully changed'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            guestNameTEC.clear();
                                            guestName_tec.clear();
                                            phone_tec.clear();
                                            guest = null;
                                            phoneNumber = '';
                                            countryName = '';
                                            countryKey = '';
                                            countryFlag = '';
                                            fileImage = null;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Continue'),
                                      )
                                    ]));
                      }
                    }
                  },
                  child: Text('Change Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        fileImage = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
