import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_house/feature/presentation/manager/config_cubit/config_cubit.dart';

class AutoControlSwitch extends StatelessWidget {
  const AutoControlSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      buildWhen: (previous, current) => 
        current is ConfigThresholdsLoaded || current is ConfigSubmitting || current is ConfigError,
      builder: (context, state) {
        bool isOn = false;
        bool isLoading = false;

        if (state is ConfigThresholdsLoaded) {
          isOn = state.thresholds.isEnabled ?? false;
        } else if (state is ConfigSubmitting) {
          isLoading = true;
          // We can try to keep the old state if we want, 
          // but for simplicity we'll just show current logic.
        }

        return SwitchListTile(
          title: Text("Auto Control", style: TextStyle(color: Colors.white)),
          value: isOn,
          onChanged: isLoading
              ? null
              : (value) {
                  context.read<ConfigCubit>().toggleAutoControl(value);
                },
          activeColor: Colors.greenAccent,
          secondary: isLoading 
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : null,
        );
      },
    );
  }
}
