class AppState{
 var demoState;
 dynamic unseenState;
 dynamic seenState;
 


 AppState({this.demoState,this.unseenState, this.seenState});

 AppState copywith({demoState,unseenState,seenState}){
   return AppState(
     demoState: demoState?? this.demoState,
     unseenState: unseenState?? this.unseenState,
     seenState: seenState?? this.seenState
    
   );
 }
}