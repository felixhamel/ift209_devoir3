/*
  Félix Hamel
  IFT209, Devoir 3
*/

.global Main 		!Point d'entrée, début du programme

.section ".text"

/* Début du programme */

Main:
  set   vecteur, %l0
  mov   0, %l1 ! Initialiser l1 à 0 pour s en servir dans Sudoku00

  !ba    Sudoku00
  !ba   AfficherSudoku
  !nop

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

  set   lecture, %l7
  ld    [%l7], %l2       ! Aller lire le chiffre donné
  
  /* start DEBUG */
  !set   afficherchiffre, %o0
  !mov   %l2, %o1
  !call  printf
  !nop
  /* end DEBUG */
  
  stb   %l2, [%l0+%l1]   ! Placer le chiffre dans le vecteur

  cmp   %l1, 80          ! Véfifier si nous avons tout nos chiffres ou on doit continuer
  bl    Sudoku00         ! Continuer a recevoir des chiffres
  inc   %l1

/*
    Partie 2 : Affichage du Sudoku
    ---------------------------------------------------
*/

AfficherSudoku:
  mov   3, %l1      ! Compteur de ligne qui se reset a chaque 3 lignes
  mov   0, %l2      ! Compteur de ligne qui se reset pas a chaque 3 lignes

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

/* Valider le sudoku sur les 9 lignes */
ValiderLignes00:
  set   vecteur, %l0            ! Pointeur sur la ligne courante
  mov   0, %l1                  ! %l1 va servir pour savoir on est rendu sur quelle ligne

/* Validation de la ligne courante */
ValiderLignes02:
  mov   0, %l2                  ! Compteur du chiffre courant sur la ligne
  mov   1, %l3                  ! Compteur du chiffre a tester avec le chiffre courant sur la ligne

  ba    ValiderLignes06         ! Lancer la validation de la ligne
  nop

/* Changer de ligne */
ValiderLignes04:
  inc   %l1                     ! Ligne suivante
  add   %l0, 9, %l0             ! Déplacer le pointeur du Sudoku sur la prochaine ligne

  cmp   %l1, 9                  ! Si on a fait le tour du Sudoku, on passe au mode de validation suivant
  be    ValiderColonnes00
  nop

  ba    ValiderLignes02         ! Passer a la ligne suivante
  nop

/* Validation du chiffre courant */
ValiderLignes06:
  ldub  [%l0+%l2], %l4          ! Charger le chiffre courant en mémoire
    
  cmp   %l4, 0                  ! Le chiffre doit être entre 1 et 9
  ble   ValiderLignes07
  nop

  cmp   %l4, 10
  bge   ValiderLignes07
  nop

  ba    ValiderLignes10         ! Lancer la validation du chiffre courant sur la ligne
  nop

/* Message d'erreur */
ValiderLignes07:
  set   validationrangee, %o0  ! Indiquer qu'on a trouvé une erreur dans la ligne courante
  add   %l1, 1, %o1
  call  printf
  nop

  ba	ValiderLignes04		! Passer a la ligne suivant
  nop

/* Valider tout les chiffres en partant du premier au dernier et ne valider que le dernier chiffre sans testeur. */
ValiderLignes09:
  inc   %l2                     ! Passer au chiffre suivant pour la validation
  add   %l2, 1, %l3             ! Le chiffre a tester est toujours le chiffre après le chiffre courant (au début de la validation du chiffre courant)

  cmp   %l2, 9                  ! Continuer a valider la ligne si chiffre courant n'est pas le dernier
  bl    ValiderLignes06
  nop

  ba    ValiderLignes04
  nop

/* Valider toute la ligne a partir du chiffre courant avec le reste des chiffres de la ligne */
ValiderLignes10:
  cmp   %l2, 8                  ! Si on a atteint la fin de la ligne, on passe a la suivante
  bge   ValiderLignes09
  nop
 
  ldub  [%l0+%l3], %l5          ! Charger le chiffre a tester dans le registre l5

  cmp   %l4, %l5                ! Comparer le chiffre courant avec le chiffre a tester pour s'assurer qu'ils ne sont pas identique
  be    ValiderLignes07
  nop

  ba 	ValiderLignes14		! Passer au prochain chiffre
  nop

ValiderLignes14:
  inc   %l3                     ! Tester le chiffre suivant

  cmp   %l3, 9                  ! S'il nous reste des chiffre a tester, on les tests
  bl    ValiderLignes10
  nop
  
  ba    ValiderLignes09
  nop

/*
    Partie 4 : Validation Colonne par colonne du Sudoku
    ---------------------------------------------------
*/

ValiderColonnes00:
  set   vecteur, %l0        ! Pointeur sur la colonnes courante
  mov   0, %l1              ! %l1 va servir pour savoir on est rendu sur quelle colonne

/* Initialisation de la validation par colonnes */
ValiderColonnes02:
  mov   0, %l2                    ! Compteur du chiffre courant sur la colonne
  mov   1, %l3                    ! Compteur du chiffre a tester avec le chiffre courant sur la colonne

  ba    ValiderColonnes06         ! Lancer la validation de la colonne
  nop

/* Changer de colonne */
ValiderColonnes04:
  inc   %l1                       ! colonne suivante

  set   vecteur, %l0              ! Déplacer le pointeur du Sudoku sur la prochaine colonne
  add   %l0, %l1, %l0

  cmp   %l1, 9                    ! Si on a fait le tour du Sudoku, on passe au mode de validation suivant
  be    ValiderBloc00
  nop

  ba    ValiderColonnes02
  nop

/* Validation du chiffre courant */
ValiderColonnes06:
  umul  %l2, 9, %l6
  ldub  [%l0+%l6], %l4          ! Charger le chiffre courant en mémoire
    
  cmp   %l4, 0                  ! Le chiffre doit être entre 1 et 9
  ble   ValiderColonnes07
  nop

  cmp   %l4, 10
  bge   ValiderColonnes07
  nop

  ba    ValiderColonnes10         ! Lancer la validation du chiffre courant sur la colonne
  nop

ValiderColonnes07:
  set   validationcolonne, %o0  ! Indiquer qu'on a trouvé une erreur dans la colonne courante
  add   %l1, 1, %o1
  call  printf
  nop

  ba	ValiderColonnes04
  nop

/* Valider tout les chiffres en partant du premier au dernier et ne valider que le dernier chiffre sans testeur. */
ValiderColonnes09:
  inc   %l2                     ! Passer au chiffre suivant pour la validation
  add   %l2, 1, %l3             ! Le chiffre a tester est toujours le chiffre après le chiffre courant (au début de la validation du chiffre courant)

  cmp   %l2, 9                  ! Continuer a valider la colonne si chiffre courant n'est pas le dernier
  bl    ValiderColonnes06
  nop

  ba    ValiderColonnes04
  nop

/* Valider toute la colonne a partir du chiffre courant avec le reste des chiffres de la colonne */
ValiderColonnes10:
  cmp   %l2, 8                  ! Si on a atteint la fin de la colonne, on passe a la prochaine
  bge   ValiderColonnes09
  nop
 
  umul  %l3, 9, %l6             ! Puisqu'on y va par colonnes, on doit y aller ligne par ligne
  ldub  [%l0+%l6], %l5          ! Charger le chiffre a tester dans le registre l5

  cmp   %l4, %l5                ! Comparer le chiffre courant avec le chiffre a tester pour s'assurer qu'ils ne sont pas identique
  be    ValiderColonnes07
  nop

  inc   %l3                     ! Tester le chiffre suivant

  cmp   %l3, 9                  ! S'il nous reste des chiffre a tester, on les tests
  bl    ValiderColonnes10
  nop
  
  ba    ValiderColonnes09
  nop
  

/*
    Partie 5 : Validation par bloc
    ---------------------------------------------------
*/
ValiderBloc00:
  mov   0, %l0              ! Y

ValiderBloc02:
  cmp   %l0, 3              ! Après avoir testé tous les blocs, on quitte le programme
  be    SudokuFin
  nop
 
  mov   0, %l1              ! X
  ba    ValiderBloc06       ! On valide les blocs sur la rangée l1
  nop

ValiderBloc04:
  inc   %l0                 ! On passe à la rangée de bloc suivante
  ba    ValiderBloc02
  nop

ValiderBloc06:
  cmp   %l1, 3              ! Si on a testé les 3 blocs sur la rangée, on passe à la prochaine
  be    ValiderBloc04
  nop
 
  umul  %l1, 3,  %o0        ! Calculer l'indice du premier element du bloc dans le vecteur
  umul  %l0, 27, %o1
  add   %o0, %o1, %o2       ! Index calculé

  umul  %l0, 3, %o3         ! # du bloc
  add	%o3, %l1, %o3

  add   %l1, %o4, %o4

  call  ValiderBloc10       ! Valider le bloc commençant a cet indice
  nop

  inc   %l1                 ! On passe au bloc suivant sur la même rangée
  ba    ValiderBloc06
  nop

ValiderBloc10:
  save  %sp, -96, %sp       ! On concerve les registres. L'index du début va se trouver dans i2
  mov   0, %l0
  set   vecteur, %l6	    ! Conserver l'adresse du vecteur dans le registre l6
  
ValiderBloc12:
  cmp   %l0, 21
  be    ValiderBloc30       ! Restore
  nop

  mov   %l0, %o0            ! Si le nombre est un multiple de 3, on change de ligne dans le Sudoku
  mov   3, %o1
  call  MultipleDe
  nop

  cmp   %o0, 1              ! Puisque c'est un multiple de 3, on doit changer de ligne
  be    ValiderBloc16
  nop

  ba    ValiderBloc18       ! Tester le reste du bloc avec le chiffre
  nop

ValiderBloc14:
  inc   %l0                 ! Tester le prochain nombre courant
  ba    ValiderBloc12
  nop

ValiderBloc16:
  add   %l0, 6, %l0         ! Changer de ligne

ValiderBloc18:
  add   %i2, %l0, %l5       ! Index du chiffre qu'on veut aller chercher
  ldub  [%l6+%l5], %l3      ! Charger le chiffre courant dans l3
  add   %l0, 1, %l1         ! Chiffre testeur
  
ValiderBloc20:
  cmp   %l1, 21
  be   ValiderBloc14
  nop

  mov   %l1, %o0            ! Si le nombre est un multiple de 3, on change de ligne dans le Sudoku
  mov   3, %o1
  call  MultipleDe
  nop

  cmp   %o0, 1              ! Puisque c'est un multiple de 3, on doit changer de ligne
  bne   ValiderBloc24
  nop

ValiderBloc22:
  add   %l1, 6, %l1         ! Changer de ligne

ValiderBloc24:
  add   %i2, %l1, %l5       ! Index du chiffre qu'on veut aller chercher
  ldub  [%l6+%l5], %l4      ! Charger le chiffre a tester dans l4

  cmp   %l3, %l4            ! S'assurer que les 2 chiffres sont différents
  bne   ValiderBloc28
  nop

ValiderBloc26:
  set   validationbloc, %o0 ! Indiquer qu'on a trouvé une erreur au bloc courant
  add   %i3, 1, %o1
  call  printf
  nop

  ba	ValiderBloc30       ! On passe au prochain bloc
  nop

ValiderBloc28:
  inc   %l1                 ! Tester le nombre courant avec un autre chiffre dans le bloc
  ba    ValiderBloc20
  nop

ValiderBloc30: 
  ret                       ! Passer au bloc suivant
  restore


/*
    MultipleDe:
    ---------------------
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

/* Variables */
.section ".rodata"
  lignepleine:       .asciz  "|---------|---------|---------|\n"
  afficherchiffre:   .asciz  " %d "
  barrehorizo:       .asciz  "|"
  sautligne:         .asciz  "\n"
  lecturecons:       .asciz  "\n%d"
  validationrangee:  .asciz  "Le sudoku contient une erreur dans la rangée %d\n"
  validationcolonne: .asciz  "Le sudoku contient une erreur dans la colonne %d\n"
  validationbloc:    .asciz  "Le sudoku contient une erreur dans le bloc %d\n"

/* Espaces mémoire */
.section ".bss"
           .align 	1   ! Octet
  vecteur: .skip	81  ! 81 espaces mémoire pour le vecteur du Sudoku

.section ".data"
  lecture:  .word   	0   ! Espace pour la lecture du chiffre en entrée
