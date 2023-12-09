import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String email = '';
  String message = '';
  String token = '';
  String toEmail = '';


  Future<void> fetchData() async {
    const url = "https://free-tempmail-api.p.rapidapi.com/newmail";

    final headers = {
      "X-RapidAPI-Key": "f8dc80a4f6mshd9276ef433304e8p1c5755jsnd7fe9f7b9aa3",
      "X-RapidAPI-Host": "free-tempmail-api.p.rapidapi.com"
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    final info = jsonDecode(response.body);
    final email = info["newmail"]["email"].toString();
    final token = info["newmail"]["token"].toString();

    const mailsUrl = "https://free-tempmail-api.p.rapidapi.com/mails";
    final mailsHeaders = {
      "mailtoken": token,
      "X-RapidAPI-Key": "f8dc80a4f6mshd9276ef433304e8p1c5755jsnd7fe9f7b9aa3",
      "X-RapidAPI-Host": "free-tempmail-api.p.rapidapi.com"
    };

    final mailsResponse = await http.get(Uri.parse(mailsUrl), headers: mailsHeaders);
    final mailsInfo = jsonDecode(mailsResponse.body);
    final message = mailsInfo["message"].toString();

    setState(() {
      this.email = email;
      this.token = token;
      this.message = message;
    });
  }

  Future<void> updateMessage() async {
    const mailsUrl = "https://free-tempmail-api.p.rapidapi.com/mails";
    final mailsHeaders = {
      "mailtoken": token,
      "X-RapidAPI-Key": "f8dc80a4f6mshd9276ef433304e8p1c5755jsnd7fe9f7b9aa3",
      "X-RapidAPI-Host": "free-tempmail-api.p.rapidapi.com"
    };

    final mailsResponse = await http.get(Uri.parse(mailsUrl), headers: mailsHeaders);
    final mailsInfo = jsonDecode(mailsResponse.body);
    final updatedMessage = mailsInfo["mails"][0]["intro"].toString();
    final toEmail = mailsInfo["mails"][0]["from"]["address"].toString();
    print(mailsInfo);
    setState(() {
      this.message = updatedMessage;
      this.toEmail = toEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FukEmail',
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:0.0,vertical:10),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset("assets/mail.png"),
                  ),
                  const Center(
                    child: Text("The temporary mail service allows you to obtain temporary or disposable emails for use as you wish.",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: fetchData,
                  child: const Text('Generate Email'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: updateMessage,
                  child: const Text('Refresh Message'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Email: $email',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: email));
                          final snackBar = SnackBar(
                            content: const Text('Copied'),
                            behavior: SnackBarBehavior.floating,
                            shape : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.purple, width: 2),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.copy_all),
                        color: Colors.purple,

                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'To : $toEmail',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Message: $message',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: message));
                          final snackBar = SnackBar(
                            content: const Text('Copied'),
                            behavior: SnackBarBehavior.floating,
                            shape : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.purple, width: 2),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.copy_all),
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Center(
              child: Text("version 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text('Developed By Vikramaditya', textAlign: TextAlign.center,),
      ),
    );
  }
}