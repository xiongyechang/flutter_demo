import 'dart:math';

class Common {
  static int generateRandomNegativeInt({int min = 0, int max = 10000}) {
    Random random = Random();
    int range = max - min + 1;
    int randomInt = random.nextInt(range) + min;
    return -randomInt;
  }
}