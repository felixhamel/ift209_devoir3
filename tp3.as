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
  bg    ValiderLignes00     ! Lancer la validation du Sudoku
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
ValiderLignes00:
  set   vecteur, %l0        ! Pointeur sur la ligne courante
  mov   0, %l1              ! %l1 va servir pour savoir on est rendu sur quelle ligne

  /* start Aff */
  set   validligne1, %o0
  call  printf
  nop
  /* end Aff */

  ba    ValiderLignes02     ! Lancer la validation des lignes
  nop
  

/* Validation de la ligne courante */
ValiderLignes02:
  set   validligne2, %o0        ! Afficher qu'on valider la ligne courante
  mov   %l1, %o1
  call  printf
  nop

  mov   0, %l2                  ! Compteur du nombre courant sur la ligne
  mov   1, %l3                  ! Compteur du nombre a tester avec le nombre courant sur la ligne

  ba    ValiderLignes04         ! Lancer la validation de la ligne
  nop

ValiderLignes03:
  inc   %l1                     ! Ligne suivante
  add   %l0, 9, %l0             ! Déplacer le pointeur du Sudoku sur la prochaine ligne

  cmp   %l1, 9                  ! Si on a fait le tour du Sudoku, on passe au mode de validation suivant
  be    ValiderColonnes00
  nop

  ba    ValiderLignes02
  nop


ValiderLignes04:
  ldub  [%l0+%l2], %l4          ! Charger le nombre courant en mémoire
    
  cmp   %l4, 0                  ! Le chiffre doit être entre 1 et 9
  ble   LigneInvalide
  nop

  cmp   %l4, 10
  bge   LigneInvalide
  nop

  ba    ValiderLignes06         ! Lancer la validation du nombre courant sur la ligne
  nop


ValiderLignes05:
  inc   %l2                     ! Passer au nombre suivant pour la validation
  add   %l2, 1, %l3             ! Le nombre a tester est toujours le nombre après le nombre courant (au début de la validation du nombre courant)

  cmp   %l2, 9                  ! Continuer a valider la ligne si nombre courant n'est pas le dernier
  bl    ValiderLignes04
  nop

  set   resvalide, %o0      ! Affichage d'un message disant que la ligne est valide
  call  printf
  nop

  ba    ValiderLignes03
  nop


ValiderLignes06:
  cmp   %l2, 8
  bge   ValiderLignes05
  nop
 
  ldub  [%l0+%l3], %l5          ! Charger le nombre a tester dans le registre l5
  
  !set   validligne3, %o0        ! Debug INFOS
  !mov   %l2, %o1
  !mov   %l4, %o2
  !mov   %l3, %o3
  !mov   %l5, %o4
  !call  printf
  !nop

  cmp   %l4, %l5                ! Comparer le nombre courant avec le nombre a tester pour s'assurer qu'ils ne sont pas identique
  be    LigneInvalide
  nop

  inc   %l3                     ! Tester le nombre suivant

  cmp   %l3, 9                  ! S'il nous reste des chiffre a tester, on les tests
  bl    ValiderLignes06
  nop
  
  ba    ValiderLignes05
  nop


LigneInvalide:
  set   redinvalide, %o0      ! Affichage d'un message disant que la ligne est invalide
  call  printf
  nop

  call  exit                    ! On quitte le programme
  nop

ValiderColonnes00:
  call  exit
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
  validligne2:       .asciz  " - Validation de la ligne #%d... "
  validligne3:       .asciz  "Validation entre %d[%d] et %d[%d]...\n"
  resvalide:         .asciz  "Valide !\n"
  redinvalide:       .asciz  "Invalide !\n"

/* Espace mémoire */

.section ".bss"

            .align 	1   ! Octet
  !vecteur: 	.skip	81  ! 81 espaces mémoire pour le vecteur du Sudoku

.section ".data"

  lecture:  .byte   0   ! Espace pour la lecture du chiffre en entrée
  vecteur:  .byte   8,3,2,5,9,1,6,7,4,4,9,6,3,8,7,2,5,1,5,7,1,2,6,4,9,8,3,1,8,5,7,4,6,3,9,2,2,6,7,9,5,3,4,8,1,9,4,3,8,1,2,7,6,5,7,1,4,6,3,8,5,2,9,3,2,9,1,7,5,8,4,6,6,5,8,4,2,9,1,3,7,7
!3

