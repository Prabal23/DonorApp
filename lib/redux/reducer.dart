import 'package:design_app/redux/action.dart';
import 'package:design_app/redux/state.dart';


AppState reducer(AppState state, dynamic action){

  if(action is DemoAction){
    return state.copywith(
      demoState: action.demoAction
    );
  }

  
  if(action is UnseenNotificationAction){
    return state.copywith(
      unseenState: action.unseenNotification
    );
  }

  if(action is SeenNotificationAction){
    return state.copywith(
      seenState: action.seenNotification
    );
  }
  return state;
}