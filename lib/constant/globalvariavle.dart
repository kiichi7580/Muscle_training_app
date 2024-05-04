import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/view/calendar/calendar_page.dart';
import 'package:muscle_training_app/view/tab_memo/tab_memo_page.dart';
import 'package:muscle_training_app/view/profile/profile_page.dart';
import 'package:muscle_training_app/view/timer/timer_page.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  CalendarPage(uid: FirebaseAuth.instance.currentUser!.uid),
  TabMemoPage(uid: FirebaseAuth.instance.currentUser!.uid),
  TimerPage(uid: FirebaseAuth.instance.currentUser!.uid),
  ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid),
];
