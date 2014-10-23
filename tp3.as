/*
  Félix Hamel
  IFT209, Devoir 3
*/


.global Main 		!Point d\'entrée, début du programme
.global Afficher	!Fonction qui affiche un entier.

.section ".text"


/* Début du programme */

Main:
  set   vecteur, %l0
  mov   0, %l1 ! Initialiser l1 à 0 pour s\'en servir dans Sudoku00

  ba  Sudoku00
  nop

/* Lecture des 81 chiffres formant le Sudoku */
Sudoku00:

  ! Afficher la demande du chifre
  set   demandechif, %o0
  mov   %l1, %o1
  call  printf
  nop

  ! Recevoir le chiffre
  set   lecture, %o0
  call  scanf
  nop

  ! Concerver le chiffre
  mul   %l1, 4, %l2     ! Emplacement où converver le chiffre
  st    %l1, [%l0+%l2]  ! Placer le chiffre dans le vecteur

  ! Véfifier si nous avons tout nos chiffres ou on doit continuer
  inc   %l1
  bl    %l1, 81
  Sudoku00           ! Continuer a recevoir des chiffres
  nop

  ba ValiderLignes   ! Valider le contenu du Sudoku
  nop


/* Afficher le Sudoku */
AfficherSudoku:
  mov   %l1, 0    ! %l1 va servir pour savoir on est rendu sur quelle ligne (0-8)
  mov   %l2, 0    ! %l2 va servir pour savoir on est rendu sur quelle colonne (0-8)


/* Valider le sudoku sur les 9 lignes */
ValiderLignes:
  mov   %l1, 0    ! %l1 va servir pour savoir on est rendu sur quelle ligne


ValiderColonnes:
  mov   %l1, 0    ! %l1 va servir pour savoir on est rendu sur quelle colonne

ValiderDiagonnales:


/* Variables */

.section ".rodata"
  demandechif:  .asciz  "Veuillez entrer le chiffre allant dans la case %d : "
	lignepleine:  .asciz 	"|---------|---------|---------|\n"
  lignenombre:  .asciz  "| %d  %d  %d | %d  %d  %d | %d  %d  %d |"


/* Espace mémoire */

.section ".bss"
  .align 	4	          ! Mots
  vecteur: 	.skip	324	! 81 espaces mémoire pour le vecteur du Sudoku
  lecture:	.skip	 4  ! Espace pour la lecture du chiffre en entrée
