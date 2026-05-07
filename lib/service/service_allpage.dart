import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/service/service_data.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class ServiceAllPage extends StatelessWidget {
  final Function(int) onTabChange;
  const ServiceAllPage({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    void goBack() async {
      Navigator.pop(context, false);
    }

    return Scaffold(
      appBar: appBar(
        title: "บริการ",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
        rightAction: () => {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final service = services[index];

            return _serviceCard(service, context);
          },
        ),
      ),
    );
  }

  Widget _serviceCard(ServiceItem service, BuildContext context) {
    return InkWell(
      onTap: () {
        service.onTap(context, onTabChange);
      },
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(service.image, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 36,
                color: AppColors.primary,
                alignment: Alignment.center,
                child: Text(
                  service.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
