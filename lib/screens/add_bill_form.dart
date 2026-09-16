import 'package:bill_splitter/data/bill_form_data.dart';
import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/providers/group_provider.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/widgets/currency_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/section_header.dart';

class AddBillForm extends StatefulWidget {
  final Bill? bill;
  final String? groupID;
  const AddBillForm({super.key, this.bill, this.groupID});

  @override
  State<AddBillForm> createState() => _AddBillFormState();
}

class _AddBillFormState extends State<AddBillForm> {
  final _formKey = GlobalKey<FormState>();
  final billFormData = BillFormData();
  String noUserSelectedError = '';
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final userService = UserService();
  late Future<List<UserModel>> membersFuture;
  bool loading = false;
  Future<List<UserModel>> loadMembers() async {
    final groupProvider = context.read<GroupProvider>();
    final group = await groupProvider.groupService.findGroupByID(
      widget.groupID!,
    );
    if (group == null) {
      return [];
    }
    final users = await Future.wait(
      group.memberIDs.map((memberId) => userService.findUserById(memberId)),
    );
    return users.whereType<UserModel>().toList();
  }

  @override
  void initState() {
    super.initState();
    membersFuture = loadMembers();
    if (widget.bill != null) {
      billFormData.fromBill(widget.bill!, widget.groupID);
    }
  }

  @override
  void dispose() {
    billFormData.dispose();
    super.dispose();
  }

  Future<void> submitBill() async {
    setState(() {
      loading = true;
    });
    final billProvider = context.read<BillProvider>();
    await billProvider.addBill(
      billFormData.createBill(uid, widget.bill, widget.groupID),
    );
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.black87,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                widget.bill == null ? "Add Bill" : "Edit Bill",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        icon: Icons.receipt_long_outlined,
                        title: "Bill Information",
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        style: textFieldTextStyle,
                          controller: billFormData.titleController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Enter Bill Name";
                            }
                            return null;
                          },
                          decoration: textFieldDecoration.copyWith(
                            hintText: "Bill Name",
                            prefixIcon: Icon(
                                Icons.receipt_long_outlined,
                                size: 20,
                            )
                          ),
                        ),

                      const SizedBox(height: 28),
                      SectionHeader(
                        icon: Icons.attach_money,
                        title: "Currency",
                      ),
                      const SizedBox(height: 12),
                      CurrencyDropdown(billFormData: billFormData),
                      const SizedBox(height: 28),
                      SectionHeader(
                        icon: Icons.shopping_bag_outlined,
                        title: "Items",
                      ),
                      const SizedBox(height: 12),
                      ...billFormData.expenseFields.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final expense = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  style: textFieldTextStyle,
                                  controller: expense['name'],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Enter Item Name";
                                    }
                                    return null;
                                  },
                                  decoration: textFieldDecoration.copyWith(
                                    hintText: "Item",
                                    // prefixIcon: const Icon(
                                    //   Icons.shopping_bag_outlined,
                                    //   color: Colors.amber,
                                    //   size: 20,
                                    // ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  style: textFieldTextStyle,
                                  controller: expense['price'],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Enter Price";
                                    }

                                    final price = double.tryParse(val);

                                    if (price == null || price <= 0) {
                                      return "Invalid Price";
                                    }

                                    return null;
                                  },
                                  decoration: textFieldDecoration.copyWith(
                                    hintText: "Price",
                                    // prefixIcon: Icon(
                                    //   Icons.attach_money,
                                    //   color: Colors.amber,
                                    //     size: 20,
                                    // )
                                  ),
                                ),
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  style: textFieldTextStyle,
                                  controller: expense['quantity'],
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Enter Quantity";
                                    }

                                    final quantity = int.tryParse(val);

                                    if (quantity == null || quantity <= 0) {
                                      return "Invalid Quantity";
                                    }

                                    return null;
                                  },
                                  decoration: textFieldDecoration.copyWith(
                                    hintText: "Qty",
                                    // prefixIcon: const Icon(
                                    //   Icons.numbers,
                                    //   color: Colors.amber,
                                    //   size: 20,
                                    // ),
                                  ),
                                ),
                              ),

                              if (index != 0)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      billFormData.removeExpenseField(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.amber,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 4),

                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              billFormData.addExpenseField();
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.amber),
                          label: const Text(
                            "Add Item",
                            style: TextStyle(color: Colors.amber),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      SectionHeader(
                        icon: Icons.people_outline,
                        title: widget.groupID == null
                            ? "Participants"
                            : "Select Participants",
                      ),

                      const SizedBox(height: 12),
                      if (widget.groupID == null)
                        ...billFormData.participants.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final participant = entry.value;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: textFieldTextStyle,
                                    controller:
                                        participant.textEditingController,
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty) {
                                        return "Enter Participant Name";
                                      }
                                      return null;
                                    },
                                    decoration: textFieldDecoration.copyWith(
                                      hintText: "Participant Name",
                                      prefixIcon: Icon(
                                          Icons.person_outline,
                                        size: 20,
                                      )
                                    ),
                                  ),
                                ),

                                if (index != 0)
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        billFormData.removeParticipantField(
                                          index,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.amber,
                                    ),
                                  ),
                                if (widget.bill != null)
                                  if (index != 0)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.amber,
                                          checkColor: Colors.black,
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: billFormData
                                              .participants[index]
                                              .hasPaid,
                                          onChanged: (_) {
                                            setState(() {
                                              billFormData.toggleHasPaid(index);
                                            });
                                          },
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withOpacity(
                                              0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: const Text(
                                            'Paid',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                          );
                        }),
                      const SizedBox(height: 4),
                      if (widget.groupID == null)
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                billFormData.addParticipantField();
                              });
                            },
                            icon: const Icon(
                              Icons.person_add_outlined,
                              color: Colors.amber,
                            ),
                            label: const Text(
                              "Add Participant",
                              style: TextStyle(color: Colors.amber),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.amber),
                            ),
                          ),
                        ),
                      if (widget.groupID == null)
                        Text(
                          noUserSelectedError,
                          style: TextStyle(color: Colors.red),
                        ),
                      if (widget.groupID != null)
                        FutureBuilder<List<UserModel>>(
                          future: membersFuture,
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Loading();
                            }

                            if (userSnapshot.hasError) {
                              return const Text(
                                "Failed to load members",
                                style: TextStyle(color: Colors.white),
                              );
                            }

                            final users = userSnapshot.data ?? [];
                            billFormData.currUser = users.firstWhere(
                              (user) => user.uid == uid,
                            );

                            return Column(
                              children: users.where((user) => user.uid != uid).map((
                                user,
                              ) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF111111),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person_outline,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.displayName,
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              user.email,
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 13,
                                              ),
                                            ),

                                            if (widget.bill != null)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Checkbox(
                                                    activeColor: Colors.grey,
                                                    checkColor: Colors.black,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    value:
                                                        billFormData
                                                            .paymentStatus[user
                                                            .uid] ??
                                                        false,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        billFormData
                                                                .paymentStatus[user.uid] = value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: const Text(
                                                      'Paid',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),

                                      Checkbox(
                                        value: billFormData.selectedMembers.any(
                                          (selectedMember) =>
                                              selectedMember.uid == user.uid,
                                        ),
                                        activeColor: Colors.amber,
                                        checkColor: Colors.black,
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              billFormData.selectedMembers.add(
                                                user,
                                              );
                                            } else {
                                              billFormData.selectedMembers
                                                  .removeWhere(
                                                    (selectedMember) =>
                                                        selectedMember.uid ==
                                                        user.uid,
                                                  );
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                      const SizedBox(height: 12),
                      if (widget.groupID != null)
                        Text(
                          noUserSelectedError,
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.groupID != null) {
                                if (widget.bill == null) {
                                  if (billFormData.selectedMembers.isEmpty) {
                                    setState(() {
                                      noUserSelectedError =
                                          "Select a minimum of 1 member";
                                    });
                                    return;
                                  }
                                }
                                if (widget.bill != null) {
                                  if (billFormData.selectedMembers.length <=
                                      1) {
                                    setState(() {
                                      noUserSelectedError =
                                          "Select a minimum of 1 member";
                                    });
                                    return;
                                  }
                                }
                              } else {
                                if (widget.bill != null) {
                                  if (billFormData.participants.length == 1) {
                                    setState(() {
                                      noUserSelectedError =
                                          "Enter a minimum of 1 non-creator participant";
                                    });
                                    return;
                                  }
                                }
                              }
                              submitBill();
                            }
                          },
                          icon: Icon(
                            widget.bill == null
                                ? Icons.check
                                : Icons.save_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            widget.bill == null
                                ? "Create Bill"
                                : "Save Changes",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.amber,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
