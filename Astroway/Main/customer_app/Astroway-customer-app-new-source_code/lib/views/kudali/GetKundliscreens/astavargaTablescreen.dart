// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controllers/kundliController.dart';
import '../../../model/kundlichartModel.dart';

class AshtakvargaTable extends StatefulWidget {
  final int? userid;
  const AshtakvargaTable({
    required this.userid,
    super.key,
  });

  @override
  State<AshtakvargaTable> createState() => _AshtakvargaTableState();
}

class _AshtakvargaTableState extends State<AshtakvargaTable> {
  final kundlicontroller = Get.find<KundliController>();
  AshtakvargaResponse? datalist;
  TapDownDetails? _doubleTapDetails;
  final _transformationController = TransformationController();
  @override
  void initState() {
    super.initState();
    loadDatafromApi();
  }

  loadDatafromApi() async {
    await kundlicontroller.getAstaVarga(widget.userid);
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position!.dx, -position.dy)
        ..scale(1.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (d) => _doubleTapDetails = d,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        boundaryMargin: EdgeInsets.all(10.0),
        minScale: 0.5,
        maxScale: 4.0,
        child: GetBuilder<KundliController>(
          builder: (kundlicontroller) => LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                      child: kundlicontroller.ashtakvargaPoints.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 7.h),
                                SizedBox(
                                  height: 6.h,
                                  child: Text(
                                    'Ashtakvarga Order',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ).tr(),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth,
                                    maxHeight: constraints.maxHeight,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: DataTable(
                                      border: TableBorder(
                                        left: BorderSide(
                                            color: Colors.black, width: 1),
                                        right: BorderSide(
                                            color: Colors.black, width: 1),
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1),
                                        top: BorderSide(
                                            color: Colors.black, width: 1),
                                        verticalInside: BorderSide(
                                            color: Colors.black, width: 1),
                                        horizontalInside: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      columns: [
                                        DataColumn(label: Text('')),
                                        ...List.generate(
                                          kundlicontroller
                                                  .ashtakvargaPoints.isNotEmpty
                                              ? kundlicontroller
                                                  .ashtakvargaPoints[0].length
                                              : 0,
                                          (index) => DataColumn(
                                              label: Text('Col ${index + 1}')),
                                        ),
                                      ],
                                      rows: [
                                        ...List.generate(
                                          kundlicontroller
                                              .ashtakvargaList.length,
                                          (index) => DataRow(
                                            cells: [
                                              DataCell(Text(kundlicontroller
                                                  .ashtakvargaList[index])),
                                              ...List.generate(
                                                kundlicontroller
                                                        .ashtakvargaPoints
                                                        .isNotEmpty
                                                    ? kundlicontroller
                                                        .ashtakvargaPoints[
                                                            index]
                                                        .length
                                                    : 0,
                                                (i) => DataCell(Text(
                                                  kundlicontroller
                                                      .ashtakvargaPoints[index]
                                                          [i]
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20.sp),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataRow(
                                          cells: [
                                            DataCell(Text('Total',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                            ...List.generate(
                                              kundlicontroller
                                                  .ashtakvargaTotal.length,
                                              (i) => DataCell(Text(
                                                kundlicontroller
                                                    .ashtakvargaTotal[i]
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.sp),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7.h),
                                SizedBox(
                                  height: 6.h,
                                  child: Text(
                                    'binnashtakvarga',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ).tr(),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth,
                                    maxHeight: constraints.maxHeight,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: DataTable(
                                      border: TableBorder(
                                        left: BorderSide(
                                            color: Colors.black, width: 1),
                                        right: BorderSide(
                                            color: Colors.black, width: 1),
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1),
                                        top: BorderSide(
                                            color: Colors.black, width: 1),
                                        verticalInside: BorderSide(
                                            color: Colors.black, width: 1),
                                        horizontalInside: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      columns: [
                                        ...List.generate(
                                          kundlicontroller.columns.length,
                                          (index) => DataColumn(
                                              label: Text(kundlicontroller
                                                  .columns[index])),
                                        ),
                                      ],
                                      rows: [
                                        ...List.generate(
                                          kundlicontroller.maxRows!.toInt(),
                                          (rowIndex) => DataRow(
                                            cells: [
                                              ...List.generate(
                                                kundlicontroller.columns.length,
                                                (colIndex) => DataCell(
                                                  Text(
                                                    kundlicontroller
                                                        .binnashtakvargaData![
                                                            kundlicontroller
                                                                    .columns[
                                                                colIndex]]![
                                                            rowIndex]
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20.sp,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: 100.w,
                              height: constraints.maxHeight,
                              child: Center(child: CircularProgressIndicator()),
                            )),
                  Positioned(
                    right: 5.w,
                    top: 5.w,
                    child: InkWell(
                        onTapDown: (d) => _doubleTapDetails = d,
                        onTap: _handleDoubleTap,
                        child: CircleAvatar(
                          radius: 3.h,
                          backgroundColor: Colors.black26,
                          child: Icon(
                            Icons.zoom_in,
                            size: 22.sp,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
