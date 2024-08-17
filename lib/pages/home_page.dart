import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:space_pod/bloc/chat_bloc.dart';
import 'package:space_pod/models/chat_message_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;

              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.5,
                      image: AssetImage("assets/space_bg.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Space Pod",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 34),
                          ),
                          Icon(
                            Icons.image_search,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin:  const EdgeInsets.only(top: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.blueAccent.withOpacity(0.1),
                                  ),
                                  child:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(messages[index].role == 'user' ? 'User' : 'Space Pod',
                                          style:TextStyle(
                                            fontSize: 14,
                                            color: messages[index].role == "user" ? Colors.amber : Colors.green

                                          ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(messages[index].parts.first.text),
                                        ],
                                      ));
                            })),
                    if (chatBloc.generating) Container(
                        height: 54,
                        width: 54,
                        child: Lottie.asset('assets/loader.json')),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                fillColor: Colors.white,
                                hintText: "ask something from AI",
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Add some spacing between the TextField and the button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // White background for the button
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor, // Deep purple border color
                                width: 2, // Border width
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.send,
                                  color: Theme.of(context).primaryColor),
                              onPressed: () {
                                if (textEditingController.text.isNotEmpty) {
                                  String text = textEditingController.text;
                                  textEditingController.clear();
                                  chatBloc.add(ChatGenerateNewTextMessageEvent(
                                      inputMessage: text));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
