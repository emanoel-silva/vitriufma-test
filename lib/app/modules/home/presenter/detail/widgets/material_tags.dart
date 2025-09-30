import 'package:flutter/material.dart';

class MaterialTags extends StatelessWidget {
  final List<String> tags;
  final Function(String)? onRemoveTag;
  final bool canRemove;

  const MaterialTags({
    Key? key, 
    required this.tags,
    this.onRemoveTag,
    this.canRemove = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: tags.map((tag) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tag,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              if (canRemove && onRemoveTag != null) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onRemoveTag!(tag),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
