import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipotatotimer/services/database_services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> model = <String, dynamic>{};
  Duration duration = const Duration(hours: 1, minutes: 23, seconds: 5);
  AudioPlayer audioPlayer = AudioPlayer();

  String filePath = 'audio/dhoom.mp3';
  PlayerState playerState = PlayerState.paused;
  int count = 5;
  Timer? timer;
  countDown(int count) {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (count > 0) {
          setState(() {
            count--;
          });
          if (kDebugMode) {
            print(count);
          }
        }
      },
    );
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
    await audioPlayer.pause();
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
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              snapshot.data?[index]?['duration']
                                      .substring(0, 10) ??
                                  '',
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
                                playerState == PlayerState.playing
                                    ? pauseMusic()
                                    : playMusic();
                              },
                              icon: Icon(playerState == PlayerState.playing
                                  ? Icons.pause
                                  : Icons.play_arrow),
                            ),
                            IconButton(
                              onPressed: () {
                                pauseMusic();
                              },
                              icon: const Icon(Icons.stop),
                            ),
                          ],
                        ),
                        ListTile(
                          title: Text(
                            snapshot.data?[index]?['title'] ?? '',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor),
                          ),
                          subtitle:
                              Text(snapshot.data?[index]?['description'] ?? ''),
                        )
                      ],
                    ),
                  ),
                );
              },
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
                    DatabaseServices.instance.addTask(model);
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
