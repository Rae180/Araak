        // const SizedBox(height: 12),
                      // // Available Times Section with an IconButton to add slot.
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       "Available Times",
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: 'Times New Roman',
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     IconButton(
                      //       icon:
                      //           const Icon(Icons.add, color: Colors.deepOrange),
                      //       tooltip: "Add Available Time",
                      //       onPressed: () async {
                      //         // Pick a date.
                      //         final DateTime? date = await showDatePicker(
                      //           context: context,
                      //           initialDate: DateTime.now(),
                      //           firstDate: DateTime.now(),
                      //           lastDate: DateTime.now()
                      //               .add(const Duration(days: 365)),
                      //         );
                      //         if (date != null) {
                      //           // Pick the start time.
                      //           final TimeOfDay? startTime =
                      //               await showTimePicker(
                      //             context: context,
                      //             initialTime: TimeOfDay.now(),
                      //           );
                      //           if (startTime != null) {
                      //             // Pick the end time.
                      //             final TimeOfDay? endTime =
                      //                 await showTimePicker(
                      //               context: context,
                      //               initialTime: startTime,
                      //             );
                      //             if (endTime != null) {
                      //               setState(() {
                      //                 freeTimes.add({
                      //                   'date': date
                      //                       .toLocal()
                      //                       .toString()
                      //                       .split(' ')[0],
                      //                   'start': startTime.format(context),
                      //                   'end': endTime.format(context),
                      //                 });
                      //               });
                      //             }
                      //           }
                      //         }
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 8),
                      // // Display every free time slot the user has chosen.
                      // if (freeTimes.isNotEmpty)
                      //   Column(
                      //     children: freeTimes.map((freeTime) {
                      //       return ListTile(
                      //         dense: true,
                      //         contentPadding: EdgeInsets.zero,
                      //         title: Text(
                      //           freeTime['date'] ?? '',
                      //           style: const TextStyle(
                      //             fontFamily: 'Times New Roman',
                      //             fontSize: 14,
                      //           ),
                      //         ),
                      //         subtitle: Text(
                      //           "From ${freeTime['start']} to ${freeTime['end']}",
                      //           style: const TextStyle(
                      //             fontFamily: 'Times New Roman',
                      //             fontSize: 12,
                      //           ),
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
              