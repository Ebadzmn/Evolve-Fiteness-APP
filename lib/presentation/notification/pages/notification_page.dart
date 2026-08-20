import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/features/notification/domain/entities/note_entity.dart';
import 'package:fitness_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:fitness_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:fitness_app/features/notification/presentation/bloc/notification_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(const FetchAthleteNotes()),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (_) {
      return dateString;
    }
  }

  String _preview(String text, {int max = 100}) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}...';
  }

  void _showNoteDialog(BuildContext context, NoteEntity note) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF13131F),
          title: Text(
            localizations.notificationNoteTitle,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDate(note.createdAt),
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  note.note,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                localizations.notificationCloseButton,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: Text(
          localizations.notificationTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.notificationRecent,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state.status == NotesStatus.loading) {
                    return ListView.separated(
                      itemCount: 3,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E2F),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white24,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      width: 120.w,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  if (state.status == NotesStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? localizations.notificationFailedToLoad,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state.status == NotesStatus.empty ||
                      state.notes.isEmpty) {
                    return Center(
                      child: Text(
                        localizations.notificationNoNotifications,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.notes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return InkWell(
                        onTap: () => _showNoteDialog(context, note),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13131F),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFF2E2E5D)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (note.athleteName.isNotEmpty)
                                      Text(
                                        note.athleteName,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    if (note.athleteName.isNotEmpty)
                                      SizedBox(height: 4.h),
                                    Text(
                                      _preview(note.note),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      _formatDate(note.createdAt),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white54,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

