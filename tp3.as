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
            1.1) Verifier que le chiffre est entre 1 et 9
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

  mov   0, %l2                  ! Compteur du chiffre courant sur la ligne
  mov   1, %l3                  ! Compteur du chiffre a tester avec le chiffre courant sur la ligne

  ba    ValiderLignes06         ! Lancer la validation de la ligne
  nop

ValiderLignes04:
  inc   %l1                     ! Ligne suivante
  add   %l0, 9, %l0             ! Déplacer le pointeur du Sudoku sur la prochaine ligne

  cmp   %l1, 9                  ! Si on a fait le tour du Sudoku, on passe au mode de validation suivant
  be    ValiderColonnes00
  nop

  ba    ValiderLignes02
  nop


ValiderLignes06:
  ldub  [%l0+%l2], %l4          ! Charger le chiffre courant en mémoire
    
  cmp   %l4, 0                  ! Le chiffre doit être entre 1 et 9
  ble   LigneInvalide
  nop

  cmp   %l4, 10
  bge   LigneInvalide
  nop

  ba    ValiderLignes10         ! Lancer la validation du chiffre courant sur la ligne
  nop


ValiderLignes08:
  inc   %l2                     ! Passer au chiffre suivant pour la validation
  add   %l2, 1, %l3             ! Le chiffre a tester est toujours le chiffre après le chiffre courant (au début de la validation du chiffre courant)

  cmp   %l2, 9                  ! Continuer a valider la ligne si chiffre courant n'est pas le dernier
  bl    ValiderLignes06
  nop

  set   resvalide, %o0      ! Affichage d'un message disant que la ligne est valide
  call  printf
  nop

  ba    ValiderLignes04
  nop


ValiderLignes10:
  cmp   %l2, 8
  bge   ValiderLignes08
  nop
 
  ldub  [%l0+%l3], %l5          ! Charger le chiffre a tester dans le registre l5
  
  !set   validation1, %o0        ! Debug INFOS
  !mov   %l2, %o1
  !mov   %l4, %o2
  !mov   %l3, %o3
  !mov   %l5, %o4
  !call  printf
  !nop

  cmp   %l4, %l5                ! Comparer le chiffre courant avec le chiffre a tester pour s'assurer qu'ils ne sont pas identique
  be    LigneInvalide
  nop

  inc   %l3                     ! Tester le chiffre suivant

  cmp   %l3, 9                  ! S'il nous reste des chiffre a tester, on les tests
  bl    ValiderLignes10
  nop
  
  ba    ValiderLignes08
  nop


LigneInvalide:
  set   resinvalide, %o0        ! Affichage d'un message disant que la ligne est invalide
  call  printf
  nop

  call  exit                    ! On quitte le programme
  nop

/*
    Partie 4 : Validation Colonne par colonne du Sudoku
    ---------------------------------------------------
*/

ValiderColonnes00:
  set   vecteur, %l0        ! Pointeur sur la colonnes courante
  mov   0, %l1              ! %l1 va servir pour savoir on est rendu sur quelle ligne

  /* start Aff */
  set   validcolon1, %o0
  call  printf
  nop
  /* end Aff */

ValiderColonnes02:
  set   validcolon2, %o0        ! Afficher qu'on valider la colonne courante
  mov   %l1, %o1
  call  printf
  nop

  mov   0, %l2                    ! Compteur du chiffre courant sur la colonne
  mov   1, %l3                    ! Compteur du chiffre a tester avec le chiffre courant sur la colonne

  ba    ValiderColonnes06         ! Lancer la validation de la colonne
  nop

ValiderColonnes04:
  inc   %l1                       ! colonne suivante

  set   vecteur, %l0              ! Déplacer le pointeur du Sudoku sur la prochaine colonne
  add   %l0, %l1, %l0

  cmp   %l1, 9                    ! Si on a fait le tour du Sudoku, on passe au mode de validation suivant
  be    VB00
  nop

  ba    ValiderColonnes02
  nop


ValiderColonnes06:
  umul  %l2, 9, %l6
  ldub  [%l0+%l6], %l4          ! Charger le chiffre courant en mémoire
    
  cmp   %l4, 0                  ! Le chiffre doit être entre 1 et 9
  ble   LigneInvalide
  nop

  cmp   %l4, 10
  bge   LigneInvalide
  nop

  ba    ValiderColonnes10         ! Lancer la validation du chiffre courant sur la colonne
  nop


ValiderColonnes08:
  inc   %l2                     ! Passer au chiffre suivant pour la validation
  add   %l2, 1, %l3             ! Le chiffre a tester est toujours le chiffre après le chiffre courant (au début de la validation du chiffre courant)

  cmp   %l2, 9                  ! Continuer a valider la colonne si chiffre courant n'est pas le dernier
  bl    ValiderColonnes06
  nop

  set   resvalide, %o0      ! Affichage d'un message disant que la colonne est valide
  call  printf
  nop

  ba    ValiderColonnes04
  nop


ValiderColonnes10:
  cmp   %l2, 8
  bge   ValiderColonnes08
  nop
 
  umul  %l3, 9, %l6
  ldub  [%l0+%l6], %l5          ! Charger le chiffre a tester dans le registre l5
  
  !set   validation1, %o0        ! Debug INFOS
  !mov   %l2, %o1
  !mov   %l4, %o2
  !mov   %l3, %o3
  !mov   %l5, %o4
  !call  printf
  !nop

  cmp   %l4, %l5                ! Comparer le chiffre courant avec le chiffre a tester pour s'assurer qu'ils ne sont pas identique
  be    LigneInvalide
  nop

  inc   %l3                     ! Tester le chiffre suivant

  cmp   %l3, 9                  ! S'il nous reste des chiffre a tester, on les tests
  bl    ValiderColonnes10
  nop
  
  ba    ValiderColonnes08
  nop

/*
    Partie 5 : Validation par bloc
    ---------------------------------------------------
*/
VB00:
  set   validbloc1, %o0
  call  printf
  nop

  mov   0, %l0          ! Y

VB02:
  cmp   %l0, 3          ! Après avoir testé tous les blocs, on quitte le programme
  be    SudokuFin
  nop
 
  mov   0, %l1          ! X
  ba    VB04            ! On valide les blocs sur la rangée l1
  nop

VB03:
  inc   %l0             ! On passe à la rangée de bloc suivante
  ba    VB02
  nop

VB04:
  cmp   %l1, 3          ! Si on a testé les 3 blocs sur la rangée, on passe à la prochaine
  be    VB03
  nop

  /* start AFF */
  set   validbloc2, %o0
  umul  %l0, 3, %o1
  add   %l1, %o1, %o1
  call  printf
  nop
  /* end AFF */

  umul  %l1, 3,  %o0    ! Calculer l'indice du premier element du bloc dans le vecteur
  umul  %l0, 27, %o1
  add   %o0, %o1, %o2   ! Index calculé
  set   vecteur, %o3
  call  VB10            ! Valider le bloc commençant a cet indice
  nop

  inc   %l1             ! On passe au bloc suivant sur la même rangée
  ba    VB04
  nop

VB10:
  save  %sp, -96, %sp   ! On concerve les registres. L'index du début va se trouver dans i2
  mov   0, %l0
  
VB11:
  cmp   %l0, 21
  be    VB20            ! Restore
  nop

  mov   %l0, %o0        ! Si le nombre est un multiple de 3, on change de ligne dans le Sudoku
  mov   3, %o1
  call  MultipleDe
  nop

  cmp   %o0, 1          ! Puisque c'est un multiple de 3, on doit changer de ligne
  be    VB13
  nop

  ba    VB14            ! Tester le reste du bloc avec le chiffre
  nop

VB12:
  inc   %l0             ! Tester le prochain nombre courant
  ba    VB11
  nop

VB13:
  add   %l0, 6, %l0     ! Changer de ligne

VB14:
  add   %i2, %l0, %l5   ! Index du chiffre qu'on veut aller chercher
  ldub  [%i3+%l5], %l3  ! Charger le chiffre courant dans l3
  add   %l0, 1, %l1     ! Chiffre testeur
  
VB15:
  cmp   %l1, 21
  be   VB12
  nop

  mov   %l1, %o0        ! Si le nombre est un multiple de 3, on change de ligne dans le Sudoku
  mov   3, %o1
  call  MultipleDe
  nop

  cmp   %o0, 1          ! Puisque c'est un multiple de 3, on doit changer de ligne
  bne   VB17
  nop

VB16:
  add   %l1, 6, %l1     ! Changer de ligne

VB17:
  add   %i2, %l1, %l5   ! Index du chiffre qu'on veut aller chercher
  ldub  [%i3+%l5], %l4  ! Charger le chiffre a tester dans l4
  
  /* start AFF */
  !set   validation1, %o0
  !mov   %l0, %o1
  !mov   %l3, %o2
  !mov   %l1, %o3
  !mov   %l4, %o4
  !call  printf
  !nop
  /* end AFF */

  cmp   %l3, %l4        ! S'assurer que les 2 chiffres sont différents
  bne   VB19
  nop

VB18:
  set   resinvalide, %o0    ! Afficher que le bloc n'est pas valide
  call  printf
  nop

  ba    SudokuFin           ! Fin du programme
  nop

VB19:
  inc   %l1             ! Tester le nombre courant avec un autre chiffre dans le bloc
  ba    VB15
  nop

VB20:
  set   resvalide, %o0
  call  printf
  nop
 
  ret                   ! Passer au bloc suivant
  restore

/*
    Vérifier si le nombre donné dans o0 est un multiple de o1.
    Résultat : o0 -> 0 = n'est pas un multiple, 1 = c'est un multiple
*/
MultipleDe:
  save  %sp, -104, %sp  ! Concerver les registres.
  mov   0, %y			! initialise %y pour la division

  cmp   %i0, 0          ! Si le nombre est 0, il ne peut être un multiple
  be    MultipleDe02
  nop

  udiv  %i0, %i1, %i2
  umul  %i2, %i1, %i3

  /* DEBUG */
  !set   debugmultiple1, %o0
  !mov   %i0, %o1
  !mov   %i1, %o2
  !mov   %i2, %o3
  !call  printf
  !nop

  !set   debugmultiple2, %o0
  !mov   %i2, %o1
  !mov   %i1, %o2
  !mov   %i3, %o3
  !call  printf
  !nop
  /* END DEBUG */

  cmp   %i0, %i3        ! Comparer le nombre initial et le nombre divisé puis multiplié par le même nombre
  be    MultipleDe04    ! C'est un multiple
  nop
  
MultipleDe02:
  mov   0, %i0          ! Ce n'est pas un multiple
  ba    MultipleDe06
  nop

MultipleDe04:
  mov   1, %i0          ! C'est un multiple

MultipleDe06:
  ret                   ! Retour au programme
  restore

/*
    Fin du programme
*/
SudokuFin:
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
  validation1:       .asciz  "Validation entre %d[%d] et %d[%d]...\n"
  validcolon1:       .asciz  "Validation des colonnes du Sudoku\n"
  validcolon2:       .asciz  " - Validation de la colonne #%d... "
  validbloc1:        .asciz  "Validation des blocs du Sudoku\n"
  validbloc2:        .asciz  " - Validation du bloc #%d... "
  resvalide:         .asciz  "Valide !\n"
  resinvalide:       .asciz  "Invalide !\n"
  debugmultiple1:    .asciz  "## %d / %d = %d +-+ "
  debugmultiple2:    .asciz  "%d * %d = %d\n"

/* Espace mémoire */

.section ".bss"

            .align 	1   ! Octet
  !vecteur: .skip	81  ! 81 espaces mémoire pour le vecteur du Sudoku

.section ".data"

  lecture:  .byte   0   ! Espace pour la lecture du chiffre en entrée
  vecteur:  .byte   8,3,2,5,9,1,6,7,4,4,9,6,3,8,7,2,5,1,5,7,1,2,6,4,9,8,3,1,8,5,7,4,6,3,9,2,2,6,7,9,5,3,4,1,8,9,4,3,8,1,2,7,6,5,7,1,4,6,3,8,5,2,9,3,2,9,1,7,5,8,4,6,6,5,8,4,2,9,1,3,7
