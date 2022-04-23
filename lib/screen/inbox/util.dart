enum NavLinks { Home, Github, Videos, Jobs }

String displayString(NavLinks link) {
  switch(link) {
    case NavLinks.Home:
      return "Home";
      break;

    case NavLinks.Github:
      return "Github";
      break;
    case NavLinks.Videos:
      return "Videos";
      break;

    case NavLinks.Jobs:
      return "Jobs";
      break;

    default:
      return "";

  }
}