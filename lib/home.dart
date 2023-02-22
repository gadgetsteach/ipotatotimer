import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipotatotimer/services/database_services.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> model = <String, dynamic>{};
  Duration duration = const Duration(hours: 1, minutes: 23, seconds: 5);
  DateTime startTime = DateTime(0, 02, 25);
  Duration remaining = DateTime.now().difference(DateTime(1, 09, 59));
  Timer? t;
  int hrs = 0, mins = 0, sec = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  String filePath = 'audio/dhoom.mp3';
  PlayerState playerState = PlayerState.paused;
  List<dynamic> isActive = List.filled(100, false);

  startTimer(DateTime eventTime, int index, Map<String, dynamic> model) async {
    setState(() {
      isActive[index] = true;
    });
    int timeDiff = eventTime.difference(DateTime.now()).inSeconds;

    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeDiff > 0) {
          if (isActive[index]) {
            if (eventTime != DateTime.now()) {
              timeDiff = timeDiff - 1;
            } else {
              pauseMusic();
              isActive[index] = false;
            }
          }
        } else {
          DatabaseServices.instance.updateTask({
            'id': model['id'],
            'title': model['title'],
            'description': model['description'],
            'duration': model['duration']
          });
          DatabaseServices.instance.updateTask({
            'id': model['id'],
            'title': model['title'],
            'description': model['description'],
            'duration': 'done'
          });
          playMusic();
          isActive[index] = false;
        }
        hrs = timeDiff ~/ (60 * 60) % 24;
        mins = (timeDiff ~/ 60) % 60;
        sec = timeDiff % 60;
      });
    });
  }

  void cancel(int index) {
    t?.cancel();
    setState(() {
      isActive[index] = false;
    });
  }

// listen state chnages
  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        playerState = s;
      });
    });

    super.initState();
  }

// dispose
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

// play music
  playMusic() async {
    await audioPlayer.play(AssetSource(filePath));
  }

  // Compulsory
  pauseMusic() async {
    await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Potato Timer'),
      ),
      body: FutureBuilder<dynamic>(
          future: DatabaseServices.instance.tasks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.length == 0) {
              return const Text("No data");
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          snapshot.data?[index]?['duration'] == 'done'
                              ? ListTile(
                                  iconColor:
                                      Theme.of(context).colorScheme.primary,
                                  leading: const Icon(Icons.graphic_eq),
                                  title: Text(
                                    'FINISHED',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.apply(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  trailing: const Icon(Icons.graphic_eq),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      // ignore: unrelated_type_equality_checks
                                      isActive[index]
                                          ? "$hrs:$mins:$sec"
                                          : (snapshot.data?[index]?['duration']
                                                  .substring(0, 7) ??
                                              ''),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        Duration eventTime = Duration(
                                            hours: int.parse(
                                                "${snapshot.data?[index]?['duration'].substring(0, 1)}"),
                                            minutes: int.parse(
                                                "${snapshot.data?[index]?['duration'].substring(2, 4)}"),
                                            seconds: int.parse(
                                                "${snapshot.data?[index]?['duration'].substring(5, 7)}"));
                                        if (kDebugMode) {
                                          print(eventTime);
                                        }
                                        isActive[index]
                                            ? cancel(index)
                                            : startTimer(
                                                DateTime.now().add(eventTime),
                                                index,
                                                snapshot.data[index]);
                                      },
                                      icon: Icon(isActive[index]
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cancel(index);
                                        pauseMusic();
                                      },
                                      icon: const Icon(Icons.stop),
                                    ),
                                  ],
                                ),
                          ListTile(
                            title: Text(
                              toBeginningOfSentenceCase(
                                  "${snapshot.data?[index]?['title'] ?? ''}")!,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor),
                            ),
                            subtitle: Text(
                                snapshot.data?[index]?['description'] ?? ''),
                          ),
                          const SizedBox(
                            height: 32.0,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: -4,
                      width: MediaQuery.of(context).size.width * 1,
                      child: snapshot.data?[index]?['duration'] == 'done'
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: FilledButton(
                                onPressed: () {
                                  setState(() {
                                    cancel(index);
                                    pauseMusic();
                                    DatabaseServices.instance
                                        .deleteTask(snapshot.data[index]['id']);
                                  });
                                },
                                child: const Text('MARK COMPLETE'),
                              ),
                            )
                          : const SizedBox.shrink())
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => StatefulBuilder(
            builder: (context, setChild1State) => AlertDialog(
              title: const Text('Add Task'),
              content: Form(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Title',
                      ),
                      onChanged: (value) {
                        setState(() {
                          model['title'] = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    TextFormField(
                      minLines: 5,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        labelText: 'Description',
                        hintText: 'e.g. john@gmail.com',
                      ),
                      onChanged: (value) {
                        model['description'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    const Text("Duration"),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setChildState) => Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              CupertinoTimerPicker(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                mode: CupertinoTimerPickerMode.hms,
                                initialTimerDuration: duration,
                                onTimerDurationChanged:
                                    (Duration? newDuration) {
                                  if (kDebugMode) {
                                    print(duration.inHours);
                                  }
                                  setChild1State(() {
                                    duration = newDuration!;
                                  });
                                  setChildState(() {
                                    duration = newDuration!;
                                  });
                                  setState(() {
                                    duration = newDuration!;
                                    model['duration'] = newDuration.toString();
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Save"),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                child: Text("${duration.inHours}"),
                              ),
                              const Text("HH")
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              ":",
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                child: Text("${duration.inMinutes}"),
                              ),
                              const Text("MM")
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              ":",
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                child: Text("${duration.inSeconds}"),
                              ),
                              const Text("SS")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      DatabaseServices.instance.addTask(model);
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Add Task'),
                )
              ],
            ),
          ),
        ),
        child: const Icon(Icons.add_circle_outline),
      ),
    );
  }
}
