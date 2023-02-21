import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Duration duration = const Duration(hours: 1, minutes: 23, seconds: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Potato Timer'),
      ),
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
                      onChanged: (value) {},
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
                      onChanged: (value) {},
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
                                  setState(() => duration = newDuration!);
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
                FilledButton(onPressed: () {}, child: const Text('Add Task'))
              ],
            ),
          ),
        ),
        child: const Icon(Icons.add_circle_outline),
      ),
    );
  }
}
