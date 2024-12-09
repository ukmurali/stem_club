import 'package:flutter/material.dart';
import 'package:otomatiksclub/colors/app_colors.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key, required this.plan});

  final Map<String, dynamic> plan;

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  List<Map<String, dynamic>> tableData = [
    {"clubName": "Robotics", "postCreate": false, "checked": false},
    {"clubName": "AI Club", "postCreate": false, "checked": false},
    {"clubName": "Tech Club", "postCreate": false, "checked": false},
  ];

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    if (widget.plan['name'] == 'Silver Plan' ||
        widget.plan['name'] == 'Diamond Plan') {
      for (var data in tableData) {
        data["postCreate"] = true;
        data["checked"] = true;
      }
    } else if (widget.plan['name'] == 'Bronze Plan') {
      for (var data in tableData) {
        data["postCreate"] = false;
        data["checked"] = false;
      }
    }
  }

  void _setPlan(List<Map<String, dynamic>> tableData, Map<String, dynamic> data,
      String planName) {
    if (planName == 'Bronze Plan' || planName == 'Gold Plan') {
      for (var item in tableData) {
        if (item != data) {
          item["checked"] = false;
          item["postCreate"] = false;
        }
      }
    }
  }

  bool _isAnyClubSelected() {
    return tableData.any((data) => data["checked"] == true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Ensures full width for the children
        children: [
          Text(
            widget.plan['name'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                widget.plan['discountPrice'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '/${widget.plan['planMode']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.plan['description']),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(100),
              1: FixedColumnWidth(70),
              2: FixedColumnWidth(70),
              3: FixedColumnWidth(70),
            },
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Club Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Post \nCreate',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Post \nView',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Action',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              ...tableData.map((data) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text(data["clubName"]))),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Icon(
                          data["postCreate"] ? Icons.check : Icons.close,
                          color: data["postCreate"] ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Checkbox(
                          value: data["checked"],
                          activeColor: AppColors.primaryColor,
                          checkColor: AppColors.textColor,
                          onChanged: (widget.plan['name'] == 'Silver Plan' ||
                                  widget.plan['name'] == 'Diamond Plan')
                              ? null
                              : (bool? value) {
                                  setState(() {
                                    data["checked"] = value;
                                    data["postCreate"] = value ?? false;
                                    _setPlan(
                                        tableData, data, widget.plan['name']);
                                  });
                                },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textColor,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _isAnyClubSelected()
                      ? () {
                          // Perform the confirmation action
                          Navigator.pop(context);
                        }
                      : null, // Disabled if no club is selected
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}