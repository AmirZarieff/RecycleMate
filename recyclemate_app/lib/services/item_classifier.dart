class ItemClassification {
  final String materialType;
  final String instructions;

  const ItemClassification({
    required this.materialType,
    required this.instructions,
  });
}

class ItemClassifier {
  static const Map<String, ItemClassification> _knownCodes = {
    'PLASTIC_001': ItemClassification(
      materialType: 'plastic',
      instructions: 'Rinse the item and place it in the plastics bin.',
    ),
    'GLASS_001': ItemClassification(
      materialType: 'glass',
      instructions: 'Remove caps and place in the glass recycling bin.',
    ),
    'PAPER_001': ItemClassification(
      materialType: 'paper',
      instructions: 'Ensure it is dry and place in the paper bin.',
    ),
    'CANS_001': ItemClassification(
      materialType: 'cans',
      instructions: 'Rinse and place in the metal/cans recycling bin.',
    ),
    'EWASTE_001': ItemClassification(
      materialType: 'ewaste',
      instructions: 'Bring to an e-waste drop-off point.',
    ),
    'CLOTHES_001': ItemClassification(
      materialType: 'clothes',
      instructions: 'Donate if reusable, otherwise use textile bins.',
    ),
  };

  static ItemClassification classify(String code) {
    final normalized = code.trim().toUpperCase();
    return _knownCodes[normalized] ??
        const ItemClassification(
          materialType: 'unknown',
          instructions: 'Use manual selection or check local guidelines.',
        );
  }
}
