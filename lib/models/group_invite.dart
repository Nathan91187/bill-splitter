class GroupInvite {
  final String? inviteID;
  final String groupID;
  final String senderID;
  final String receiverID;
  final String status;

  const GroupInvite({
     this.inviteID,
    required this.groupID,
    required this.senderID,
    required this.receiverID,
    required this.status,
  });
}