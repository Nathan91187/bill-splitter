import 'dart:async';

import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/services/group_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GroupProvider extends ChangeNotifier{
  List<BillGroup> groupList = [];
  GroupService groupService = GroupService();
  StreamSubscription<List<BillGroup>>? _groupSubscription;
  GroupProvider(){

    _groupSubscription = GroupService().groups.listen((groups){
      groupList = groups;
      notifyListeners();
    });
  }
  @override
  void dispose(){
    super.dispose();
    _groupSubscription?.cancel();
  }
  Future<void> addGroup (BillGroup group) async{
    await groupService.saveGroup(group);
  }
  Future<void> removeGroup(String groupID) async{
    await groupService.removeGroup(groupID);
  }

}