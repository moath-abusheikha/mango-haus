import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/api/api.dart';
import 'package:mango_haus/managers/available_beds.dart';
import 'package:mango_haus/managers/managers.dart';
import 'package:mango_haus/models/models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class CheckIn extends StatefulWidget {
  final List<Guest> suggestions;

  const CheckIn({required this.suggestions, super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  GuestFireBaseApi fireBaseApi = GuestFireBaseApi();
  RoomsAndBedsApi roomsAndBeds = RoomsAndBedsApi();
  List<ReservationModel?> guestReservations = [];
  File? fileImage;
  final picker = ImagePicker();
  TextEditingController guestNameTEC = TextEditingController();
  TextEditingController totalPriceTEC = TextEditingController(text: '0');
  TextEditingController bedNumberTEC = TextEditingController(text: '1');
  List<RoomAvailability?> availableBeds = [];
  String roomName = 'Room';
  FocusNode node1 = FocusNode();
  String bookedFrom = 'Booking';
  String checkInRange = 'check in date - check out date';
  int nights = 1;
  double totalPrice = 0, commission = 0;
  String phoneNumber = 'phone number', bedNumber = 'Available Beds', guestPassportImgPath = '';
  int numberOfGuests = 1;
  Guest? guest;
  ReservationModel? currentReservation;
  List<RoomAvailability?> bedsAvailable = [];
  List<String> roomAvailableBeds = [];

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Check In'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.orangeAccent, width: 1),
                      boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
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
                      // print('You just selected $selection');
                      guest = await Provider.of<GuestManager>(context, listen: false)
                          .getGuest(selection.toLowerCase().trim());
                      if (guest != null) {
                        guestReservations =
                            await Provider.of<ReservationManager>(context, listen: false)
                                .getReservationByName(guest!.name.trim().toLowerCase());
                        print(guest!.name);
                        setState(() {
                          guestPassportImgPath = guest!.passportImagePath;
                        });
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
                            prefixIcon:
                                Icon(Icons.contact_page_outlined, color: Colors.orangeAccent),
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
                  height: 200,
                  child: ListView.builder(
                      itemCount: guestReservations.length,
                      itemBuilder: ((context, index) => Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  bedsAvailable.clear();
                                  availableBeds =
                                      await Provider.of<AvailableBeds>(context, listen: false)
                                          .getRoomAvailableBeds(guestReservations[index]!.room);
                                  print(availableBeds.length);
                                  setState(() {
                                    currentReservation = guestReservations[index];
                                    roomAvailableBeds.clear();
                                    roomAvailableBeds.add('Available Beds');
                                    for (int i = 0; i < availableBeds.length; i++) {
                                      roomAvailableBeds.add(availableBeds[i]!.bedNumber);
                                    }
                                    roomName = guestReservations[index]!.room;
                                    checkInRange = DateFormat('EEEE, d MMM, yyyy')
                                            .format(guestReservations[index]!.checkIn) +
                                        '-' +
                                        DateFormat('EEEE, d MMM, yyyy')
                                            .format(guestReservations[index]!.checkout);
                                    totalPrice = guestReservations[index]!.totalPrice;
                                    nights = guestReservations[index]!.nights;
                                    numberOfGuests = guestReservations[index]!.guestsCount;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                        // border: Border.all(color: Colors.orangeAccent, width: 1),
                                        boxShadow: [
                                          BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)
                                        ]),
                                    child: Text(DateFormat('EEEE, d MMM, yyyy')
                                            .format(guestReservations[index]!.checkIn) +
                                        '-' +
                                        DateFormat('EEEE, d MMM, yyyy')
                                            .format(guestReservations[index]!.checkout))),
                              ),
                            ],
                          ))),
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), color: Colors.white,
                            // border: Border.all(color: Colors.orangeAccent, width: 1),
                            boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                        child: Row(
                          children: [
                            Text('total price : '),
                            Text('${totalPrice}'),
                            Text(' JOD'),
                          ],
                        )),
                    Spacer(),
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                      child: roomAvailableBeds.length < 1
                          ? Text('available beds')
                          : DropdownButton<String>(
                              underline: const SizedBox(),
                              value: bedNumber,
                              items:
                                  roomAvailableBeds.map<DropdownMenuItem<String>>((String? value) {
                                return DropdownMenuItem<String>(
                                  value: value!,
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  bedNumber = value!;
                                });
                              },
                            ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 55,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                      child: Center(child: Text(roomName)),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 55,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                      child: Center(
                          child: Row(
                        children: [
                          Text(
                            checkInRange,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 70,
                      height: 55,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                      child: Center(
                          child: Row(
                        children: [
                          nights == 1
                              ? Text(
                                  '1 night',
                                  textAlign: TextAlign.end,
                                )
                              : Text(
                                  '${nights} nights',
                                  textAlign: TextAlign.end,
                                ),
                        ],
                      )),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.orangeAccent, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.orangeAccent)]),
                      child: Center(
                          child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.man,
                                size: 24,
                              ),
                              Text(numberOfGuests.toString()),
                            ],
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 4),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Colors.orange)),
                        child: fileImage == null && guestPassportImgPath.isEmpty
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
                                          onPressed: pickImageCamera,
                                          icon: Icon(
                                            Icons.camera_alt_sharp,
                                            size: 50,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: pickImageGallery,
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
                            : guestPassportImgPath.isNotEmpty && fileImage == null
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
                                      Image.network(guest!.passportImagePath),
                                    ],
                                  )
                                : Row(
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
                                      ),
                                    ],
                                  )),
                    Spacer()
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: 90,
                      height: 65,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.orange))),
                          ),
                          onPressed: () async {
                            if (guestNameTEC.text.isNotEmpty) {
                              FirebaseStorage storage = FirebaseStorage.instance;
                              Reference ref =
                                  storage.ref().child('passports').child('${guest!.name}.jpg');
                              UploadTask uploadTask = ref.putFile(fileImage!);
                              TaskSnapshot snapshot = await uploadTask;
                              String downloadUrl = await snapshot.ref.getDownloadURL();
                              guest?.passportImagePath = downloadUrl;
                              Provider.of<GuestManager>(context, listen: false).updateGuest(guest!);
                              currentReservation!.status = 'checkedIn';
                              currentReservation!.physicalCheckIn = DateTime.now();
                              currentReservation!.reservedBed = bedNumber;
                              await Provider.of<ReservationManager>(context, listen: false)
                                  .updateReservation(currentReservation);
                              roomsAndBeds.updateAvailability(
                                  currentReservation!.room, bedNumber, false);
                              Payment payment = Payment(
                                  receivedBy: '',
                                  guestName: guest!.name,
                                  paymentAmounts: [],
                                  paymentDates: [],
                                  remaining: currentReservation!.totalPrice);
                              await Provider.of<PaymentManager>(context, listen: false)
                                  .addGuestPayment(payment);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  new SnackBar(content: new Text('${guest?.name} checked in')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  new SnackBar(content: new Text('guest name can\'t be empty')));
                            }
                            setState(() {
                              guestNameTEC.text = '';
                              totalPriceTEC.text = 'total price';
                              bedNumber = 'Available Beds';
                              bedNumberTEC.text = '1';
                              roomName = 'Room';
                              checkInRange = 'check in Date - check out date';
                              nights = 0;
                              numberOfGuests = 0;
                              fileImage = null;
                              guest = null;
                              availableBeds.clear();
                              bedsAvailable.clear();
                            });
                          },
                          child: Text('Check In')),
                    ),
                    Spacer()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        fileImage = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
