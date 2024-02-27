import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class TawkChatScreen extends StatefulWidget {
  const TawkChatScreen({super.key});

  @override
  State<TawkChatScreen> createState() => _TawkChatScreenState();
}

class _TawkChatScreenState extends State<TawkChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ThemeProvider>(context, listen: false).darkTheme
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor,
        title: const Text(
          'Chat Support',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/65dc67f29131ed19d971ae21/1hnifc3f1',
        visitor: TawkVisitor(
          name: 'MAIDC',
          email: 'maidcecom@gmail.com',
        ),
        onLoad: () {
          print('Hello Tawk!');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
