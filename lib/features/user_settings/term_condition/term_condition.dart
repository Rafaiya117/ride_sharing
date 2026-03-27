import 'package:flutter/material.dart';
import 'package:ride_sharing/core/components/custom_legal_content.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalContentScreen(
      title: "Terms of Service",
      paragraphs: [
        "Lorem ipsum dolor sit amet consectetur. Lacus at venenatis gravida vivamus mauris. Quisque mi est vel dis. Donec rhoncus laoreet odio orci sed risus elit accumsan.",
        "Vel blandit mi nulla sodales consectetur. Egestas tristique ultrices gravida duis nisl odio. Posuere curabitur eu platea pellentesque ut. Facilisi elementum neque mauris facilisis in.",
        "Scelerisque tellus praesent condimentum euismod a faucibus. Auctor at ultricies at urna aliquam massa pellentesque. Vitae vulputate nullam diam placerat m.",
      ],
    );
  }
}