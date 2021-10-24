import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intrinsic_size_overflow_box/intrinsic_size_overflow_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntrinsicSizeOverflowBox Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _maxWidth = 300.0;
  var _width = _maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IntrinsicSizeOverflowBox Demo')),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: _maxWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Drag this slider to adjust the clip width.',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Slider(
                      value: _width,
                      min: 0,
                      max: _maxWidth,
                      label: _width.round().toString(),
                      onChanged: (value) => setState(() => _width = value),
                    ),
                  ),
                  Text(
                    'Text wrapping at ${_maxWidth.round()} pts, '
                    'but clipping at ${_width.round()} pts',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ClipRect(
                    child: SizedBox(
                      width: _width,
                      child: const IntrinsicSizeOverflowBox(
                        maxWidth: _maxWidth,
                        child: Text(_lorem),
                      ),
                    ),
                  ),
                  Text(
                    'A Row with an intrinsic size of ${_maxWidth.round()} pts, '
                    'clipping at ${_width.round()} pts',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ClipRect(
                    child: SizedBox(
                      width: _width,
                      child: IntrinsicSizeOverflowBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 100, height: 100, color: Colors.red),
                            Container(
                                width: 100, height: 100, color: Colors.green),
                            Container(
                                width: 100, height: 100, color: Colors.blue),
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
    );
  }
}

// cspell: disable
const _lorem = '''
Lorem dolor sed viverra ipsum nunc aliquet bibendum enim facilisis. Sagittis 
purus sit amet volutpat consequat mauris. Dolor sit amet consectetur adipiscing 
elit ut. Id leo in vitae turpis massa sed elementum.
''';
