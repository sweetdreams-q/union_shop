import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/widgets/responsive_header.dart';
import 'package:union_shop/widgets/footer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  List<Product> get _results {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();

    // Perform fuzzy subsequence matching and score matches so best matches appear first
    final matches = <Map<String, dynamic>>[];
    for (final p in sampleProducts) {
      final m = _fuzzyMatch(p.title, q);
      if (m != null) {
        matches.add({'product': p, 'indices': m['indices'], 'score': m['score']});
      }
    }

    matches.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return matches.map((m) => m['product'] as Product).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: ResponsiveHeader.buildDrawer(
        context,
        onHome: (c) => c.go('/'),
        onAbout: (c) => c.go('/about'),
        onSearch: (c) => {},
        onProfile: (c) => {},
        onCart: (c) => c.go('/cart'),
        onSale: (c) => c.go('/sale'),
        onGallery: (c) => c.go('/gallery'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveHeader(
              onHome: (c) => c.go('/'),
              onAbout: (c) => c.go('/about'),
              onSearch: (c) => {},
              onProfile: (c) => {},
              onCart: (c) => c.go('/cart'),
              onSale: (c) => c.go('/sale'),
              onGallery: (c) => c.go('/gallery'),
              onOpenDrawer: (c) => scaffoldKey.currentState?.openEndDrawer(),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 24),
                  _buildBody(context),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final results = _results;
    if (_query.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'Type to search products (searches as you type).',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'No products match your search.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final p = results[index];
        // Compute highlighted title using fuzzy indices
        final match = _fuzzyMatch(p.title, _query.toLowerCase());
        final indices = match?['indices'] as List<int>?;
        return ListTile(
          leading: Image.asset(
            p.imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
          ),
          title: indices != null
              ? RichText(text: _buildHighlightedText(p.title, indices))
              : Text(p.title),
          subtitle: Text(p.price),
          onTap: () {
            context.go('/product/${p.id}');
          },
        );
      },
    );
  }

  // Fuzzy subsequence matcher: returns matched character indices and a score, or null if not matched.
  Map<String, dynamic>? _fuzzyMatch(String text, String pattern) {
    if (pattern.isEmpty) return null;
    final t = text.toLowerCase();
    final p = pattern.toLowerCase();
    int ti = 0;
    final indices = <int>[];
    for (int pi = 0; pi < p.length; pi++) {
      final ch = p[pi];
      bool found = false;
      while (ti < t.length) {
        if (t[ti] == ch) {
          indices.add(ti);
          ti++;
          found = true;
          break;
        }
        ti++;
      }
      if (!found) return null;
    }

    // Score: favor contiguous matches and shorter spans
    final first = indices.first;
    final last = indices.last;
    final span = last - first + 1;
    final score = p.length * 100 - span; // higher is better
    return {'indices': indices, 'score': score};
  }

  TextSpan _buildHighlightedText(String text, List<int> indices) {
    final children = <TextSpan>[];
    final indexSet = indices.toSet();
    for (int i = 0; i < text.length; ) {
      if (indexSet.contains(i)) {
        // build contiguous highlighted run
        final buffer = StringBuffer();
        int j = i;
        while (j < text.length && indexSet.contains(j)) {
          buffer.write(text[j]);
          j++;
        }
        children.add(TextSpan(
          text: buffer.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
        i = j;
      } else {
        final buffer = StringBuffer();
        int j = i;
        while (j < text.length && !indexSet.contains(j)) {
          buffer.write(text[j]);
          j++;
        }
        children.add(TextSpan(
          text: buffer.toString(),
          style: const TextStyle(color: Colors.grey),
        ));
        i = j;
      }
    }
    return TextSpan(children: children, style: const TextStyle(fontSize: 16, color: Colors.black));
  }
}
