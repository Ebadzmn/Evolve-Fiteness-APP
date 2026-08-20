import 'dart:io';
import 'package:fitness_app/core/bloc/locale_cubit.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:fitness_app/features/timeline/presentation/bloc/timeline_bloc.dart';
import 'package:fitness_app/features/timeline/presentation/bloc/timeline_event.dart';
import 'package:fitness_app/features/timeline/presentation/bloc/timeline_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/core/bloc/nav_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const ProfileLoadRequested()),
        ),
        BlocProvider(
          create: (_) => sl<TimelineBloc>(),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  void _showLogoutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF13131F),
        title: Text(
          localizations.profileLogoutTitle,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          localizations.profileLogoutMessage,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.profileLogoutCancel,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.go('/login');
            },
            child: Text(
              localizations.profileLogoutConfirm,
              style: GoogleFonts.poppins(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final bloc = context.read<ProfileBloc>();
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      bloc.add(ProfileImageUpdateRequested(File(image.path)));
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF13131F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        final localizations = AppLocalizations.of(context)!;
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    localizations.profileCamera,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    localizations.profileGallery,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
  Color _getPhaseColor(String phase) {
    switch (phase) {
      case 'Pre Prep Phase':
        return const Color(0xFF00A9E0);
      case 'Health Phase':
        return const Color(0xFF009B91);
      case 'Diet Phase':
        return const Color(0xFF1B75BC);
      case 'Offseason':
        return const Color(0xFF008B5E);
      case 'Prep':
        return const Color(0xFFF7941D);
      case 'Peak Week':
        return const Color(0xFFED1C24);
      case 'Diet-Break':
        return const Color(0xFF92278F);
      case 'Reverse Diet Phase':
        return const Color(0xFFD91C5C);
      case 'Other':
        return const Color(0xFF58595B);
      case 'No Phase':
        return const Color(0xFF1B2631);
      default:
        return const Color(0xFFD4AF37);
    }
  }

  Widget _tableRow(String week, String date, String phase, Color phaseColor) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  week,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF2C2C3E),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: phaseColor,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Text(
                  phase,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showTableRow(
    String name,
    String date,
    String division,
    String location,
    String countdown,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF2C2C3E),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                child: Text(
                  date,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                child: Text(
                  division,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF2C2C3E),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                child: Text(
                  location,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                child: Text(
                  countdown,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF82C941), size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              color: valueColor ?? Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.profileAppBarTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leadingWidth: 110.w,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: CircleAvatar(
                backgroundColor: Colors.white10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    context.read<NavBloc>().add(const NavEvent(0));
                  },
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Badge(
                backgroundColor: Colors.red,
                smallSize: 8,
                child: Icon(Icons.notifications_none, color: Colors.white),
              ),
              onPressed: () {
                context.push(AppRoutes.notificationPage);
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _LanguageToggleButton(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage ||
            previous.successMessage != current.successMessage,
        listener: (context, state) {
          if (state.status == ProfileStatus.success && state.profile != null) {
            final timelineState = context.read<TimelineBloc>().state;
            if (timelineState is TimelineInitial) {
              context.read<TimelineBloc>().add(FetchTimeline(state.profile!.athlete.id));
            }
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          } else if (state.successMessage != null &&
              state.successMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.failure) {
            return Center(
              child: Text(
                localizations.trainingExerciseGenericError,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state.status == ProfileStatus.success && state.profile != null) {
            final profile = state.profile!;
            final athlete = profile.athlete;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: state.isUpdatingImage
                          ? null
                          : () => _showImageSourceSheet(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Builder(
                            builder: (context) {
                              ImageProvider? provider;
                              if (state.tempImagePath != null &&
                                  state.tempImagePath!.isNotEmpty) {
                                provider = FileImage(
                                  File(state.tempImagePath!),
                                );
                              } else if (athlete.image.isNotEmpty) {
                                final value = athlete.image;
                                if (value.startsWith('http')) {
                                  provider = NetworkImage(value);
                                } else if (value.startsWith('file://')) {
                                  provider = FileImage(
                                    File(Uri.parse(value).path),
                                  );
                                } else {
                                  final normalizedPath = value.startsWith('/')
                                      ? value
                                      : '/$value';
                                  provider = NetworkImage(
                                    'https://api.evolveapp.fit$normalizedPath',
                                  );
                                }
                              }

                              return CircleAvatar(
                                radius: 40.r,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: provider,
                                child: provider == null
                                    ? Icon(
                                        Icons.person_outline,
                                        size: 40.sp,
                                        color: Colors.white,
                                      )
                                    : null,
                              );
                            },
                          ),
                          if (state.isUpdatingImage)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Personal Data
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF13131F),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF2E2E5D)),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          Icons.person_outline,
                          localizations.profileSectionPersonalData,
                        ),
                        SizedBox(height: 16.h),
                        _infoRow(
                          localizations.profileLabelFullName,
                          athlete.name,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelEmail,
                          athlete.email,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelGender,
                          athlete.gender,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Athlete Info
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF13131F),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF2E2E5D)),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          Icons.person_outline,
                          localizations.profileSectionAthleteInfo,
                        ),
                        SizedBox(height: 16.h),
                        _infoRow(
                          localizations.profileLabelStatus,
                          athlete.status,
                          valueColor: const Color(0xFFFFCC00),
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelCategory,
                          athlete.category,
                          valueColor: Colors.green,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelCheckInDay,
                          athlete.checkInDay,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelHeight,
                          '${athlete.height} (cm)',
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelAge,
                          '${athlete.age} ${localizations.profileLabelAgeYearsSuffix}',
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(localizations.profileLabelGoal, athlete.goal),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelTrainingDaySteps,
                          '${athlete.trainingDaySteps} ${localizations.profileLabelStepsSuffix}',
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelRestDaySteps,
                          '${athlete.restDaySteps} ${localizations.profileLabelStepsSuffix}',
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Account
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF13131F),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF2E2E5D)),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          Icons.person_outline,
                          localizations.profileSectionAccount,
                          iconColor: Colors.yellow,
                        ),
                        SizedBox(height: 16.h),
                        _infoRow(
                          localizations.profileLabelRole,
                          athlete.role,
                          valueColor: const Color(0xFFFFCC00),
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelCoach,
                          profile.coachName,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          localizations.profileLabelMemberSince,
                          _formatDate(athlete.createdAt),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Show Information
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF13131F),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF2E2E5D)),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          Icons.emoji_events_outlined,
                          localizations.profileSectionShowInfo,
                          iconColor: Colors.green,
                        ),
                        SizedBox(height: 16.h),
                        if (profile.show.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Header
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      topRight: Radius.circular(8.r),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          localizations.profileLabelShowName,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 16.h,
                                        color: Colors.white24,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          localizations.profileLabelShowDate,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 16.h,
                                        color: Colors.white24,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          localizations.profileLabelDivision,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 16.h,
                                        color: Colors.white24,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          localizations.profileLabelLocation,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 16.h,
                                        color: Colors.white24,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          localizations.profileLabelCountdown,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Rows
                                ...profile.show.map((item) {
                                  return _showTableRow(
                                    item.name,
                                    _formatDate(item.date),
                                    item.division,
                                    item.location,
                                    '${item.countDown} ${localizations.profileLabelDaysSuffix}',
                                  );
                                }),
                              ],
                            ),
                          )
                        else
                          Text(
                            localizations.profileEmpty,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Table
                  BlocBuilder<TimelineBloc, TimelineState>(
                    builder: (context, timelineState) {
                      if (timelineState is TimelineLoading || timelineState is TimelineInitial) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            children: [
                              _buildTimelineHeader(localizations),
                              for (int i = 0; i < 3; i++)
                                Shimmer.fromColors(
                                  baseColor: Colors.white12,
                                  highlightColor: Colors.white24,
                                  child: _tableRow('Week ${i + 1}', 'Loading...', 'Loading...', Colors.grey),
                                ),
                            ],
                          ),
                        );
                      }

                      if (timelineState is TimelineEmpty) {
                        return Center(
                          child: Text(
                            'No timeline data available',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }

                      if (timelineState is TimelineLoaded) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.r),
                              topRight: Radius.circular(8.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildTimelineHeader(localizations),
                              ...timelineState.timelineData.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                  return _tableRow(
                                    'Week ${index + 1}',
                                    _formatDate(item.date),
                                    item.phase,
                                    _getPhaseColor(item.phase),
                                  );
                              }),
                            ],
                          ),
                        );
                      }

                      if (timelineState is TimelineError) {
                        return Center(
                          child: Text(
                            timelineState.message,
                            style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 14.sp),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              localizations.profileEmpty,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
  Widget _buildTimelineHeader(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              localizations.profileTimelineHeaderWeek,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 16.h,
            color: Colors.white24,
          ),
          Expanded(
            flex: 2,
            child: Text(
              localizations.profileTimelineHeaderDate,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 16.h,
            color: Colors.white24,
          ),
          Expanded(
            flex: 2,
            child: Text(
              localizations.profileTimelineHeaderPhase,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isEnglish = locale.languageCode == 'en';
    final label = isEnglish ? 'EN' : 'DE';

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Colors.white.withOpacity(0.8),
      ),
      onPressed: () {
        context.read<LocaleCubit>().toggleLocale();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
