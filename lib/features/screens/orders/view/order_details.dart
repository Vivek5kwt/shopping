// Order Detail Screen
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/features/auth/model/order_model.dart';
import 'package:shop/utils/responsive/responsive.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';
import 'package:shop/utils/theme/colors.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: responsive.padding(all: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: responsive.iconSize(20),
                    ),
                    color: const Color(0xFF2D3142),
                  ),
                  Expanded(
                    child: ResponsiveText(
                      'Order Details',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: responsive.spacing(48)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: responsive.padding(all: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info Card
                    for (int i = 0; i < widget.order.products.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: responsive.spacing(8)),
                        child: Container(
                          padding: responsive.padding(all: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: responsive.spacing(20),
                                offset: Offset(0, responsive.spacing(4)),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: responsive.spacing(90),
                                height: responsive.spacing(90),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F6FA),
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(15),
                                  ),
                                ),
                                child: Center(
                                  child: RoundedImage(
                                    height: responsive.spacing(60),
                                    width: responsive.spacing(60),
                                    image: widget.order.products[i].images[0],
                                    isNetworkImage: true,
                                  ),
                                ),
                              ),
                              SizedBox(width: responsive.spacing(16)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ResponsiveText(
                                      widget.order.products[i].name,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2D3142),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ResponsiveSizedBox(height: 8),
                                    ResponsiveText(
                                      widget.order.id,
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ResponsiveSizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ResponsiveText(
                                          '\$${widget.order.products[i].price.toStringAsFixed(2)}',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: TColors.tealColor,
                                        ),
                                        ResponsiveText(
                                          'Qty: ${widget.order.quantity[i]}',
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ResponsiveSizedBox(height: 24),
                    ResponsiveText(
                      'Order Details',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                    ResponsiveSizedBox(height: 16),
                    Container(
                      padding: responsive.padding(all: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: responsive.spacing(20),
                            offset: Offset(0, responsive.spacing(4)),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            responsive,
                            'Ordered Placed',
                            DateFormat().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                widget.order.orderedAt,
                              ),
                            ),
                          ),
                          ResponsiveSizedBox(height: 6),
                          _buildDetailRow(responsive, 'Shipping Fee', '\$10.0'),
                          ResponsiveSizedBox(height: 6),
                          _buildDetailRow(
                            responsive,
                            'Total Price',
                            '\$${widget.order.totalPrice.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                    ResponsiveSizedBox(height: 16),
                    // Tracking Section
                    ResponsiveText(
                      'Order Tracking',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                    ResponsiveSizedBox(height: 16),

                    // Tracking Stepper
                    Container(
                      padding: responsive.padding(all: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: responsive.spacing(20),
                            offset: Offset(0, responsive.spacing(4)),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.light(
                            primary: Colors.orange,
                          ),
                        ),
                        child: Stepper(
                          currentStep: currentStep,
                          connectorThickness: responsive.isSmallMobile
                              ? 1.5
                              : 2,
                          connectorColor:
                              WidgetStateProperty.resolveWith<Color>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.orange;
                                }
                                return Colors.grey.shade300;
                              }),
                          controlsBuilder: (context, details) {
                            return const SizedBox.shrink();
                          },
                          steps: [
                            _buildStep(
                              responsive,
                              0,
                              "Order Placed",
                              "Your order has been confirmed",
                            ),
                            _buildStep(
                              responsive,
                              1,
                              "Processing",
                              "Order is being prepared",
                            ),
                            _buildStep(
                              responsive,
                              2,
                              "Shipped",
                              "Package is on the way",
                            ),
                            _buildStep(
                              responsive,
                              3,
                              "Delivered",
                              "Package has been delivered",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    ResponsiveUtils responsive,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ResponsiveText(label, fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(width: responsive.spacing(8)),
        Flexible(
          child: ResponsiveText(
            value,
            fontSize: 14,
            color: const Color(0xFF2D3142),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Step _buildStep(
    ResponsiveUtils responsive,
    int stepIndex,
    String title,
    String content,
  ) {
    return Step(
      stepStyle: StepStyle(
        color: currentStep >= stepIndex ? Colors.orange : Colors.grey.shade300,
        connectorColor: currentStep > stepIndex
            ? Colors.orange
            : Colors.grey.shade300,
      ),
      title: ResponsiveText(
        title,
        fontSize: 16,
        fontWeight: currentStep >= stepIndex
            ? FontWeight.bold
            : FontWeight.normal,
        color: currentStep >= stepIndex
            ? Colors.orange.shade800
            : Colors.grey.shade600,
      ),
      content: ResponsiveText(
        content,
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      isActive: currentStep >= stepIndex,
      state: currentStep > stepIndex
          ? StepState.complete
          : (currentStep == stepIndex ? StepState.indexed : StepState.disabled),
    );
  }
}
