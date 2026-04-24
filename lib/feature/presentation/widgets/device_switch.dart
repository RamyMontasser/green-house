import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_house/feature/presentation/cubit/controllers_cubit.dart';

class DeviceSwitch extends StatelessWidget {
  final String title;
  final String onEndpoint; 
  final String offEndpoint; 
  final IconData icon;

  const DeviceSwitch({super.key, 
    required this.title,
    required this.onEndpoint,
    required this.offEndpoint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ControllersCubit(), 
      child: BlocBuilder<ControllersCubit, ControllersState>(
        builder: (context, state) {
          return SwitchListTile(
            title: Text(title, style: TextStyle(color: Colors.white)),
            value: state.isOn,
            onChanged: (state is ControllersLoading)
                ? null
                : (value) => context.read<ControllersCubit>().toggleDevice(
                    onEndpoint,
                    offEndpoint,
                  ),
            secondary: (state is ControllersLoading)
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    icon,
                    color: state.isOn ? Colors.cyanAccent : Colors.grey,
                  ),
          );
        },
      ),
    );
  }
}
