import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisper/models/word_effect_models.dart';

import '../../Colors/colors.dart';

class AddingEffects extends StatefulWidget {
  const AddingEffects({super.key, required this.message});
  final WordEffectModels  message;

  @override
  State<AddingEffects> createState() => _AddingEffectsState();
}

class _AddingEffectsState extends State<AddingEffects> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(child: Text(widget.message.effect,style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 33.sp,
            ),
          ),))
        ),
        SizedBox(width: 20.w),
        Text(
          widget.message.word,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: colors.containerColor2,
            ),
          ),
        ),
      ],
    );;
  }
}
