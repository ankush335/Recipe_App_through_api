import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  var passTextEditController = TextEditingController();
  var nameTextEditController = TextEditingController();

  var name = "".obs;
  var pass = "".obs;

}