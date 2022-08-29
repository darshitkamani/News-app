/// we are using "shared_preference" for storing data locally.
/// this is the class which will manage all the key.
class LocalCacheKey {
  /// this is the key to store the login state of user.
  static const String applicationLoginState = 'news_app_is_login';

  /// this is the key to store the login response of user.
  static const String applicationUserResponse = 'news_app_user_response';
}
