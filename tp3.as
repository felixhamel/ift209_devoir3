/*
  Félix Hamel
  IFT209, Devoir 3
*/

.global Main 		!Point d entrée, début du programme

.section ".text"

/* Début du programme */

Main:
  set   vecteur, %l0
  mov   0, %l1 ! Initialiser l1 à 0 pour s en servir dans Sudoku00

  !ba    Sudoku00
  ba   AfficherSudoku
  nop

/*
    Partie 1 : Lecture du Sudoku
    ---------------------------------------------------
*/

/* Lecture des 81 chiffres formant le Sudoku */
Sudoku00:
  set   lecturecons, %o0 ! Recevoir le chiffre
  set   lecture, %o1
  call  scanf
  nop

  ldub    [%o1], %l2       ! Aller lire le chiffre donné
  
  /* start DEBUG */
  set   afficherchiffre, %o0
  mov   %l2, %o1
  call  printf
  nop
  /* end DEBUG */

  stb   %l2, [%l0+%l1]   ! Placer le chiffre dans le vecteur

  cmp   %l1, 80          ! Véfifier si nous avons tout nos chiffres ou on doit continuer
  bl    Sudoku00         ! Continuer a recevoir des chiffres
  inc   %l1

  ba AfficherSudoku      ! Afficher le Sudoku
  nop


ValiderDiagonnales:
  nop

/*
    Partie 2 : Affichage du Sudoku
    ---------------------------------------------------
*/

AfficherSudoku:
  mov   3, %l1      ! Compteur de ligne qui se reset a chaque 3 lignes
  mov   0, %l2      ! Compteur de ligne qui se reset pas a chaque 3 lignes
  
  ba    AfficherSudoku00
  nop

/* Afficher le Sudoku */
AfficherSudoku00:
  mov   3, %l3              ! Compteur de colonne qui se reset a chaque 3 chiffres
  mov   0, %l4              ! Compteur de colonne qui se reset pas a chaque 3 chiffres

  cmp   %l1, 3              ! Si 3, on afficher une ligne pleine
  be    AfficherSudoku02
  nop

  inc   %l1                 ! Passer à la prochaine ligne
  inc   %l2

  cmp   %l2, 9
  bg    ValiderLignes       ! Lancer la validation du Sudoku
  nop

  ba  AfficherSudoku04      ! Afficher une ligne du Sudoku avec des chiffres
  nop

/* Afficher une ligne pleine */
AfficherSudoku02:
  set   lignepleine, %o0        ! Afficher la ligne pleine
  call  printf
  mov   0, %l1                  ! Remettre le compteur de ligne à 0

  ba AfficherSudoku00
  nop

/* Afficher une ligne */
AfficherSudoku04:
  cmp   %l3, 3                  ! Afficher la ligne horizontale
  be    AfficherSudoku06
  nop

  cmp   %l4, 9                  ! Afficher le retour de ligne
  bge   AfficherSudoku08
  nop

  cmp   %l3, 3
  bl    AfficherSudoku10        ! Afficher le chiffre courant
  nop

  retl  ! Retour à l'affichage des autres lignes

/* Afficher la barre horizontale */
AfficherSudoku06:
  set   barrehorizo, %o0
  call  printf
  nop

  mov   0, %l3

  ba    AfficherSudoku04
  nop

/* Afficher un retour de ligne */
AfficherSudoku08:
  set   sautligne, %o0
  call  printf
  nop

  ba    AfficherSudoku00
  nop   

/* Afficher un chiffre du Sudoku */
AfficherSudoku10:  
  inc   %l3                     ! Passer au chiffre suivant
  inc   %l4

  set   afficherchiffre, %o0
  ldub  [%l0], %o1
  call  printf
  nop

  inc   1, %l0                  ! Passer au chiffre suivant pour le prochain affichage
  ba    AfficherSudoku04
  nop

/*
    Partie 3 : Validation du Sudoku ligne par ligne
    ---------------------------------------------------
*/

/*
    ALGO:
        1) Lignes :
            1.1) Verifier que le nombre est entre 1 et 9
            1.2) Vérifier les autres chiffres pour voir s'il y en a un autre identique. Aller de la manière suivante : 1->2, 1->3... 2->3, 7->8, 7->9, 8->9
*/

/* Valider le sudoku sur les 9 lignes */
ValiderLignes:
  set   vecteur, %l0        ! Pointeur sur la ligne courante
  mov   0, %l1              ! %l1 va servir pour savoir on est rendu sur quelle ligne

  /* start Aff */
  set   validligne1, %o0
  call  printf
  nop
  /* end Aff */

  ba    ValiderLignes00     ! Lancer la validation des lignes
  nop
  

/* Validation de la ligne courante */
ValiderLignes00:
  mov   0, %l2        ! %l2 va servir pour savoir on est rendu sur quel chiffre

  /* start Aff */
  set   validligne2, %o0
  mov   %l1, %o1
  call  printf
  nop
  /* end Aff */

  ba    ValiderLignes02     ! Lancer la validation de la ligne
  nop
  

/* Lancer la validation pour le chiffre à la position de %l0 jusqu'a ce que le 9e chiffre de la ligne soit testé */
ValiderLignes02:
  add   %l1, 1, %l2     ! On se sert de l2 pour savoir le chiffre avec lequel on compare le chiffre   
  
  ldub  [%l0], %l3      ! Charger le nombre courant dans l3

  cmp   %l3, 0          ! Si le nombre courant est <= 0, la ligne est invalide
  ble   ValiderLigne06
  nop

  cmp   %l3, 10
  bge   ValiderLigne06  ! Si le chiffre courant est >= 10, la ligne est invalide
  nop

  ! S'assurer que le nombre est plus grand de 0 et plus petit de 10
  

/* Valider tout les nombres en partant de %l2 en allant jusqu'au 9e chiffre */
ValiderLignes04:
  nop


/* Erreur dans la ligne */
ValiderLignes06:
  set   validligneinc, %o0      ! Afficher que la ligne est invalide comme résultat de la validation
  call  printf
  nop  

  call  exit                    ! Et on sort du programme !
  nop

ValiderLignes08:
  set   validlignecor, %o0
  call  printf
  nop

  ba    ValiderLignes00
  nop

/* 
    Variables
    ---------------------------------------------------
*/

.section ".rodata"

  lignepleine:       .asciz  "|---------|---------|---------|\n"
  afficherchiffre:   .asciz  " %d "
  barrehorizo:       .asciz  "|"
  sautligne:         .asciz  "\n"
  lecturecons:       .asciz  "%d"
  validligne1:       .asciz  "Validation des lignes du Sudoku\n"
  validligne2:       .asciz  "Ligne #%d..."
  validligne3:       .asciz  "Ligne #%d, validation entre %d[%d] et %d[%d]..."
  validlignecor:     .asciz  "Valide !\n"
  validligneinc:     .asciz  "Invalide !\n"

/* Espace mémoire */

.section ".bss"

            .align 	1   ! Octet
  !vecteur: 	.skip	81  ! 81 espaces mémoire pour le vecteur du Sudoku

.section ".data"

  lecture:  .byte   0   ! Espace pour la lecture du chiffre en entrée
  vecteur:  .byte   8,3,2,5,9,1,6,7,4,4,9,6,3,8,7,2,5,1,5,7,1,2,6,4,9,8,3,1,8,5,7,4,6,3,9,2,2,6,7,9,5,3,4,1,8,9,4,3,8,1,2,7,6,5,7,1,4,6,3,8,5,2,9,3,2,9,1,7,5,8,4,6,6,5,8,4,2,9,1,3,7,7


