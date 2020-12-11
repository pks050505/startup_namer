import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StartUp Generator',
      debugShowCheckedModeBanner: false,
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggetion = List<WordPair>();
  final _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 20);
  Widget _buildSuggetions() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final int index = i ~/ 2;
        if (index >= _suggetion.length) {
          _suggetion.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggetion[index]);
      },
    );
  }

  Widget _buildRow(WordPair word) {
    var alreadySaved = _saved.contains(word);
    return ListTile(
      title: Text(
        word.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(word);
          } else {
            _saved.add(word);
          }
        });
      },
    );
  }

  void _pushSaved() {
    final tiles = _saved.map(
      (WordPair word) => ListTile(
        title: Text(
          word.asPascalCase,
          style: _biggerFont,
        ),
      ),
    );
    final dividedTiles = ListTile.divideTiles(
      tiles: tiles,
      context: context,
    ).toList();
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggetions'),
          ),
          body: ListView(
            children: dividedTiles,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StartUp Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggetions(),
    );
  }
}
