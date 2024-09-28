import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/train.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TrainResult extends StatefulWidget {
  const TrainResult({super.key, required this.from, required this.to, required this.date});

  final Station from;
  final Station to;
  final DateTime? date;

  @override
  State<TrainResult> createState() => _TrainResultState();
}

class _TrainResultState extends State<TrainResult> {
  final List<Train> _trains = [];

  final dio = Dio();

  void getHttp() async {
    final response = await dio.get('https://dart.dev');
    debugPrint(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.from.name} - ${widget.to.name}"),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                  ),
                  child: const Text(
                    "Buy Ticket",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: _trains.map((t) => TrainResultEntry(train: t, from: widget.from, to: widget.to)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrainResultEntry extends StatelessWidget {
  final Train train;
  final Station from;
  final Station to;

  const TrainResultEntry({super.key, required this.train, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    String? fromTime = train.stops.firstWhereOrNull((s) => s.station.id == from.id)?.time;
    String? toTime = train.stops.firstWhereOrNull((s) => s.station.id == to.id)?.time;
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    train.trainNo ?? "",
                    style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    train.name ?? "",
                    style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(from.name ?? "", style: const TextStyle(color: Colors.blueGrey)),
                      Text(
                        fromTime ?? "10.30",
                        style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const Expanded(child: Padding(padding: EdgeInsets.only(top: 10))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(to.name ?? "", style: const TextStyle(color: Colors.blueGrey)),
                      Text(
                        toTime ?? "14.55",
                        style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
