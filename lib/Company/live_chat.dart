import 'package:flutter/material.dart';

class LiveChatPage extends StatefulWidget {
  @override
  _LiveChatPageState createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage> {
  final TextEditingController _textController = TextEditingController();
 var button_color=Colors.grey;
  void _handleSubmitted(String text) {
    _textController.clear();
    // TODO: Implement sending message
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              cursorColor: Colors.green.shade700,
              controller: _textController,
              onChanged: (a){
                setState(() {
                 button_color= a.isEmpty ? Colors.grey:Colors.green;
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: "Send a message",
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,color: button_color,),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    // TODO: Implement message list
    return ListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: Text("Live Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
