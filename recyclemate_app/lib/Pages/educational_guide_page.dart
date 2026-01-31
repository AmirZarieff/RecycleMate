import 'package:flutter/material.dart';

class EducationalGuidePage extends StatelessWidget {
  const EducationalGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text(
          'Recycling Guide',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[700]!, Colors.green[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.eco, size: 60, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Learn About Recycling',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Reduce, Reuse, Recycle for a Better Future',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Tips Section
          _buildSectionTitle('Quick Recycling Tips'),
          const SizedBox(height: 12),
          _buildTipCard(
            icon: Icons.water_drop,
            title: 'Rinse Before Recycling',
            description:
                'Clean containers before recycling to prevent contamination.',
            color: Colors.blue,
          ),
          _buildTipCard(
            icon: Icons.cancel,
            title: 'Remove Caps & Labels',
            description: 'Remove bottle caps and labels when possible.',
            color: Colors.orange,
          ),
          _buildTipCard(
            icon: Icons.layers,
            title: 'Flatten Cardboard',
            description: 'Flatten boxes to save space in recycling bins.',
            color: Colors.brown,
          ),
          _buildTipCard(
            icon: Icons.check_circle,
            title: 'Check Local Guidelines',
            description:
                'Recycling rules vary by location. Check your local guidelines.',
            color: Colors.green,
          ),
          const SizedBox(height: 24),

          // Recyclable Categories Section
          _buildSectionTitle('Common Recyclable Materials'),
          const SizedBox(height: 12),
          _buildCategoryCard(
            icon: Icons.local_drink,
            title: 'Plastics',
            items: [
              '✓ Plastic bottles (PET #1, HDPE #2)',
              '✓ Food containers',
              '✓ Detergent bottles',
              '✗ Plastic bags (recycle separately)',
              '✗ Styrofoam',
            ],
            color: Colors.blue,
          ),
          _buildCategoryCard(
            icon: Icons.article,
            title: 'Paper & Cardboard',
            items: [
              '✓ Newspapers & magazines',
              '✓ Office paper',
              '✓ Cardboard boxes',
              '✗ Waxed or coated paper',
              '✗ Tissue paper',
            ],
            color: Colors.brown,
          ),
          _buildCategoryCard(
            icon: Icons.broken_image,
            title: 'Glass',
            items: [
              '✓ Glass bottles & jars',
              '✓ Food containers',
              '✗ Light bulbs',
              '✗ Window glass',
              '✗ Mirrors',
            ],
            color: Colors.teal,
          ),
          _buildCategoryCard(
            icon: Icons.settings,
            title: 'Metals',
            items: [
              '✓ Aluminum cans',
              '✓ Steel cans',
              '✓ Tin foil',
              '✗ Paint cans with residue',
              '✗ Aerosol cans (check local rules)',
            ],
            color: Colors.grey,
          ),
          const SizedBox(height: 24),

          // Environmental Impact Section
          _buildSectionTitle('Why Recycling Matters'),
          const SizedBox(height: 12),
          _buildImpactCard(
            icon: Icons.forest,
            title: 'Saves Natural Resources',
            description:
                'Recycling reduces the need for extracting, refining, and processing raw materials.',
            color: Colors.green,
          ),
          _buildImpactCard(
            icon: Icons.energy_savings_leaf,
            title: 'Saves Energy',
            description:
                'Manufacturing products from recycled materials uses less energy than from raw materials.',
            color: Colors.amber,
          ),
          _buildImpactCard(
            icon: Icons.delete_outline,
            title: 'Reduces Landfill Waste',
            description:
                'Recycling diverts waste from landfills, reducing pollution and land usage.',
            color: Colors.orange,
          ),
          _buildImpactCard(
            icon: Icons.public,
            title: 'Protects Ecosystems',
            description:
                'Less extraction means less habitat destruction and environmental degradation.',
            color: Colors.blue,
          ),
          const SizedBox(height: 24),

          // Common Mistakes Section
          _buildSectionTitle('Common Recycling Mistakes'),
          const SizedBox(height: 12),
          _buildMistakeCard(
            '❌ Wishful Recycling',
            'Don\'t recycle items hoping they\'re recyclable. Check first!',
          ),
          _buildMistakeCard(
            '❌ Dirty Containers',
            'Food residue contaminates entire batches of recyclables.',
          ),
          _buildMistakeCard(
            '❌ Plastic Bags in Bins',
            'Plastic bags jam sorting machines. Return to store drop-offs.',
          ),
          _buildMistakeCard(
            '❌ Mixing Materials',
            'Keep different materials separate when possible.',
          ),
          const SizedBox(height: 24),

          // Fun Facts Section
          _buildSectionTitle('Recycling Fun Facts'),
          const SizedBox(height: 12),
          _buildFactCard(
            '🔄 Aluminum can be recycled infinitely without losing quality',
          ),
          _buildFactCard('📄 Recycling 1 ton of paper saves 17 trees'),
          _buildFactCard(
            '⚡ Recycling aluminum saves 95% of the energy needed to make new aluminum',
          ),
          _buildFactCard(
            '🌍 Glass takes 1 million years to decompose in nature',
          ),
          _buildFactCard(
            '♻️ Plastic bottles can be turned into clothing, furniture, and more',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMistakeCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactCard(String fact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          fact,
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        ),
      ),
    );
  }
}
