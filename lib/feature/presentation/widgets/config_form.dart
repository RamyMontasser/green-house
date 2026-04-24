import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';
import 'package:green_house/feature/presentation/manager/config_cubit/config_cubit.dart';

class ConfigForm extends StatefulWidget {
  const ConfigForm({super.key});

  @override
  State<ConfigForm> createState() => _ConfigFormState();
}

class _ConfigFormState extends State<ConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _soilController = TextEditingController();
  final _tempController = TextEditingController();
  final _humidityController = TextEditingController();
  final _lightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ConfigCubit>().getThresholds();
  }

  @override
  void dispose() {
    _soilController.dispose();
    _tempController.dispose();
    _humidityController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigCubit, ConfigState>(
      listener: (context, state) {
        if (state is ConfigThresholdsLoaded) {
          _soilController.text = state.thresholds.soil.toString();
          _tempController.text = state.thresholds.temp.toString();
          _humidityController.text = state.thresholds.humidity.toString();
          _lightController.text = state.thresholds.light.toString();
        } else if (state is ConfigSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        } else if (state is ConfigError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Threshold Configuration",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _soilController,
                label: "Min Soil Moisture (%)",
                icon: Icons.water_drop_outlined,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _tempController,
                label: "Max Temperature (°C)",
                icon: Icons.thermostat_outlined,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _humidityController,
                label: "Max Humidity (%)",
                icon: Icons.cloud_outlined,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _lightController,
                label: "Min Light (LDR)",
                icon: Icons.light_mode_outlined,
              ),
              SizedBox(height: 24.h),
              BlocBuilder<ConfigCubit, ConfigState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ConfigSubmitting
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final config = SensorModel(
                                soil: int.parse(_soilController.text),
                                temp: double.parse(_tempController.text),
                                humidity: double.parse(_humidityController.text),
                                light: int.parse(_lightController.text),
                              );
                              context.read<ConfigCubit>().updateThresholds(config);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: state is ConfigSubmitting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Save Configuration",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a value";
        }
        if (double.tryParse(value) == null) {
          return "Please enter a valid number";
        }
        return null;
      },
    );
  }
}
