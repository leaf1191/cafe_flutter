import 'dart:math';
import 'package:cafe_front/provider/main/curation/curation_viewmodel.dart';
import 'package:cafe_front/views/main/Curation/More_Curation_Page.dart';
import 'package:cafe_front/views/main/Curation/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/cafe.dart';
import '../../../widgets/listview/build_list_view.dart';
import 'Photo_With_Keyword_Card.dart';

class CurationPage extends StatefulWidget {
  const CurationPage({Key? key}) : super(key: key);

  @override
  State<CurationPage> createState() => _CurationPageState();
}

class _CurationPageState extends State<CurationPage> {
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // 데이터 fetch
    context.read<CurationViewModel>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 가져오기
    var viewModel = context.watch<CurationViewModel>();

    // 데이터 로딩 중일 경우 로딩 인디케이터 표시
    if (viewModel.cafes == null || viewModel.preferredCafes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 카페 리스트 가져오기
    final cafes = viewModel.cafes!;
    final preferredCafes = viewModel.preferredCafes ?? [];

    // 예외 처리: 카페 리스트가 비어 있을 경우 메시지 표시
    if (cafes.isEmpty && preferredCafes.isEmpty) {
      return const Center(child: Text('추천할 카페가 없습니다.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: '집 주변 카페 정복하기'),
                buildHorizontalListView(context), // 선호 카페 리스트 표시
                const SizedBox(height: 30),
                const SectionTitle(title: '서진님의 취향저격 카페'),
                buildHorizontalListViewWithCafes(context,cafes),
                 // 커스텀 카드 리스트
                const SizedBox(height: 30),
                const SectionTitle(title: '이 카페 한 번 더?'),
                buildListViewWithCustomCards(context),
                // 고정 카페 리스트
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 헤더 이미지 및 제목 빌드
  Widget _buildHeaderImage() {
    return Stack(
      children: [
        Container(
          height: 500,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Frame 6.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: const Text(
            '장마철에 딱 맞는\n당신의 취향 저격 카페 3선',
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Pretendard-Bold',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 5.0,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 28,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoreCurationPage()),
              );
            },
            child: Image.asset(
              'assets/images/image_511371.png',
              width: 48,
              height: 48,
            ),
          ),
        ),
      ],
    );
  }

  /// 수평 리스트뷰에 랜덤으로 카페 표시
  Widget buildHorizontalListViewWithCafes(BuildContext context, List<Cafe> cafes) {
    if (cafes.isEmpty) {
      return const Center(child: Text('카페가 없습니다.'));
    }

    // 무작위로 3개의 카페 선택
    final randomCafes = getRandomCafes(cafes, 3);

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: randomCafes.length,
        itemBuilder: (context, index) {
          final cafe = randomCafes[index];
          return PhotoKeyCard(
            imagePath: _getRandomImagePath(),
            keyword1: cafe.keywords.isNotEmpty ? cafe.keywords[0].keyword : '디저트',
            keyword2: cafe.keywords.length > 1 ? cafe.keywords[1].keyword : '커피',
            text: cafe.name,
          );
        },
      ),
    );
  }
  final Random random = Random();
  /// 카페 리스트에서 무작위로 N개의 카페를 선택하는 함수
  List<Cafe> getRandomCafes(List<Cafe> cafes, int count) {
    if (cafes.length <= count) return cafes; // 카페 수가 부족하면 전체 반환

    final List<Cafe> shuffledCafes = List.from(cafes)..shuffle(_random);
    return shuffledCafes.take(count).toList();
  }
  /// 랜덤 이미지 경로 생성
  String _getRandomImagePath() {
    int randomIndex = _random.nextInt(21);
    return 'assets/images/Frame $randomIndex.png';
  }
}
