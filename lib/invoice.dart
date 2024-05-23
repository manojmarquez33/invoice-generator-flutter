import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFF1493), // Set the primary color to pink
      ),
      home: InvoiceScreen(),
    );
  }
}

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String shopName = 'Jeeva Admin Solution Services';
  String billNumber = '';
  String customerName = '';
  DateTime? selectedDate;
  String typeOfWork = '';
  List<Map<String, dynamic>> tableData = [];
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    "Generate Invoice",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  )),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Text(
                              'Customer Name:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              decoration: InputDecoration(),
                              onChanged: (value) {
                                customerName = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 28.0),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Date:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  '${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ''}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                                SizedBox(width: 18.0),
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text('Select Date'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Bill :',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              decoration: InputDecoration(),
                              onChanged: (value) {
                                billNumber = value;
                              },
                            ),
                            // SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title of Work'),
                    onChanged: (value) {
                      typeOfWork = value;
                    },
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  // Wrap the Table with a Container and set a maximum width
                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 800), // Adjust the width as needed
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      4.0), // Reduce padding for "S.No"
                                  child: Center(
                                    // Center the content horizontally
                                    child: Text(
                                      'S.No',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            18, // Adjust the font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    // Center the content horizontally
                                    child: Text(
                                      'Particulars',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            18, // Adjust the font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    // Center the content horizontally
                                    child: Text(
                                      'Amount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            18, // Adjust the font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          for (int i = 0; i < tableData.length; i++)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    // Center the content horizontally
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          4.0), // Reduce padding for "S.No"
                                      child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                          fontSize:
                                              16, // Adjust the font size as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    // Center the content horizontally
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        tableData[i]['particulars'],
                                        style: TextStyle(
                                          fontSize:
                                              16, // Adjust the font size as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    // Center the content horizontally
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        tableData[i]['amount'].toString(),
                                        style: TextStyle(
                                          fontSize:
                                              16, // Adjust the font size as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          TableRow(
                            children: [
                              TableCell(child: SizedBox.shrink()),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment
                                    .middle, // Align vertically in the middle
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    // Center the content horizontally and vertically
                                    child: Text(
                                      'Total Amount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            18, // Adjust the font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  // Center the content horizontally
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      totalAmount.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            18, // Adjust the font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController particularsController =
                                TextEditingController();
                            TextEditingController amountController =
                                TextEditingController();

                            return AlertDialog(
                              title: Text('Add Item'),
                              content: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Reduce the height of the dialog
                                children: [
                                  TextFormField(
                                    controller: particularsController,
                                    decoration: InputDecoration(
                                        labelText: 'Particulars'),
                                  ),
                                  TextFormField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration(labelText: 'Amount'),
                                  ),
                                  SizedBox(
                                      height:
                                          16.0), // Add spacing below text fields
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          String particulars =
                                              particularsController.text;
                                          String amountText =
                                              amountController.text;

                                          if (particulars.isEmpty) {
                                            // Show an error message if particulars are empty
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Particulars cannot be empty'),
                                              ),
                                            );
                                            return;
                                          }

                                          if (amountText.isEmpty) {
                                            // Show an error message if amount is empty
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Amount cannot be empty'),
                                              ),
                                            );
                                            return;
                                          }

                                          double amount =
                                              double.tryParse(amountText) ??
                                                  0.0;
                                          int roundedAmount = amount.round();

                                          tableData.add({
                                            'particulars': particulars,
                                            'amount': roundedAmount,
                                          });

                                          totalAmount += roundedAmount;

                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.orange,
                                          onPrimary: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                16.0, // Increase vertical padding
                                            horizontal:
                                                32.0, // Increase horizontal padding
                                          ),
                                        ),
                                        child: Text('Add Item',
                                            style: TextStyle(
                                                fontSize:
                                                    18)), // Increase button font size
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0, // Increase vertical padding
                          horizontal: 32.0, // Increase horizontal padding
                        ),
                      ),
                      child: Text(
                        'Add Item',
                        style: TextStyle(
                          fontSize: 18, // Increase button font size
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(height: 32.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _printInvoice();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0, // Increase vertical padding
                          horizontal: 40.0, // Increase horizontal padding
                        ),
                      ),
                      child: Text(
                        'Print Invoice',
                        style: TextStyle(
                          fontSize: 20, // Increase button font size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _printInvoice() async {
    final pdf = pw.Document();

    final templateImage = pw.MemoryImage(
      File('assets/template.jpg').readAsBytesSync(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Row(
            children: [
              // First Half of the A4 sheet
              pw.Container(
                width: PdfPageFormat.a4.width / 2,
                height: PdfPageFormat.a4.height,
                child: pw.Stack(
                  children: [
                    pw.Image(templateImage),
                    // Overlay "Customer Name" onto the template
                    pw.Positioned(
                      left: 70.0,
                      top: 90.0,
                      child: pw.Text(
                        '$customerName',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                    // Overlay "Bill Number" onto the template
                    pw.Positioned(
                      left: 100.0,
                      top: 250.0,
                      child: pw.Text(
                        '$billNumber',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                    // Overlay "Date" onto the template
                    pw.Positioned(
                      left: 100.0,
                      top: 300.0,
                      child: pw.Text(
                        '${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ''}',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                    // Add items from tableData
                    for (var i = 0; i < tableData.length; i++)
                      pw.Positioned(
                        left: 100.0,
                        top: 350.0 + i * 30.0,
                        child: pw.Row(
                          children: [
                            pw.Text((i + 1).toString()),
                            pw.SizedBox(width: 20),
                            pw.Text(tableData[i]['particulars']),
                            pw.SizedBox(width: 20),
                            pw.Text(tableData[i]['amount'].toString()),
                          ],
                        ),
                      ),
                    // Add the Total Amount
                    pw.Positioned(
                      left: 100.0,
                      top: 350.0 + tableData.length * 30.0,
                      child: pw.Row(
                        children: [
                          pw.Text('Total Amount:'),
                          pw.SizedBox(width: 20),
                          pw.Text(totalAmount.toStringAsFixed(2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Second Half of the A4 sheet (similar content as the first half)
              pw.Container(
                width: PdfPageFormat.a4.width / 2,
                height: PdfPageFormat.a4.height,
                child: pw.Stack(
                  children: [
                    pw.Image(templateImage),
                    // Overlay "Customer Name" onto the template
                    pw.Positioned(
                      left: 70.0,
                      top: 90.0,
                      child: pw.Text(
                        '$customerName',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                    // Overlay "Bill Number" onto the template
                    pw.Positioned(
                      left: 100.0,
                      top: 250.0,
                      child: pw.Text(
                        '$billNumber',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                    // Overlay "Date" onto the template
                    pw.Positioned(
                      left: 100.0,
                      top: 300.0,
                      child: pw.Text(
                        '${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ''}',
                        style: pw.TextStyle(fontSize: 18),
                      ),
                    ),
                    // Add items from tableData
                    for (var i = 0; i < tableData.length; i++)
                      pw.Positioned(
                        left: 100.0,
                        top: 350.0 + i * 30.0,
                        child: pw.Row(
                          children: [
                            pw.Text((i + 1).toString()),
                            pw.SizedBox(width: 20),
                            pw.Text(tableData[i]['particulars']),
                            pw.SizedBox(width: 20),
                            pw.Text(tableData[i]['amount'].toString()),
                          ],
                        ),
                      ),
                    // Add the Total Amount
                    pw.Positioned(
                      left: 100.0,
                      top: 350.0 + tableData.length * 30.0,
                      child: pw.Row(
                        children: [
                          pw.Text('Total Amount:'),
                          pw.SizedBox(width: 20),
                          pw.Text(totalAmount.toStringAsFixed(2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/invoice.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Print Preview'),
        content: Container(
          width: 600,
          height: 400,
          child: PdfPreview(
            build: (format) => pdf.save(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await Printing.layoutPdf(
                onLayout: (format) async => pdfFile.readAsBytes(),
              );
            },
            child: Text('Print'),
          ),
        ],
      ),
    );
  }
}
