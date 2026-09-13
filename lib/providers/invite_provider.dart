import 'dart:async';

import 'package:bill_splitter/models/group_invite.dart';
import 'package:bill_splitter/services/invite_service.dart';
import 'package:flutter/material.dart';

class InviteProvider extends ChangeNotifier{
  List<GroupInvite> inviteList = [];
  final inviteService = InviteService();
  StreamSubscription<List<GroupInvite>>? _inviteSubscription;
  InviteProvider(){
    _inviteSubscription = inviteService.pendingInvites.listen((invites){
      inviteList = invites;
      notifyListeners();
    });
  }
  @override
  void dispose(){
    _inviteSubscription?.cancel();
    super.dispose();
  }

  Future<void> rejectInvitation(String inviteID) async{
    await inviteService.rejectInvitation(inviteID);
  }
  void removeInvite(GroupInvite invite) {
    inviteList.remove(invite);
    notifyListeners();
  }
  void restoreInvite(GroupInvite invite){
    inviteList.add(invite);
    notifyListeners();
  }
  Future<void> acceptInvitation(GroupInvite invite) async{
    removeInvite(invite);
    try {
      await inviteService.acceptInvitation(invite.inviteID!);
    } catch (e) {
      restoreInvite(invite);
      rethrow;
    }
  }
}