class ReactionModel {
  final int like;
  final int haha;
  final int sad;
  final int love;
  final int care;
  final int angry;
  final int wow;

  const ReactionModel({
    this.like = 0,
    this.angry = 0,
    this.care = 0,
    this.haha = 0,
    this.love = 0,
    this.sad = 0,
    this.wow = 0,
  });

  factory ReactionModel.fromMap(Map<String, dynamic> map) => ReactionModel(
    like: map['like'] ?? 0,
    angry: map['angry'] ?? 0,
    care: map['care'] ?? 0,
    haha: map['haha'] ?? 0,
    love: map['love'] ?? 0,
    sad: map['sad'] ?? 0,
    wow: map['wow'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'like': like,
    "angry": angry,
    'care': care,
    'haha': haha,
    'love': love,
    'sad': sad,
    'wow': wow,
  };
}
