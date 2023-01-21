// import 'package:accessibility_service/accessibility_service.dart';

// class MyAccessibilityService extends AccessibilityService {
//   @override
//   void onAccessibilityEvent(AccessibilityEvent event) {
//     // Get the source of the event
//     AccessibilityNodeInfo source = event.source;
//     if (source == null) {
//       return;
//     }

//     // Check if the source is an EditText
//     if (source.className == "android.widget.EditText") {
//       // Get the text of the source
//       String text = source.text.toString();
//       // Check if the text matches a specific pattern (e.g. "username" or "password")
//       if (text == "username") {
//         // Fill in the username
//         source.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT,
//             Arguments.fromBundle(Bundle().putString("ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE", "myusername")));
//       } else if (text == "password") {
//         // Fill in the password
//         source.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT,
//             Arguments.fromBundle(Bundle().putString("ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE", "mypassword")));
//       }
//     }
//   }

//   @override
//   void onInterrupt() {}
// }
