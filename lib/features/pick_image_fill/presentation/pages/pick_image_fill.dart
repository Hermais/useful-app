import 'dart:ui' as UI;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:useful_app/core/common/cubits/image_picker_cubit/image_picker_cubit.dart';
import 'package:useful_app/features/pick_image_fill/presentation/cubit/image_processor_cubit.dart';
import 'package:useful_app/features/pick_image_fill/presentation/widgets/steps_card.dart';

import '../widgets/adjusted_elevated_button.dart';

class PickImageAndFillIn extends StatefulWidget {
  const PickImageAndFillIn({super.key});

  @override
  State<PickImageAndFillIn> createState() => _PickImageAndFillInState();
}

class _PickImageAndFillInState extends State<PickImageAndFillIn> {
  var _showStep1 = true;
  var _showStep2 = false;
  var _showStep3 = false;
  var _showStep4 = false;

  final _dimensionsFormKey = GlobalKey<FormState>();
  final _imageCountFormKey = GlobalKey<FormState>();

  // the four textfields controllers
  final TextEditingController _heightController = TextEditingController(text: "3508");
  final TextEditingController _widthController = TextEditingController(text: "2480");
  final TextEditingController _rowsController = TextEditingController(text: "3");
  final TextEditingController _columnsController = TextEditingController(text: "3");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StepsCard(
            text: "Step 1: Pick Image",
            child: Visibility(
              visible: _showStep1,
              child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
                builder: (context, state) {
                  if (state is ImagePickerInitial) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("No Image Selected.",
                              style: Theme.of(context).textTheme.titleSmall),
                          AdjustedElevatedButton(
                            
                            onPressed: () {
                              context.read<ImagePickerCubit>().loadImage();
                            },
                            child: const Text("Select Image"),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ImagePickerLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ImagePickerLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Image Selected, press next: ",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          AdjustedElevatedButton(
                            
                            onPressed: () {
                              context.read<ImagePickerCubit>().loadImage();
                            },
                            child: const Text("Change Image"),
                          ),
                          AdjustedElevatedButton(
                            
                            onPressed: () {
                              setState(() {
                                _showStep1 = false;
                                _showStep2 = true;
                              });
                            },
                            child: const Text("Next"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Text("Error Loading Image");
                  }
                },
              ),
            ),
          ),
          StepsCard(
              text: "Step 2: Select A Size For Canvas",
              backButton: Visibility(
                visible: _showStep2,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showStep1 = true;
                      _showStep2 = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              child: Visibility(
                visible: _showStep2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _dimensionsFormKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              controller: _heightController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter height';
                                } else if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(labelText: "Height"),
                            )),
                        const Text("X"),
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                              controller: _widthController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter width';
                                } else if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(labelText: "Width"),
                            )),
                        // next button
                        AdjustedElevatedButton(
                          
                          onPressed: () {
                            // validate form first
                            if (_dimensionsFormKey.currentState!.validate()) {
                              setState(() {
                                _showStep2 = false;
                                _showStep3 = true;
                              });
                            }
                          },
                          child: const Text("Next"),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          StepsCard(
            text: "Step 3: Specify Image Count",
            backButton: Visibility(
              visible: _showStep3,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _showStep2 = true;
                    _showStep3 = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            child: Visibility(
              visible: _showStep3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _imageCountFormKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: TextFormField(
                            controller: _rowsController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a number of images';
                              } else if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: "Y-axis count"),
                          )),
                      const Text("X"),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: TextFormField(
                            controller: _columnsController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a number of images';
                              } else if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: "X-axis count"),
                          )),
                      // next button
                      AdjustedElevatedButton(
                        
                        onPressed: () async {
                          setState(() {
                            _showStep3 = false;
                            _showStep4 = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Processing Image")));
                          // validate form first
                          if (_imageCountFormKey.currentState!.validate()) {
                            // pop a snack bar
                            if (context.read<ImagePickerCubit>().state
                                is ImagePickerLoaded) {
                              context
                                  .read<ImageProcessorCubit>()
                                  .processXFileImageToUInt8(
                                      xFileImage: (context.read<ImagePickerCubit>().state
                                              as ImagePickerLoaded)
                                          .xFileImage,
                                      canvasWidth: int.parse(_widthController.text),
                                      canvasHeight: int.parse(_heightController.text),
                                      rowsImage: int.parse(_rowsController.text),
                                      columnsImage: int.parse(_columnsController.text),
                                      margin: 3);
                            }
                          }
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          StepsCard(
            text: "Step 4: Image Processing",
            backButton: Visibility(
              visible: _showStep4,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _showStep3 = true;
                    _showStep4 = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            child: Visibility(
              visible: _showStep4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<ImageProcessorCubit, ImageProcessorState>(
                  builder: (context, state) {
                    if (state is ImageProcessorInitial) {
                      return const Text("Select an image first.");
                    } else if (state is ImageProcessorPainting) {
                      return Column(
                        children: [
                          Text("Processing Image",
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(
                            height: 10,
                          ),
                          const CircularProgressIndicator(),
                        ],
                      );
                    } else if (state is ImageProcessorPainted) {
                      return Column(
                        children: [
                          Text(
                            "Image Processed!",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.sizeOf(context).width * 0.8),
                            child: Image(
                              image: MemoryImage(state.image),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        "Error Processing Image",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.red),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 60,)

        ],
      ),
    );
  }
}
