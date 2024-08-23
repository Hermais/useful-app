import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:useful_app/core/common/cubits/image_picker_cubit/image_picker_cubit.dart';
import 'package:useful_app/features/landing_page/presentation/widgets/bottom_navigation_bar.dart';
import 'package:useful_app/features/pick_image_fill/presentation/cubit/image_processor_cubit.dart';
import 'package:useful_app/features/pick_image_fill/presentation/pages/pick_image_fill.dart';

import '../../../../core/common/cubits/file_saver_cubit/file_saver_cubit.dart';
import '../../../../core/common/cubits/image_to_pdf_cubit/image_to_pdf_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pagesList = <Widget>[
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ImagePickerCubit(),
        ),
        BlocProvider(
          create: (_) => ImageProcessorCubit(),
        ),
        BlocProvider(
          create: (_) => FileSaverCubit(),
        ),
        BlocProvider(create: (_) => ImageToPdfCubit()),
      ],
      child: const PickImageAndFillIn(),
    ),
    const Center(
      child: Text('Coming Soon!'),
    ),
    const Center(
      child: Text('Coming Soon!'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: _pagesList[_selectedIndex],
      bottomNavigationBar: MainBottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_rounded),
            label: 'Page Filler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'Coming Soon!',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'Coming Soon!',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
