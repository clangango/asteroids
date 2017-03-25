class Menu {
  int page = 0;

  Menu(int pageNumber) {
    page = 0;
    if (page == 0) {
      startScreen();
    }else if (page == 1) {
      gameScreen();
    }else if (page == 2) {
      gameOver();
    }
  }

  void startScreen() {
    text("Start game?",width/2 ,height/2);
  }

  void gameScreen() {

  }
}
