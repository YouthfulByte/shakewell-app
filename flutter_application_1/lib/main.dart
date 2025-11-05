import 'package:flutter/material.dart';

void main() {
  runApp(const ShakewellApp());
}

class ShakewellApp extends StatelessWidget {
  const ShakewellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shakewell',
      theme: ThemeData(primarySwatch: Colors.amber),  // 金黄主题
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // 静态数据 (const)
  static const List<Map<String, String>> top50Bars = [
    {'rank': '1', 'name': 'Paradiso (Barcelona)', 'desc': 'Mediterranean-inspired cocktails & creative presentation'},
    {'rank': '2', 'name': 'Handshake Speakeasy (New York)', 'desc': 'Hidden gem with innovative drinks'},
    {'rank': '3', 'name': 'Alquimico (Cartagena)', 'desc': 'Tropical twists on classics'},
    {'rank': '4', 'name': 'The Connaught Bar (London)', 'desc': 'Elegant martinis and British flair'},
    {'rank': '5', 'name': 'Licorería Limantour (Mexico City)', 'desc': 'Latin American spirits showcase'},
    {'rank': '6', 'name': 'Bar Benfiddich (Tokyo)', 'desc': 'Bespoke infusions and alchemy'},
    {'rank': '7', 'name': 'Jigger & Pony (Singapore)', 'desc': 'Asian-inspired precision'},
    {'rank': '8', 'name': 'The SG Club (Tokyo)', 'desc': 'Japanese whisky haven'},
    {'rank': '9', 'name': 'Moo Moo Singapore', 'desc': 'Craft cocktails in a cozy setting'},
    {'rank': '10', 'name': 'Line Athens (Athens)', 'desc': 'Greek mythology meets mixology'},
    // 加到 50 个...
  ];

  @override
  Widget build(BuildContext context) {
    // 动态数据 (运行时生成)
    final List<Map<String, String>> hotCocktails = List.generate(25, (index) => {'name': 'Hot Drink $index', 'desc': 'Popular $index'});
    final List<Map<String, String>> recommendations = List.generate(25, (index) => {'name': 'Recommended $index', 'desc': 'Suggestion $index'});
    final List<Map<String, String>> viewedCocktails = [];  // 初始空

    return Scaffold(
      body: SingleChildScrollView(  // 动态滚动
        child: Column(
          children: [
            // 头部
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              color: const Color(0xFFFFF9C4),  // 金黄
              child: Column(
                children: [
                  const Text(
                    'Shakewell 🥂',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Hi Eric！今天想调什么？',
                    style: TextStyle(fontSize: 18, color: Color(0xFF6A1B9A)),
                  ),
                  const SizedBox(height: 20),
                  // 搜索栏 (加 keyboardType 进一步避 bug)
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '搜索酒名、材料...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // 热门模块
            _buildHorizontalSection('热门', hotCocktails, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FullPage(title: '全热门')))),
            // 推荐模块
            _buildHorizontalSection('推荐', recommendations, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FullPage(title: '全推荐')))),
            // 看过的模块 (初始空)
            _buildHorizontalSection('看过的', viewedCocktails, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FullPage(title: '全看过的')))),
            // 分类卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: const [
                  _CategoryCard(icon: Icons.book, title: '新手教程'),
                  _CategoryCard(icon: Icons.star, title: '经典爆款'),
                  _CategoryCard(icon: Icons.local_drink, title: '基酒类型'),
                  _CategoryCard(icon: Icons.local_bar, title: '调酒类型'),  // 酒杯图标
                ],
              ),
            ),
            // Top 50
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text('全美 Top 50 酒吧', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,  // 限制高，内部滚动
                        child: ListView.builder(
                          itemCount: top50Bars.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(top50Bars[index]['rank']!),
                              title: Text(top50Bars[index]['name']!),
                              subtitle: Text(top50Bars[index]['desc']!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,  // Fix: 白底
        selectedItemColor: const Color(0xFF6A1B9A),  // 活跃紫
        unselectedItemColor: Colors.grey,  // Fix: 非活跃灰
        type: BottomNavigationBarType.fixed,  // Fix: 5 项固定全显
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.local_bar), label: 'Cocktails'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
        currentIndex: 0,
      ),
    );
  }

  // 通用横滑模块
  Widget _buildHorizontalSection(String title, List<Map<String, String>> items, VoidCallback onViewMore) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A))),
              TextButton(onPressed: onViewMore, child: const Text('View More', style: TextStyle(color: Color(0xFF6A1B9A)))),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: items.isEmpty
                ? const Center(child: Text('暂无记录', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length.clamp(0, 21),  // 20 + View More
                    itemBuilder: (context, index) {
                      if (index < 20) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(items[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(items[index]['desc']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(onPressed: onViewMore, child: const Text('View More')),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// 分类卡片组件
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 示例全页
class FullPage extends StatelessWidget {
  final String title;

  const FullPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('全列表页面...')),
    );
  }
}