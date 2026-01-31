import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample recycling items data
  final List<Map<String, dynamic>> _sampleItems = [
    {
      'name': 'Plastic Bottle',
      'name_lowercase': 'plastic bottle',
      'category': 'Plastic',
      'recyclable': true,
      'description':
          'PET plastic bottles are commonly used for beverages and are highly recyclable.',
      'tips':
          'Remove the cap and label, rinse thoroughly, and crush to save space. Check the recycling symbol (#1 PET).',
    },
    {
      'name': 'Glass Jar',
      'name_lowercase': 'glass jar',
      'category': 'Glass',
      'recyclable': true,
      'description':
          'Glass jars can be recycled indefinitely without losing quality.',
      'tips':
          'Remove metal lids, rinse clean, and place in glass recycling bin. No need to remove labels.',
    },
    {
      'name': 'Aluminum Can',
      'name_lowercase': 'aluminum can',
      'category': 'Metal',
      'recyclable': true,
      'description':
          'Aluminum cans are infinitely recyclable and save 95% energy when recycled.',
      'tips':
          'Rinse the can, crush it to save space, and place in metal recycling. Leave tabs attached.',
    },
    {
      'name': 'Cardboard Box',
      'name_lowercase': 'cardboard box',
      'category': 'Paper',
      'recyclable': true,
      'description': 'Corrugated cardboard boxes are widely recyclable.',
      'tips':
          'Flatten boxes completely, remove tape and labels if possible. Keep dry and clean.',
    },
    {
      'name': 'Newspaper',
      'name_lowercase': 'newspaper',
      'category': 'Paper',
      'recyclable': true,
      'description':
          'Newspapers are recyclable and can be turned into new paper products.',
      'tips':
          'Keep newspapers dry and bundle them together. Remove plastic sleeves.',
    },
    {
      'name': 'Styrofoam',
      'name_lowercase': 'styrofoam',
      'category': 'Plastic',
      'recyclable': false,
      'description':
          'Polystyrene foam (Styrofoam) is difficult to recycle in most facilities.',
      'tips':
          'Avoid purchasing products with styrofoam. Check if your area has special drop-off locations.',
    },
    {
      'name': 'Plastic Bag',
      'name_lowercase': 'plastic bag',
      'category': 'Plastic',
      'recyclable': false,
      'description':
          'Plastic bags jam recycling machinery and should not go in curbside bins.',
      'tips':
          'Return to grocery store drop-off bins. Better yet, use reusable bags instead.',
    },
    {
      'name': 'Pizza Box',
      'name_lowercase': 'pizza box',
      'category': 'Paper',
      'recyclable': false,
      'description':
          'Pizza boxes soiled with grease cannot be recycled as they contaminate paper recycling.',
      'tips':
          'Tear off clean parts for recycling. Compost greasy parts if possible, or trash them.',
    },
    {
      'name': 'Steel Can',
      'name_lowercase': 'steel can',
      'category': 'Metal',
      'recyclable': true,
      'description':
          'Steel cans from food products are magnetic and recyclable.',
      'tips':
          'Rinse thoroughly, remove labels if easy. No need to remove both ends.',
    },
    {
      'name': 'Milk Carton',
      'name_lowercase': 'milk carton',
      'category': 'Paper',
      'recyclable': true,
      'description':
          'Waxed or plastic-coated cartons can be recycled in many areas.',
      'tips':
          'Rinse thoroughly, flatten if possible. Check local guidelines as some areas don\'t accept them.',
    },
    {
      'name': 'Tissue Paper',
      'name_lowercase': 'tissue paper',
      'category': 'Paper',
      'recyclable': false,
      'description': 'Tissue paper fibers are too short to be recycled.',
      'tips':
          'Compost clean tissue paper or dispose in trash. Used tissues go in trash only.',
    },
    {
      'name': 'Magazine',
      'name_lowercase': 'magazine',
      'category': 'Paper',
      'recyclable': true,
      'description': 'Glossy magazines can be recycled with other paper.',
      'tips':
          'Remove plastic wrap. No need to remove staples or glue bindings.',
    },
    {
      'name': 'Light Bulb',
      'name_lowercase': 'light bulb',
      'category': 'Glass',
      'recyclable': false,
      'description':
          'Most light bulbs require special handling and cannot go in regular glass recycling.',
      'tips':
          'Take to special recycling centers. LED bulbs are safest. Handle CFLs carefully.',
    },
    {
      'name': 'Wine Bottle',
      'name_lowercase': 'wine bottle',
      'category': 'Glass',
      'recyclable': true,
      'description': 'Glass wine bottles are fully recyclable.',
      'tips':
          'Remove cork or cap, rinse bottle. Labels can stay on. Place in glass recycling.',
    },
    {
      'name': 'Food Container',
      'name_lowercase': 'food container',
      'category': 'Plastic',
      'recyclable': true,
      'description':
          'Most rigid plastic food containers (#1-7) are recyclable.',
      'tips':
          'Check the number on the bottom. Rinse clean. Remove any paper labels.',
    },
    {
      'name': 'Egg Carton',
      'name_lowercase': 'egg carton',
      'category': 'Paper',
      'recyclable': true,
      'description':
          'Cardboard egg cartons are recyclable. Styrofoam ones are not.',
      'tips':
          'Only recycle cardboard cartons. Remove any stickers. Styrofoam cartons go to trash.',
    },
    {
      'name': 'Aerosol Can',
      'name_lowercase': 'aerosol can',
      'category': 'Metal',
      'recyclable': true,
      'description': 'Empty aerosol cans are recyclable in most areas.',
      'tips':
          'Must be completely empty. Do not puncture. Check local guidelines.',
    },
    {
      'name': 'Shampoo Bottle',
      'name_lowercase': 'shampoo bottle',
      'category': 'Plastic',
      'recyclable': true,
      'description': 'Most plastic shampoo bottles are recyclable.',
      'tips':
          'Empty completely, rinse, and recycle with cap on. Usually #1 or #2 plastic.',
    },
    {
      'name': 'Mirror',
      'name_lowercase': 'mirror',
      'category': 'Glass',
      'recyclable': false,
      'description':
          'Mirrors have coatings that make them unsuitable for glass recycling.',
      'tips':
          'Donate if in good condition. Otherwise, wrap carefully and dispose in trash.',
    },
    {
      'name': 'Tin Foil',
      'name_lowercase': 'tin foil',
      'category': 'Metal',
      'recyclable': true,
      'description': 'Aluminum foil is recyclable if clean.',
      'tips':
          'Rinse off food residue, ball up into a larger piece (golf ball size), recycle with metals.',
    },
  ];

  Future<void> seedDatabase() async {
    try {
      print('Starting to seed Firestore database...');

      final collection = _firestore.collection('recycling_items');

      // Check if data already exists
      final existingDocs = await collection.limit(1).get();
      if (existingDocs.docs.isNotEmpty) {
        print('Database already contains data. Skipping seed.');
        return;
      }

      // Add each item
      int count = 0;
      for (var item in _sampleItems) {
        await collection.add(item);
        count++;
        print('Added item $count: ${item['name']}');
      }

      print('Successfully seeded $count items to Firestore!');
    } catch (e) {
      print('Error seeding database: $e');
      rethrow;
    }
  }

  Future<void> clearDatabase() async {
    try {
      print('Clearing Firestore database...');

      final collection = _firestore.collection('recycling_items');
      final snapshot = await collection.get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print('Cleared ${snapshot.docs.length} items from Firestore!');
    } catch (e) {
      print('Error clearing database: $e');
      rethrow;
    }
  }
}
