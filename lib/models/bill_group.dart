class BillGroup {
  final String groupName;
  final String creatorID;
  final List<String> memberIDs;
  final String? groupID;
  const BillGroup({
    required this.creatorID,
     this.groupID,
    required this.groupName,
    required this.memberIDs
});
}