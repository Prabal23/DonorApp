import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'state.dart';


ThunkAction <AppState> data = (Store<AppState> store) async{
    store.dispatch(store.state.demoState);
};
