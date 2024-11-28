import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mango_haus/api/api.dart';
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
  List<RoomAvailability?> availableBeds = [];
  String roomName = 'Room';
  FocusNode node1 = FocusNode();
  String bookedFrom = 'Booking';
  String checkInRange = 'check in date - check out date';
  int nights = 1;
  double totalPrice = 0, commission = 0;
  String phoneNumber = 'phone number', bedNumber = 'Available Beds', guestPassportImgPath = '';
  int numberOfGuests = 1, numberOfBeds = 1;
  Guest? guest;
  ReservationModel? currentReservation;
  List<String> roomAvailableBeds = [];
  List<bool> roomAvailableValues = [];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage('images/paint-stain.png'), fit: BoxFit.cover),
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.5, 0.9],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Check In',
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
                        // print('******** ${widget.suggestions.length}');
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
                        guestReservations =
                            await Provider.of<ReservationManager>(context, listen: false)
                                .getReservationByName(guest!.name.trim().toLowerCase(), ['reserved']);
                       // print(guestReservations);
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
                  height: 150,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Choose Reservation (${guestReservations.length})',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
                      SizedBox(
                        height: 5,
                      ),
                      guestReservations.length == 0
                          ? Center(
                              child: Text('No data'),
                            )
                          : Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: scrollController,
                                thickness: 10,
                                scrollbarOrientation: ScrollbarOrientation.right,
                                trackVisibility: true,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(width: 2)),
                                  padding: EdgeInsets.only(left: 5, right: 15),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: guestReservations.length,
                                    itemBuilder: ((context, index) => GestureDetector(
                                          onTap: () async {
                                            roomAvailableBeds.clear();
                                            availableBeds.clear();
                                            roomAvailableValues.clear();
                                            availableBeds = await Provider.of<AvailableBeds>(
                                                    context,
                                                    listen: false)
                                                .getRoomAvailableBeds(
                                                    guestReservations[index]!.room);
                                            setState(() {
                                              currentReservation = guestReservations[index];
                                              if (currentReservation!.room.trim().toLowerCase() ==
                                                      'alfonso' ||
                                                  currentReservation!.room.trim().toLowerCase() ==
                                                      'mallika')
                                                numberOfBeds = currentReservation!.guestsCount;
                                              for (int i = 0; i < availableBeds.length; i++) {
                                                roomAvailableBeds.add(availableBeds[i]!.bedNumber);
                                                roomAvailableValues.add(false);
                                              }
                                              roomName = guestReservations[index]!.room;
                                              checkInRange = DateFormat('EEEE, d MMM, yyyy')
                                                      .format(guestReservations[index]!.checkIn) +
                                                  '-' +
                                                  DateFormat('EEEE, d MMM, yyyy')
                                                      .format(guestReservations[index]!.checkout);
                                              totalPrice = guestReservations[index]!.totalPrice;
                                              nights = guestReservations[index]!.nights;
                                              numberOfGuests =
                                                  guestReservations[index]!.guestsCount;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Colors.black,
                                                      offset: Offset(2, 2),
                                                      blurStyle: BlurStyle.outer),
                                                  BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Colors.white,
                                                      offset: Offset(2, 2),
                                                      blurStyle: BlurStyle.inner)
                                                ]),
                                            child: Text(DateFormat('EEEE, d MMM, yyyy')
                                                    .format(guestReservations[index]!.checkIn) +
                                                '-' +
                                                DateFormat('EEEE, d MMM, yyyy')
                                                    .format(guestReservations[index]!.checkout)),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  height: 210,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          child: Text(
                            'Guest Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
                        padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                        margin: EdgeInsets.all(5),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                          BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.black,
                              offset: Offset(2, 2),
                              blurStyle: BlurStyle.outer),
                          BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.white,
                              offset: Offset(2, 2),
                              blurStyle: BlurStyle.inner)
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('total price : '),
                                Text('${totalPrice}'),
                                Text(' JOD'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Reservation Date : $checkInRange',
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            nights == 1
                                ? Text(
                                    'Staying Duration : 1 night',
                                  )
                                : Text(
                                    'Staying Duration : ${nights} nights',
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Number Of Guests : ${numberOfGuests.toString()}')
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                            BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurStyle: BlurStyle.outer),
                            BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.white,
                                offset: Offset(2, 2),
                                blurStyle: BlurStyle.inner)
                          ]),
                          child: roomAvailableBeds.length < 1
                              ? Text('available beds')
                              : Column(
                                  children: [
                                    Center(
                                      child: numberOfBeds > 1
                                          ? Text(
                                              'Choose $numberOfBeds Beds',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            )
                                          : Text('choose bed'),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 40,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: roomAvailableBeds.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Checkbox(
                                                value: roomAvailableValues[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    roomAvailableValues[index] = value!;
                                                  });
                                                },
                                              ),
                                              Text('${roomAvailableBeds[index]}')
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                    ],
                  ),
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
                                  Image.network('${guest?.passportImagePath}'),
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
                              ),
                  ),
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
                            if (availableBeds.length == 0) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text('No reservation found'),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Back'))
                                        ],
                                      ));
                            } else if (guestNameTEC.text.isNotEmpty) {
                              FirebaseStorage storage = FirebaseStorage.instance;
                              Reference ref =
                                  storage.ref().child('passports').child('${guest!.name}.jpg');
                              if (fileImage != null) {
                                UploadTask uploadTask = ref.putFile(fileImage!);
                                TaskSnapshot snapshot = await uploadTask;
                                String downloadUrl = await snapshot.ref.getDownloadURL();
                                guest?.passportImagePath = downloadUrl;
                              }
                              List<String> guestReservedBeds = [];
                              for (int i = 0; i < roomAvailableValues.length; i++) {
                                if (roomAvailableValues[i] && availableBeds[i] != null) {
                                  roomsAndBeds.updateAvailability(
                                      currentReservation!.room, availableBeds[i]!.bedNumber, false);
                                  guestReservedBeds.add(availableBeds[i]!.bedNumber);
                                }
                              }
                              Provider.of<GuestManager>(context, listen: false).updateGuest(guest!);
                              currentReservation!.status = 'checkedIn';
                              currentReservation!.physicalCheckIn = currentReservation!.checkIn;
                              currentReservation!.reservedBeds = guestReservedBeds;
                              await Provider.of<ReservationManager>(context, listen: false)
                                  .updateReservation(currentReservation);
                              Payment payment = Payment(
                                  checkIn: currentReservation!.checkIn,
                                  checkOut: currentReservation!.checkout,
                                  receivedBy: '',
                                  guestName: guest!.name,
                                  paymentAmounts: [],
                                  paymentDates: [],
                                  remaining: currentReservation!.totalPrice);
                              await Provider.of<PaymentManager>(context, listen: false)
                                  .addGuestPayment(payment);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Check In Complete'),
                                  content: Text('${guest?.name} checked in'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            guestReservations.clear();
                                            guestNameTEC.text = '';
                                            totalPrice = 0.0;
                                            bedNumber = 'Available Beds';
                                            roomName = 'Room';
                                            checkInRange = 'check in Date - check out date';
                                            nights = 0;
                                            numberOfGuests = 0;
                                            fileImage = null;
                                            guest = null;
                                            availableBeds.clear();
                                            roomAvailableBeds.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Continue'))
                                  ],
                                ),
                              );
                            } else
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Wrong Selection'),
                                        content: Text(
                                            'Check in date should be greater than today\'s date'),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Continue'))
                                        ],
                                      ));
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
