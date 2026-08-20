import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:fitness_app/core/apiUrls/api_urls.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class ExerciseDetailPage extends StatefulWidget {
  final ExerciseEntity exercise;
  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  String _getAbsoluteUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    final baseUrl = Uri.parse(ApiUrls.baseUrl).origin;
    var finalPath = path;

    if (finalPath.startsWith('/vedio/')) {
      final fileName = finalPath.split('/').last;
      finalPath = '/media/$fileName';
    }

    if (!finalPath.startsWith('/')) {
      if (!finalPath.contains('/')) {
        finalPath = '/media/$finalPath';
      } else {
        finalPath = '/$finalPath';
      }
    }

    return '$baseUrl$finalPath';
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final videoUrl = _getAbsoluteUrl(widget.exercise.videoUrl);

      print('Exercise video original: ${widget.exercise.videoUrl}');
      print('Exercise video final: $videoUrl');

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await _videoPlayerController!.initialize();

      final localizations = AppLocalizations.of(context)!;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              localizations.errorLoadingVideo,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Exercise video error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final imageUrl = _getAbsoluteUrl(widget.exercise.imageUrl);

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          localizations.exerciseDetailTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _isPlaying && _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : Stack(
                        children: [
                          if (imageUrl.isNotEmpty)
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: const Color(0xFF2B2D3F)),
                            )
                          else
                            Container(color: const Color(0xFF2B2D3F)),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0x00000000), Color(0x66000000)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          if (_isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Center(
                              child: GestureDetector(
                                onTap: _initializeVideo,
                                child: Container(
                                  width: 52.w,
                                  height: 52.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          if (!_isPlaying && !_isLoading)
                            Positioned(
                              left: 16.w,
                              bottom: 16.h,
                              child: Text(
                                widget.exercise.title.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              widget.exercise.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            // Display Category/Equipment as chips
            Wrap(
              spacing: 8.w,
              children: [
                _detailChip(widget.exercise.category, const Color(0xFF223522)),
                _detailChip(widget.exercise.equipment, const Color(0xFF3A3A55)),
                _detailChip(
                  widget.exercise.difficulty,
                  const Color(0xFF553A3A),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              widget.exercise.description,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailChip(String label, Color color) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Chip(
      label: Text(
        label,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
      side: BorderSide.none,
    );
  }
}
