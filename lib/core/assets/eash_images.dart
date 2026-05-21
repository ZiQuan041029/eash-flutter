/// Central image paths — keep filenames aligned with `assets/images/` (case-sensitive on CI).
abstract final class EashImages {
  static const String _root = 'assets/images';

  static const String exit = '$_root/Exit.png';
  static const String exit2 = '$_root/exit2.png';
  static const String search2 = '$_root/search2.png';
  static const String searchRecent = '$_root/recent.png';

  static const String homeAvatar = '$_root/dude2.png';
  static const String profileAvatar = '$_root/dude2.png';

  /// Landing (Figma 01-welcome) — layered hero art.
  static const String landingBack = '$_root/landing_back.png';
  /// Case-sensitive on Android — file is `Landing_name.png` in assets.
  static const String landingName = '$_root/Landing_name.png';
  static const String landingStudent = '$_root/landing_student.png';
  static const String landingCoffeeCup = '$_root/landing_coffee.png';
  static const String landingPizza = '$_root/landing_pizza.png';
  static const String landingFood = '$_root/landing_food.png';
  static const String landingPickleball = '$_root/landing_pickleball.png';

  /// Profile tab assets (Figma exports in `assets/images/`).
  static const String profileFire = '$_root/fire.png';
  static const String profileBenefitBurger = '$_root/burger.png';
  static const String profileBenefitHeadset = '$_root/headset.png';
  static const String profileMissionProfile = '$_root/profile.png';
  static const String profileMissionComplete = '$_root/complete.png';
  static const String profileMission50 = '$_root/50%.png';
  static const String profileMissionCoffee = '$_root/coffee2.png';
  static const String profileMissionVisaVerify = '$_root/visa_verify.png';
  static const String iconCamera = '$_root/camera_visa.png';
  /// Profile avatar photo badge (same asset as [iconCamera]).
  static const String profileCameraBadge = iconCamera;

  static const String iconName = '$_root/name.png';
  static const String iconNationality = '$_root/nationality.png';
  static const String iconAddress = '$_root/address.png';
  static const String iconEmail = '$_root/email.png';
  static const String iconPassword = '$_root/password.png';

  static const String navHome = '$_root/home.png';
  static const String navDiscover = '$_root/discover.png';
  static const String navEvents = '$_root/event.png';
  static const String navProfile = '$_root/profile.png';

  /// Trending / quick-access category art (Discover + Home).
  static const String trendNasiLemak = '$_root/nasilemak.png';
  static const String trendHousing = '$_root/housing1.png';
  static const String trendFair = '$_root/fair.png';
  static const String trendBluePlane = '$_root/blue_plane.png';
  static const String trendTrophy = '$_root/trophy.png';
  static const String trendPinkMegaphone = '$_root/pink_megaphone.png';

  /// Home Quick Access row — not the same art as [DiscoverTrendingCategories].
  static const String quickAccessFood = '$_root/pizza.png';
  static const String quickAccessClubs = '$_root/Clubs.png';
  /// User asset was `Event1.png`; repo has `Event2.png` (megaphone-style).
  static const String quickAccessEvents = '$_root/Event2.png';
  static const String quickAccessHousing = '$_root/Housing.png';

  static const String feedLike = '$_root/like.png';
  static const String feedComment = '$_root/comment.png';

  /// Small KAI icon on the home card (has a flat purple fill).
  static const String kaiAvatar = '$_root/kai.png';

  /// Chat/header circular avatar.
  static const String kaiChatPortrait = '$_root/kai3.png';

  /// Large KAI illustration on the home card.
  static const String kaiHero = '$_root/kai2.png';
  static const String kaiChatSend = '$_root/ask_kai.png';
  static const String kaiChatMic = '$_root/mic.png';
  static const String kaiAddressCard = '$_root/address_kai.png';

  static const String notificationsEarth = '$_root/earth.png';
  static const String notiDone = '$_root/noti_done.png';
  static const String notiLight = '$_root/noti_light.png';
  /// Mark-all-read confirmation sheet icon.
  static const String notiRead = '$_root/noti_read.png';

  static const String notiBurger = '$_root/burger.png';
  static const String notiProfile = '$_root/profile.png';
  static const String notiEvent = '$_root/event.png';

  /// Swipe-delete action (white trash on transparent).
  static const String notiDelete = '$_root/delete.png';
}
