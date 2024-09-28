import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:erailpass_mobile/common/date_util.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/context/station_model.dart';
import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/services/ticket_service.dart';
import 'package:erailpass_mobile/widgets/charge_fine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../models/ticket.dart';

class CheckTicket extends StatefulWidget {
  final int role;

  const CheckTicket({super.key, required this.role});

  @override
  State<CheckTicket> createState() => _TicketState();
}

class _TicketState extends State<CheckTicket> {
  bool _barcodeAlreadyFound = false;
  bool _isLoading = false;
  Ticket? _ticket;
  String? _jwtPublicKey;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    rootBundle.loadString('assets/qr_jwt_public.key').then((key) => _jwtPublicKey = key);
    super.initState();
  }

  void handleFoundBarcode(BarcodeCapture capture, BuildContext context) {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;
    if (_jwtPublicKey == null) {
      showToast("key not available verify QR code");
      return;
    }
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      if (barcode.rawValue == null) {
        continue;
      }
      try {
        // Verify a token (SecretKey for HMAC & PublicKey for all the others)
        final jwt = JWT.verify(barcode.rawValue!, RSAPublicKey(_jwtPublicKey!));
        debugPrint('Payload: ${jwt.payload}');
        Map<String, dynamic> payload = jwt.payload;

        StationModel stationModel = Provider.of<StationModel>(context, listen: false);
        List<Station> stations = stationModel.getAll();
        Station? from = stations.firstWhereOrNull((s) => s.name == payload['from']);
        Station? to = stations.firstWhereOrNull((s) => s.name == payload['to']);
        if (from == null || to == null) {
          debugPrint('Invalid ticket stations');
        }
        Ticket t = Ticket(
          payload['_id'],
          payload['price'],
          from!,
          to!,
          dateFromString(payload['date']),
          payload['isPaid'],
          payload['tClass'],
          payload['noOfTickets'],
          null,
        );
        setState(() {
          _ticket = t;
        });
        debugPrint('Payload: ${t}');
        break;
      } on JWTExpiredException {
        showToast('jwt expired');
      } on JWTException catch (ex) {
        showToast(ex.message); // ex: invalid signature
      }
    }
  }

  void markChecked() async {
    setState(() {
      _isLoading = true;
    });
    await TicketService.markTicketChecked(_ticket?.id);
    setState(() {
      _barcodeAlreadyFound = false;
      _isLoading = false;
      _ticket = null;
    });
  }

  void markPaid() async {
    setState(() {
      _isLoading = true;
    });
    await TicketService.markTicketAsPaid(_ticket?.id);
    setState(() {
      _barcodeAlreadyFound = false;
      _isLoading = false;
      _ticket = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Ticket'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            color: Colors.grey,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.grey,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 20.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ticket != null ? TicketInfo(ticket: _ticket!) : const SizedBox.shrink(),
                const Divider(height: 30),
                buildTicketActions(context),
                Visibility(
                  visible: !_barcodeAlreadyFound,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: MobileScanner(
                        onDetect: (capture) {
                          if (!_barcodeAlreadyFound) {
                            handleFoundBarcode(capture, context);
                            setState(() {
                              _barcodeAlreadyFound = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isLoading && _barcodeAlreadyFound,
                  child: const SizedBox(
                    height: 200,
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTicketActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Visibility(
            visible: widget.role == Role.CHECKER && _ticket != null && !_ticket!.isPaid,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChargeFine(ticket: _ticket),
                  ),
                );
              },
              child: const Text('Charge Fine'),
            ),
          ),
          Visibility(
            visible: widget.role == Role.CHECKER && _ticket != null && _ticket!.isPaid,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.greenAccent)),
              onPressed: () => markChecked(),
              child: const Text('Mark as Checked'),
            ),
          ),
          Visibility(
            visible: widget.role == Role.STATION_MASTER && _ticket != null && !_ticket!.isPaid,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent)),
              onPressed: () => markPaid(),
              child: const Text('Mark as Paid', style: TextStyle(color: Colors.white)),
            ),
          ),
          Visibility(
            visible: _barcodeAlreadyFound,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _ticket = null;
                  _barcodeAlreadyFound = false;
                });
              },
              child: const Text('Continue Scanning'),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketInfo extends StatelessWidget {
  final Ticket ticket;
  final textStyle = const TextStyle(color: Colors.blueGrey, fontSize: 18);

  const TicketInfo({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(60),
        1: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            Text("From", style: textStyle),
            Text(
              ticket.startStation.name,
              style: TextStyle(
                fontSize: 18,
                color: ticket.isPaid ? Colors.green : Colors.redAccent,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text("To", style: textStyle),
            Text(
              ticket.endStation.name,
              style: TextStyle(
                fontSize: 18,
                color: ticket.isPaid ? Colors.green : Colors.redAccent,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text("Date", style: textStyle),
            Text(
              dateToString(ticket.date),
              style: TextStyle(
                fontSize: 18,
                color: ticket.isPaid ? Colors.green : Colors.redAccent,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text("Class", style: textStyle),
            Text(
              ticket.getTClass(),
              style: TextStyle(
                fontSize: 18,
                color: ticket.isPaid ? Colors.green : Colors.redAccent,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text("Paid", style: textStyle),
            Text(
              ticket.isPaid ? "YES" : "NO",
              style: TextStyle(
                fontSize: 18,
                color: ticket.isPaid ? Colors.green : Colors.redAccent,
              ),
            ),
          ],
        )
      ],
    );
  }
}
