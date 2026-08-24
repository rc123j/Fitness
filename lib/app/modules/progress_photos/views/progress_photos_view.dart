import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../progress/controllers/progress_controller.dart';

class ProgressPhotosView extends GetView<ProgressController> {
  const ProgressPhotosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: _glowBlob(const Color(0xffB100FF), 300),
          ),
          Positioned(
            bottom: 60,
            left: -120,
            child: _glowBlob(const Color(0xff00FF87), 320),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Obx(
                    () => GridView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: controller.transformationPhotos.length,
                      itemBuilder: (context, index) {
                        final key =
                            controller.transformationPhotos.keys.elementAt(index);
                        final url = controller.transformationPhotos[key] ?? '';
                        return _buildPhotoCard(key, url);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowBlob(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.16), Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 18, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Progress Photos",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Capture a photo at every milestone",
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String milestone, String url) {
    return GestureDetector(
      onTap: () => controller.handlePhotoAction(milestone),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff1B1430),
              const Color(0xff0D0818),
            ],
          ),
          border: Border.all(
            color: url.isNotEmpty
                ? const Color(0xffB100FF).withOpacity(0.55)
                : Colors.white.withOpacity(0.10),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: (url.isNotEmpty
                      ? const Color(0xffB100FF)
                      : Colors.black)
                  .withOpacity(url.isNotEmpty ? 0.18 : 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white38,
                    size: 32,
                  ),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffB100FF).withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Color(0xffB100FF),
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Add Photo",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Gradient scrim + label
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
                child: Text(
                  milestone,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (url.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.55),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
