import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:muscle_training_app/constant/colors.dart';

// class NotificationSettingPage extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: mainColor,
  //     appBar: AppBar(
  //       title: const Text(
  //         '通知設定',
  //       ),
  //       backgroundColor: blueColor,
  //     ),
  //     body: buildBody(),
  //   );
  // }

//   Widget buildBody() {
//     bool isAcceptNotification = false;
//     bool osNotificationPermission = false;

//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Consumer(
//         builder: (context, ref, _) {
//         ref
//           ..listen<AppLifecycleState>(
//             appLifecycleProvider,
//             (previous, next) {
//               if (previous == AppLifecycleState.inactive &&
//                   next == AppLifecycleState.resumed) {
//                 ref
//                     .read(notificationSettingPageProvider.notifier)
//                     .checkOsNotificationPermission();
//               }
//           },
//         )
//         ..listen(
//           userProvider.select((s) => s.user.isAcceptNotification),
//           (previous, next) {
//             if (previous != next) {
//               EasyLoading.dismiss();
//             }
//           },
//         );

//         final osNotificationPermission = ref.watch(
//           notificationSettingPageProvider
//               .select((s) => s.osNotificationPermission),
//         );

//         final isAcceptNotification = ref
//             .watch(userProvider.select((s) => s.user.isAcceptNotification));

//         return Column(
//         // child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 isAcceptNotification
//                     ? const Text('プッシュ通知')
//                     : const Text('プッシュ通知', style: TextStyle(
//                       color: blackColor,
//                     ),),
//                 // const Text('プッシュ通知'),
//                 CupertinoSwitch(
//                   value: isAcceptNotification,
//                   onChanged: (value) async {
//                     await EasyLoading.show();
//                     await ref
//                         .read(notificationSettingPageProvider.notifier)
//                         .updateUserIsAcceptNotification(value);
//                   },
//                 ),
//               ],
//             ),
//             if (isAcceptNotification == true &&
//                 osNotificationPermission == false)
//               Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(top: 33),
//                     child: Text(
//                       'OS本体の通知を許可する必要があります',
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 37),
//                     child: SizedBox(
//                       width: 141,
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           showCupertinoDialog(
//                             context: context,
//                             builder: (_) => buildAlertDialog(context),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           elevation: 0,
//                           backgroundColor: blueColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           '通知許可',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ));
//     // },
//     //   ),
//     );
//   }

//   Widget buildAlertDialog(BuildContext context) {
//     return CupertinoAlertDialog(
//       title: const Text(
//         '通知許可',
//       ),
//       content: const Text(
//         'デバイスの[設定]を開きます。\n通知を許可してください',
//       ),
//       actions: [
//         CupertinoDialogAction(
//           onPressed: () => Navigator.pop(context),
//           child: const Text(
//             'いいえ',
//           ),
//         ),
//         CupertinoDialogAction(
//           onPressed: () async {
//             await AppSettings.openNotificationSettings();
//             Navigator.pop(context);
//           },
//           child: const Text(
//             'はい',
//           ),
//         ),
//       ],
//     );
//   }
// }

// class NotificationSettingPage extends StatefulWidget {
//   @override
//   _NotificationSettingPageState createState() => _NotificationSettingPageState();
// }

// class _NotificationSettingPageState extends State<NotificationSettingPage> {
//   bool isAcceptNotification = false;
//   bool osNotificationPermission = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: mainColor,
//       appBar: AppBar(
//         title: const Text('通知設定'),
//         backgroundColor: blueColor,
//       ),
//       body: buildBody(),
//     );
//   }

//   Widget buildBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Consumer(
//         builder: (context, ref, _) {
//           ref.listen<AppLifecycleState>(
//             appLifecycleProvider,
//             (previous, next) {
//               if (previous == AppLifecycleState.inactive &&
//                   next == AppLifecycleState.resumed) {
//                 ref
//                     .read(notificationSettingPageProvider.notifier)
//                     .checkOsNotificationPermission();
//               }
//             },
//           );

//           ref.listen(
//             userProvider.select((s) => s.user.isAcceptNotification),
//             (previous, next) {
//               if (previous != next) {
//                 EasyLoading.dismiss();
//               }
//             },
//           );

//           osNotificationPermission = ref.watch(
//             notificationSettingPageProvider.select((s) => s.osNotificationPermission),
//           );

//           isAcceptNotification = ref.watch(
//             userProvider.select((s) => s.user.isAcceptNotification),
//           );

//           return Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   isAcceptNotification
//                       ? const Text('プッシュ通知')
//                       : const Text(
//                           'プッシュ通知',
//                           style: TextStyle(
//                             color: blackColor,
//                           ),
//                         ),
//                   CupertinoSwitch(
//                     value: isAcceptNotification,
//                     onChanged: (value) async {
//                       await EasyLoading.show();
//                       await ref
//                           .read(notificationSettingPageProvider.notifier)
//                           .updateUserIsAcceptNotification(value);
//                       setState(() {
//                         isAcceptNotification = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               if (isAcceptNotification && !osNotificationPermission)
//                 Column(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(top: 33),
//                       child: Text('OS本体の通知を許可する必要があります'),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 37),
//                       child: SizedBox(
//                         width: 141,
//                         height: 48,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             showCupertinoDialog(
//                               context: context,
//                               builder: (_) => buildAlertDialog(context),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             elevation: 0,
//                             backgroundColor: blueColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Text('通知許可'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget buildAlertDialog(BuildContext context) {
//     return CupertinoAlertDialog(
//       title: const Text('通知許可'),
//       content: const Text('デバイスの[設定]を開きます。\n通知を許可してください'),
//       actions: [
//         CupertinoDialogAction(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('いいえ'),
//         ),
//         CupertinoDialogAction(
//           onPressed: () async {
//             await AppSettings.openNotificationSettings();
//             Navigator.pop(context);
//           },
//           child: const Text('はい'),
//         ),
//       ],
//     );
//   }
// }