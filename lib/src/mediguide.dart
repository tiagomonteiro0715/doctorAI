import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';

/// `MediGuideChatBot` is a `StatefulWidget` that creates a `_MediGuideChatBotState`
class MediGuideChatBot extends StatefulWidget {
  /// A constructor that is called when the widget is first created.
  const MediGuideChatBot({Key? key}) : super(key: key);

  /// `createState()` is a function that returns a State object
  @override
  State<MediGuideChatBot> createState() => _MediGuideChatBotState();
}

class _MediGuideChatBotState extends State<MediGuideChatBot> {
  /// Creating a text editing controller and a string.
  late TextEditingController _controller;
  String _prompt = ' ';

  /// `initState()` is a function that is called when the widget is first created.
  ///
  /// `super.initState()` is a function that is called when the widget is first created.
  ///
  /// `_controller` is a variable that is called when the widget is first created.
  ///
  /// `TextEditingController()` is a function that is called when the widget is first created.
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  /// It takes a string as input, and returns a string as output
  ///
  /// Args:
  ///   gptPrompt (String): This is the text that you want to use to generate the response.
  ///
  /// Returns:
  ///   A string of text.
  Future<String> _generateTextFromChatGPTAPI(String gptPrompt) async {
    /// This is where you put your API key.
    String API_KEY = "";
    OpenAI.apiKey = API_KEY;

    /// Checking if the prompt is empty. If it is not empty, it will return the text.
    if (gptPrompt != ' ') {
      final completion = await OpenAI.instance.completion.create(
        model: "text-davinci-003",
        prompt: """
I want you to explain and give me information about the disease $gptPrompt and suggest possible treatment methods. Do it in short sentences and with bullet points separated by new line.
""",
        maxTokens: 250,
      );
      return (completion.choices[0].text);
    }

    return ("""
      What is Mediguide?
      \nA Chat bot using chatGPT API used to provide information about diseases and conditions.
      \nHere to help people understand their health concerns.
     \n\nNOTICE
     \nThe information given by Mediguide shoul not be definitive. Further reasearch is recommended.
    \nPossible bias and harmful content may be produced due to limitations in training data and language patterns.
    \nLimited knowledge of world events beyond 2021 and specialized subjects may require fact-checking and awareness of my limitations.""");
  }

  /// It takes a string as input, and returns a string as output
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget.
  ///
  /// Returns:
  ///   A string.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Setting the background color of the app to a dark grey.
      backgroundColor: Color.fromARGB(255, 244, 243, 243),

      /// The above code is creating a text field and a button. When the button is pressed, the text field is
      /// cleared and the text is sent to the API. The API then returns a response.

      body: Column(
        /// Setting the space between the text field and the button.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        /// Aligning the text to the center.
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          /// Creating a text field.

          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "MediGuide",
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ),
          
          Expanded(
            /// The above code is using the FutureBuilder widget to display the data from the API.
            child: SingleChildScrollView(
              child: FutureBuilder<String>(
                future: _generateTextFromChatGPTAPI(_prompt),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
            
                  /// Checking if the snapshot has data. If it does, it will return the data.
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 1000,
                          height: 500,
                          padding: EdgeInsets.all(
                              14.0), // add some padding to the container
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255,
                                255), // set the background color to grey
                            borderRadius: BorderRadius.circular(
                                20.0), // set the border radius to 10
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 180, 175, 175),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            '${snapshot.data}',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ];
                  }
            
                  /// If the data is loading, show a progress indicator. If the data is done loading,
                  /// show the data. If the data failed to load, show an error message
                  ///
                  /// Args:
                  ///    (snapshot):
                  else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    ];
                  }
            
                  /// Showing the text "Type a message to start chatting" if the data is not loading.
                  else {
                    children = const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Type a message to start chatting',
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                      ),
                    ];
                  }
            
                  /// Returning the data.
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ),

            /// Returning the data.
          ),
          Container(
              padding: const EdgeInsets.all(16.0),
              color: Color.fromARGB(255, 244, 243, 243),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'What are your questions?',
                  labelStyle: TextStyle(
                    color:
                        Color.fromARGB(255, 0, 0, 0), // Change the color here
                    fontSize:
                        16.0, // You can also set other properties of the text style
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (String value) {
                  setState(() {
                    _prompt = value;
                  });
                },
              )),
        ],
      ),
    );
  }
}
