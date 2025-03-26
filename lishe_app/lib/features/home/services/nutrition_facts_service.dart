// ignore_for_file: prefer_final_fields

import '../../meal_planner/models/nutrition_fact_model.dart';

class NutritionFactsService {
  // Mock data for development
  List<NutritionFact> _mockNutritionFacts = [
    NutritionFact(
      id: '1',
      title: 'Faida za Mchicha (Benefits of Spinach)',
      description:
          'Mchicha ni mbogamboga yenye virutubisho vingi sana. Ina vitamini A, C, K, na madini ya chuma na kalisi. Inasaidia kuimarisha mifupa na kuongeza kinga ya mwili. Wajawazito wanahimizwa kula mchicha kwa wingi ili kupunguza uwezekano wa upungufu wa damu.',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 3, 15),
      tags: ['mbogamboga', 'vitamini', 'afya'],
      viewCount: 324,
      likeCount: 48,
      commentCount: 12,
    ),
    NutritionFact(
      id: '2',
      title: 'Ugali na Afya ya Mwili',
      description:
          'Ugali iliyotengenezwa kwa unga wa mahindi una wanga, protini na vitamini za kundi B. Kula ugali kwa kiasi inasaidia kupata nguvu na kukupa virutubisho muhimu. Watu wanaofanya kazi zenye nguvu wanahitaji vyakula vyenye wanga kama ugali kwa nishati ya kutosha.',
      imageUrl:
          'https://images.unsplash.com/photo-1666181551815-b9adecb24e46?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      source: 'TFNC',
      publishedDate: DateTime(2024, 2, 20),
      tags: ['ugali', 'chakula', 'wanga'],
      viewCount: 562,
      likeCount: 73,
      commentCount: 25,
    ),
    NutritionFact(
      id: '3',
      title: 'Matunda ya Asili Tanzania',
      description:
          'Matunda ya asili kama embe, papai na nanasi yana vitamini na madini muhimu kwa afya. Yanasaidia kupunguza uwezekano wa kupata magonjwa ya moyo na kisukari. Papai lina enzaimu inayosaidia mmeng\'enyo wa chakula na kuboresha afya ya tumbo.',
      imageUrl:
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 1, 5),
      tags: ['matunda', 'vitamini', 'afya'],
      viewCount: 278,
      likeCount: 35,
      commentCount: 9,
    ),
    NutritionFact(
      id: '4',
      title: 'Faida za Kunywa Maji ya Kutosha',
      description:
          'Kunywa maji ya kutosha kunasaidia kuboresha afya ya ngozi, kusaidia mmeng\'enyo wa chakula, na kuondoa sumu mwilini. Mtu mzima anahitaji kunywa lita 2-3 za maji kwa siku. Dalili za upungufu wa maji ni pamoja na kuumwa kichwa, kuchoka haraka na mkojo wenye rangi kali.',
      imageUrl:
          'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 2, 12),
      tags: ['maji', 'afya', 'ushauri'],
      viewCount: 421,
      likeCount: 62,
      commentCount: 18,
    ),
    NutritionFact(
      id: '5',
      title: 'Samaki na Akili',
      description:
          'Samaki kama dagaa na sangara wana omega-3 ambayo inasaidia ukuaji wa ubongo na kufanya kazi vizuri. Watoto wanaokula samaki mara kwa mara wanaweza kufanya vizuri zaidi shuleni. Wanawake wajawazito pia wanahimizwa kula samaki kwa ajili ya ukuaji wa ubongo wa mtoto.',
      imageUrl:
          'https://www.uclahealth.org/sites/default/files/styles/landscape_3x2_024000_960x640/public/images/a5/istock-613222052-ccexpress.jpeg?f=a5f61719&itok=HCsffzLr',
      source: 'TFNC',
      publishedDate: DateTime(2024, 1, 30),
      tags: ['samaki', 'protini', 'omega3'],
      viewCount: 385,
      likeCount: 41,
      commentCount: 15,
    ),
    NutritionFact(
      id: '6',
      title: 'Maharage na Protini (Beans and Protein)',
      description:
          'Maharage ni chanzo kizuri cha protini kwa watu wanaofuata mtindo wa chakula cha mboga. Pia yana vitamini za B, madini ya chuma na zinki ambazo ni muhimu kwa afya. Kula maharage kunasaidia kudhibiti kiwango cha sukari katika damu kwa watu wenye kisukari.',
      imageUrl:
          'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 3, 18),
      tags: ['maharage', 'protini', 'vyakula'],
      viewCount: 312,
      likeCount: 38,
      commentCount: 11,
    ),
    NutritionFact(
      id: '7',
      title: 'Faida za Ndizi kwa Wanamichezo',
      description:
          'Ndizi ni chanzo kizuri cha nishati kwa wanaosport. Zina potasiamu na carbohydrates zinazosaidia kuzuia maumivu ya misuli na kutoa nishati ya haraka. Ndizi nyingi za Tanzania kama Uganda na Mshare zina vitutubisho vingi zaidi kuliko ndizi za kutoka nje ya nchi.',
      imageUrl:
          'https://images.unsplash.com/photo-1579523360600-9c11e910896f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      source: 'TFNC',
      publishedDate: DateTime(2024, 3, 5),
      tags: ['ndizi', 'wanasport', 'nishati'],
      viewCount: 245,
      likeCount: 57,
      commentCount: 8,
    ),
    NutritionFact(
      id: '8',
      title: 'Viazi Vitamu na Vitamin A',
      description:
          'Viazi vitamu vyenye rangi ya njano au chungwa vina kiasi kikubwa cha beta carotene ambayo hugeuka kuwa vitamin A mwilini. Vitamin A ni muhimu kwa afya ya macho na ngozi. Watoto wanapaswa kula viazi vitamu angalau mara mbili kwa wiki.',
      imageUrl:
          'https://images.unsplash.com/photo-1585443835125-d85820a16e89?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      source: 'TFNC',
      publishedDate: DateTime(2024, 2, 25),
      tags: ['viazi', 'vitamini', 'watoto'],
      viewCount: 298,
      likeCount: 43,
      commentCount: 6,
    ),
    NutritionFact(
      id: '9',
      title: 'Muhimu wa Maziwa kwa Mifupa',
      description:
          'Maziwa ni chanzo kikubwa cha kalisi na fosforasi ambavyo ni muhimu kwa afya ya mifupa. Watoto, wajawazito na wazee wanahitaji maziwa zaidi ili kuzuia magonjwa ya mifupa. Yogurt na jibini pia ni vyakula vizuri vya maziwa vyenye madini haya muhimu.',
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 1, 17),
      tags: ['maziwa', 'kalisi', 'mifupa'],
      viewCount: 354,
      likeCount: 61,
      commentCount: 14,
    ),
    NutritionFact(
      id: '10',
      title: 'Vyakula vya Asili dhidi ya Vyakula vya Kisasa',
      description:
          'Vyakula vya asili kama mihogo, viazi, ndizi na nafaka kamili vina virutubisho zaidi kuliko vyakula vya kisasa vilivyosindikwa. Vyakula vilivyosindikwa mara nyingi huwa na sukari, chumvi na mafuta mengi ambayo yanaweza kudhuru afya yako na kusababisha magonjwa ya kisasa.',
      imageUrl:
          'https://images.unsplash.com/photo-1573246123716-6b1782bfc499?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 3, 10),
      tags: ['asili', 'lishe', 'magonjwa'],
      viewCount: 515,
      likeCount: 89,
      commentCount: 31,
    ),
    NutritionFact(
      id: '11',
      title: 'Unga wa Ngano Kamili na Afya ya Moyo',
      description:
          'Unga wa ngano kamili (whole wheat) una faida nyingi kwa afya ya moyo. Una nyuzi (fiber) zinazosaidia kupunguza kolesterol mbaya mwilini. Mkate wa ngano kamili ni bora zaidi kuliko mkate mweupe kwa afya ya mfumo wa mmeng\'enyo na moyo.',
      imageUrl:
          'https://images.unsplash.com/photo-1568254183919-78a4f43a2877?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 2, 8),
      tags: ['ngano', 'nyuzi', 'moyo'],
      viewCount: 287,
      likeCount: 42,
      commentCount: 9,
    ),
    NutritionFact(
      id: '12',
      title: 'Faida za Tangawizi na Pilipili',
      description:
          'Tangawizi na pilipili hoho ni viungo vyenye faida nyingi za kiafya. Tangawizi ina uwezo wa kupunguza maumivu ya misuli na kuzuia kichefuchefu. Pilipili hoho ina capsaicin ambayo inasaidia kuchoma mafuta mwilini na kupunguza uzito.',
      imageUrl:
          'https://images.unsplash.com/photo-1615485500834-bc10199bc727?q=80&w=1000',
      source: 'TFNC',
      publishedDate: DateTime(2024, 1, 22),
      tags: ['viungo', 'magonjwa', 'lishe'],
      viewCount: 333,
      likeCount: 56,
      commentCount: 13,
    ),
    NutritionFact(
      id: '13',
      title: 'Umuhimu wa Maji ya Matunda Asilia',
      description:
          'Maji ya matunda asilia yana vitamini na madini mengi yanayosaidia kinga ya mwili. Ni bora zaidi kunywa maji ya matunda yaliyokamuliwa nyumbani kuliko yale ya kununua dukani ambayo mara nyingi yana sukari nyingi na vitu vya kuhifadhi.',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1676642588287-ad44c524d3b6?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      source: 'TFNC',
      publishedDate: DateTime(2024, 3, 1),
      tags: ['matunda', 'vinywaji', 'vitamini'],
      viewCount: 267,
      likeCount: 39,
      commentCount: 7,
    ),
    NutritionFact(
      id: '14',
      title: 'Karanga na Afya ya Moyo ',
      description:
          'Karanga zina mafuta mazuri yanayosaidia kupunguza hatari ya magonjwa ya moyo. Zina protini, madini ya chuma na niacin ambayo ni muhimu kwa afya. Karanga hazina kolesterol lakini zinatakiwa kuliwa kwa kiasi kutokana na kalori zake nyingi.',
      imageUrl:
          'https://images.unsplash.com/photo-1694654359031-e2db00bd0e93?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      source: 'TFNC',
      publishedDate: DateTime(2024, 2, 15),
      tags: ['karanga', 'protini', 'moyo'],
      viewCount: 321,
      likeCount: 47,
      commentCount: 11,
    ),
    NutritionFact(
      id: '15',
      title: 'Muhogo na Faida zake ',
      description:
          'Muhogo ni zao la chakula muhimu sana Tanzania. Una wanga wa kutosha kutoa nishati na pia una vitamini C na potasiamu. Kwa watu wenye kisukari, ni vizuri kuutayarisha na kuula pamoja na mbogamboga za kijani ili kupunguza athari za sukari.',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1725467480335-bae427eb198a?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      source: 'TFNC',
      publishedDate: DateTime(2024, 1, 14),
      tags: ['muhogo', 'wanga', 'nishati'],
      viewCount: 289,
      likeCount: 38,
      commentCount: 5,
    ),
  ];

  // Get all nutrition facts
  Future<List<NutritionFact>> getNutritionFacts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockNutritionFacts;
  }

  // Like a nutrition fact
  Future<NutritionFact> toggleLike(String id, bool isLiked) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockNutritionFacts.indexWhere((fact) => fact.id == id);
    if (index != -1) {
      final fact = _mockNutritionFacts[index];
      final updatedFact = fact.copyWith(
        isLiked: isLiked,
        likeCount: isLiked ? fact.likeCount + 1 : fact.likeCount - 1,
      );

      _mockNutritionFacts[index] = updatedFact;
      return updatedFact;
    }

    throw Exception('Nutrition fact not found');
  }

  // Bookmark a nutrition fact
  Future<NutritionFact> toggleBookmark(String id, bool isBookmarked) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockNutritionFacts.indexWhere((fact) => fact.id == id);
    if (index != -1) {
      final fact = _mockNutritionFacts[index];
      final updatedFact = fact.copyWith(isBookmarked: isBookmarked);

      _mockNutritionFacts[index] = updatedFact;
      return updatedFact;
    }

    throw Exception('Nutrition fact not found');
  }
}
