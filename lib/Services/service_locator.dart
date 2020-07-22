//import 'package:flutter_calls_messages/services/calls_and_messages_service.dart';
import 'package:get_it/get_it.dart';

import 'callAndMsgServices.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}