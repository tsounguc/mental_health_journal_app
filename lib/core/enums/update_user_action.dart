enum UpdateUserAction {
  NAME(userData: ''),
  EMAIL(userData: ''),
  PROFILEPICTUREURL(userData: '');

  const UpdateUserAction({
    // required this.action,
    required this.userData,
  });
  // final String action;
  final String userData;
}
