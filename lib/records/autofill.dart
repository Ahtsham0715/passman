// import 'package:autofill_service/autofill_service.dart';
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';

// final _logger = Logger('main');

// class AutofillPage extends StatefulWidget {
//   @override
//   _AutofillPageState createState() => _AutofillPageState();
// }

// class _AutofillPageState extends State<AutofillPage> {
//   bool? _hasEnabledAutofillServices;

//   AutofillMetadata? _metadata;

//   @override
//   void initState() {
//     super.initState();
//     _updateStatus();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> _updateStatus() async {
//     _hasEnabledAutofillServices =
//         await AutofillService().hasEnabledAutofillServices;
//     _metadata = await AutofillService().getAutofillMetadata();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//      _logger.info(
//         'Building AppState. defaultRouteName:${WidgetsBinding.instance.window.defaultRouteName}');
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('AutoFill Service'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(
//                   'hasEnabledAutofillServices: $_hasEnabledAutofillServices\n', style: TextStyle( fontSize: 25.0)),
//               Text(
//                   'metadata: ${_metadata == null ? 'none' : _metadata?.toJson().toString()}', style: TextStyle( fontSize: 25.0)),
//               ElevatedButton(
//                 child: const Text('Request Autofill Service', style: TextStyle( fontSize: 25.0)),
//                 onPressed: () async {
//                  print('Starting request.');
                 
//                   final response =
//                       await AutofillService().requestSetAutofillService();
//                  print('request finished $response');
//                   await _updateStatus();
//                 },
//               ),
//               ElevatedButton(
//                 child: const Text('finish', style: TextStyle(
//                   fontSize: 25.0
//                 )),
//                 onPressed: () async {
//                   print('Starting request.');
                  
//                   AutofillService().setPreferences(AutofillPreferences(enableDebug: true, ));
//                   final response = await AutofillService().resultWithDataset(
//                     label: 'com.example.passman',
//                     username: 'shami@gmail.com',
//                     password: 'shami123',
//                   );
//                   var _autofillStatus = await AutofillService().status();
// print('status: $_autofillStatus');
//                   print('resultWithDataset $response');
//                   await _updateStatus();
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }