#include <stdio.h>

char bloc[81] = {8,3,2,5,9,1,6,7,4,4,9,6,3,8,7,2,5,1,5,7,1,2,6,4,9,8,3,1,8,5,7,4,6,3,9,2,2,6,7,9,5,3,4,1,8,9,4,3,8,1,2,7,6,5,7,1,4,6,3,8,5,2,9,3,2,9,1,7,5,8,4,6,6,5,8,4,2,9,1,3,7};

void valider_bloc(int index) {
  for(int i = 0; i < 21; ++i) {
    if(i % 3 == 0 && i > 0) { i += 6;  }
    for(int j = i+1; j < 21; ++j) {
      if(j % 3 == 0 && j > 0) { j += 6; }
      printf("Vérification de i=%d, j=%d\n", index+i, index+j);
      if(bloc[index+i] == bloc[index+j]) {
         printf("Les blocs %d[%d] et %d[%d] sont identique.\n", index+i, bloc[index+i], index+j, bloc[index+j]);
      }
    }
  }
}

int main() {
  for(int y = 0; y < 3; ++y) {
    for(int x = 0; x < 3; ++x) {
      valider_bloc(y * 27 + x * 3);
    }
  }
}
