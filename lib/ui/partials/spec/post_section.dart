import 'package:flutter/material.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/ui/components/posts/post_card.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final time = timeAgo(DateTime(2025, 11, 7, 20, 40));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, i) {
        return PostCard(
          userName: 'Warung Buk Murni',
          userAvatar: 'https://i.pravatar.cc/150?img=5',
          text:
              'Warung buk murni hari ini tutup yo sedulur. Mau ada acara di rumah 😊 @sorotan #arisan #localfood.\nYou can navigate or open a profile/search page here',
          timeAgo: time,
          likeCount: 10,
          commentCount: 2,
          shareCount: 1,
          // videoUrls: data,
          // videoUrls: [
          //   // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          //   // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
          // ],
          // backgroundUrl: 'https://picsum.photos/400?random=$i',
          imageUrls: [
            'https://picsum.photos/400?random=$i',
            'https://picsum.photos/400?random=${i + 1}',
            'https://picsum.photos/400?random=${i + 2}',
            'https://picsum.photos/400?random=${i + 3}',
            // 'https://picsum.photos/400?random=${i + 4}',
            // 'https://picsum.photos/400?random=${i + 5}',
          ],
        );
      },
    );
  }
}
