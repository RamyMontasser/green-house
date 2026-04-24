import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/core/service/api_service.dart';
import 'package:green_house/feature/presentation/manager/model_cubit/model_cubit.dart';
import 'package:image_picker/image_picker.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModelCubit(ApiService()),
      child: const ModelView(),
    );
  }
}

class ModelView extends StatefulWidget {
  const ModelView({super.key});

  @override
  State<ModelView> createState() => _ModelViewState();
}

class _ModelViewState extends State<ModelView> {
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaf Disease Classification",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: 
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocConsumer<ModelCubit, ModelState>(
            listener: (context, state) {
              if (state is ModelImageSelected) {
                setState(() {
                  _selectedImagePath = state.imagePath;
                });
              }
              if (state is ModelError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
              if (state is ModelSuccess) {
                _showResultDialog(context, state.prediction);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    _buildImageContainer(context, state),
                    SizedBox(height: 40.h),
                    _buildActionButtons(context, state),
                    SizedBox(height: 40.h),
                    _buildInfoCard(),
                    SizedBox(height: 40.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, ModelState state) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: _selectedImagePath != null
            ? Image.file(
                File(_selectedImagePath!),
                fit: BoxFit.cover,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_search_rounded,
                    size: 80.sp,
                    color: Colors.white24,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No Image Selected",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ModelState state) {
    bool isLoading = state is ModelLoading;
    bool hasImage = _selectedImagePath != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSelectionButton(
                context: context,
                onPressed: isLoading ? null : () => context.read<ModelCubit>().pickImage(ImageSource.camera),
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildSelectionButton(
                context: context,
                onPressed: isLoading ? null : () => context.read<ModelCubit>().pickImage(ImageSource.gallery),
                icon: Icons.photo_library_outlined,
                label: "Gallery",
                color: Colors.indigoAccent,
              ),
            ),
          ],
        ),
        if (hasImage) ...[
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: isLoading ? null : () => context.read<ModelCubit>().classifyImage(_selectedImagePath!),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 4,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 24.h,
                      width: 24.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Classify Leaf",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectionButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20.sp),
      label: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blueAccent, size: 24.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              "Upload a clear photo of the plant leaf to detect potential diseases using our AI model.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(BuildContext context, String prediction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
            SizedBox(width: 12.w),
            const Text("Analysis Result", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "The model predicted:",
              style: TextStyle(color: Colors.white60, fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.r),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: Text(
                prediction,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}