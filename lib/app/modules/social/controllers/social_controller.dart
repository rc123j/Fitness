import 'package:get/get.dart';

class SocialController extends GetxController {
  // Category tabs: "Trending", "Recent", "Transformations"
  final activeTab = "Trending".obs;

  // Mock Posts Database
  final posts = <Map<String, dynamic>>[
    {
      "id": 1,
      "authorName": "Arjun Mehta",
      "authorAvatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150",
      "postTime": "2 hrs ago",
      "postType": "Transformation",
      "caption": "Consistency is key! 3 months of hard work, macro adherence, and clean hydration. Lost 12 kg of fat and built massive endurance. Extremely proud of this shift! 💪🏋️",
      "image": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300",
      "likesCount": 142,
      "commentsCount": 18,
      "isLikedByUser": false,
      "achievementBadge": "Fat Loss Champion",
      "badgeColor": "0xffFF00E5",
      "comments": [
        {
          "author": "Priya Sharma",
          "avatar": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150",
          "text": "This is absolute beast mode, Arjun! Inspiring stuff."
        },
        {
          "author": "Dr. Rohit",
          "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150",
          "text": "Superb compliance score this month. Well deserved!"
        }
      ]
    },
    {
      "id": 2,
      "name": "Rohan Deshmukh",
      "authorName": "Rohan Deshmukh",
      "authorAvatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150",
      "postTime": "4 hrs ago",
      "postType": "Achievement",
      "caption": "Boom! Just hit a 21-day nutrition streak on my custom diet plan. No cheat meals, 100% adherence. Feeling stronger and lighter every single morning.",
      "image": "https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=300",
      "likesCount": 89,
      "commentsCount": 6,
      "isLikedByUser": true,
      "achievementBadge": "21-Day Streak Master",
      "badgeColor": "0xffFF7A00",
      "comments": [
        {
          "author": "Meera Joshi",
          "avatar": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150",
          "text": "Keep going! Don't break the chain 🔥"
        }
      ]
    },
    {
      "id": 3,
      "authorName": "Anjali Sen",
      "authorAvatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150",
      "postTime": "Yesterday",
      "postType": "MealPrep",
      "caption": "Sunday Meal Prep done! High protein grilled paneer salads, boiled eggs, veggies, and mixed seeds. Organizing meals ahead makes consistency effortless.",
      "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=300",
      "likesCount": 210,
      "commentsCount": 24,
      "isLikedByUser": false,
      "achievementBadge": "Meal Prep Pro",
      "badgeColor": "0xff00E5FF",
      "comments": [
        {
          "author": "Aman Verma",
          "avatar": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=150",
          "text": "Looks delicious! Can you share the macro split of the paneer salad?"
        }
      ]
    }
  ].obs;

  // New Post Form Reactive Fields
  final captionInput = "".obs;
  final postTypeInput = "Transformation".obs;
  final badgeInput = "".obs;
  final imageInput = "".obs;

  final postTypes = ["Transformation", "Achievement", "MealPrep", "Workout", "Motivation"];

  // Available Badges List to attach to a post
  final badgesList = [
    {"title": "Fat Loss Champion", "color": "0xffFF00E5"},
    {"title": "21-Day Streak Master", "color": "0xffFF7A00"},
    {"title": "Meal Prep Pro", "color": "0xff00E5FF"},
    {"title": "Hydration King", "color": "0xff00A3FF"},
    {"title": "None", "color": "0xffffffff"}
  ];

  final selectedBadgeIndex = 4.obs; // Default to "None"

  // Toggle Likes
  void toggleLike(int postId) {
    int index = posts.indexWhere((p) => p["id"] == postId);
    if (index != -1) {
      var post = Map<String, dynamic>.from(posts[index]);
      bool currentlyLiked = post["isLikedByUser"] as bool;
      post["isLikedByUser"] = !currentlyLiked;
      post["likesCount"] = currentlyLiked ? post["likesCount"] - 1 : post["likesCount"] + 1;
      posts[index] = post;
    }
  }

  // Add Comment
  void addComment(int postId, String commentText) {
    if (commentText.trim().isEmpty) return;

    int index = posts.indexWhere((p) => p["id"] == postId);
    if (index != -1) {
      var post = Map<String, dynamic>.from(posts[index]);
      var commentsList = List<Map<String, String>>.from(post["comments"]);
      
      commentsList.add({
        "author": "You (Arjun)",
        "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150",
        "text": commentText.trim()
      });

      post["comments"] = commentsList;
      post["commentsCount"] = commentsList.length;
      posts[index] = post;

      Get.snackbar(
        "Comment Posted",
        "Successfully added comment to post.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Create post
  void createPost() {
    if (captionInput.value.trim().isEmpty) {
      Get.snackbar(
        "Empty Caption",
        "Please type something for your transformation narrative.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    String? attachedBadge;
    String? attachedBadgeColor;

    if (selectedBadgeIndex.value != 4) {
      attachedBadge = badgesList[selectedBadgeIndex.value]["title"];
      attachedBadgeColor = badgesList[selectedBadgeIndex.value]["color"];
    }

    String mockPostImage = imageInput.value.isNotEmpty
        ? imageInput.value
        : "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300"; // default workout image

    final newPost = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "authorName": "Arjun Mehta",
      "authorAvatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150", // Arjun matching profile image
      "postTime": "Just now",
      "postType": postTypeInput.value,
      "caption": captionInput.value.trim(),
      "image": mockPostImage,
      "likesCount": 0,
      "commentsCount": 0,
      "isLikedByUser": false,
      "achievementBadge": attachedBadge,
      "badgeColor": attachedBadgeColor,
      "comments": <Map<String, String>>[]
    };

    posts.insert(0, newPost);

    // Reset fields
    captionInput.value = "";
    postTypeInput.value = "Transformation";
    selectedBadgeIndex.value = 4;
    imageInput.value = "";

    Get.snackbar(
      "Post Shared!",
      "Your achievement story has been published to the Social Room Feed.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
