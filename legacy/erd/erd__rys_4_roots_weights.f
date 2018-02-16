C  Copyright (c) 2003-2010 University of Florida
C
C  This program is free software; you can redistribute it and/or modify
C  it under the terms of the GNU General Public License as published by
C  the Free Software Foundation; either version 2 of the License, or
C  (at your option) any later version.

C  This program is distributed in the hope that it will be useful,
C  but WITHOUT ANY WARRANTY; without even the implied warranty of
C  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C  GNU General Public License for more details.

C  The GNU General Public License is included in this distribution
C  in the file COPYRIGHT.
         SUBROUTINE  ERD__RYS_4_ROOTS_WEIGHTS
     +
     +                    ( NT,NTGQP,
     +                      TVAL,
     +
     +                             RTS,
     +                             WTS )
     +
C------------------------------------------------------------------------
C  OPERATION   : ERD__RYS_4_ROOTS_WEIGHTS
C  MODULE      : ELECTRON REPULSION INTEGRALS DIRECT
C  MODULE-ID   : ERD
C  SUBROUTINES : none
C  DESCRIPTION : This operation returns Rys polynomial roots and weights
C                in case the number of roots and weights required
C                is = 4. All T's are treated at once so the complete
C                set of roots and weights is returned.
C
C                For the moment taken essentially unchanged from the
C                GAMESS package (routine ROOT4, but removing their
C                'spaghetti' code from the 70's of unreadable
C                internested IFs and GOTOs!).
C
C                One interesting aspect of the GAMESS routines is that
C                their code returns scaled roots, i.e. their roots
C                do not ly between the range 0 and 1. To get to the
C                proper roots as needed for our package, we simply
C                set:
C
C                   root (our) = root (gamess) / (1 + root (games))
C
C
C                  Input:
C
C                    NT           =  # of T-exponents
C                    NTGQP        =  # of roots times # of T-exponents
C                                    (= 4 * NT)
C                    TVAL         =  the set of NT T-exponents defining
C                                    the Rys weight functions
C
C                  Output:
C
C                    RTS          =  all NTGQP quadrature roots
C                    WTS          =  all NTGQP quadrature weights
C
C
C  AUTHOR      : Norbert Flocke
C------------------------------------------------------------------------
C
C
C             ...include files and declare variables.
C
C
         IMPLICIT   NONE

         INTEGER    M,N
         INTEGER    NT,NTGQP
         INTEGER    TCASE

         INTEGER    JUMP4 (1:54)

         DOUBLE PRECISION   E,T,X,Y
         DOUBLE PRECISION   PI4
         DOUBLE PRECISION   R1,R2,R3,R4
         DOUBLE PRECISION   R14,R24,R34,R44
         DOUBLE PRECISION   T4MAX
         DOUBLE PRECISION   W1,W2,W3,W4
         DOUBLE PRECISION   W24,W34,W44
         DOUBLE PRECISION   HALF,ONE,TWO,THREE,HALFP7,HALFP12,HALFP17

         DOUBLE PRECISION   TVAL (1:NT)
         DOUBLE PRECISION   RTS  (1:NTGQP)
         DOUBLE PRECISION   WTS  (1:NTGQP)

         PARAMETER  (R14 = 1.45303521503316D-01)
         PARAMETER  (R24 = 1.33909728812636D+00)
         PARAMETER  (R34 = 3.92696350135829D+00)
         PARAMETER  (R44 = 8.58863568901199D+00)

         PARAMETER  (W24 = 2.34479815323517D-01)
         PARAMETER  (W34 = 1.92704402415764D-02)
         PARAMETER  (W44 = 2.25229076750736D-04)

         PARAMETER  (PI4 = 7.85398163397448D-01)

         PARAMETER  (T4MAX = 54.D0)

         PARAMETER  (HALF    = 0.5D0)
         PARAMETER  (ONE     = 1.D0)
         PARAMETER  (TWO     = 2.D0)
         PARAMETER  (THREE   = 3.D0)
         PARAMETER  (HALFP7  = 7.5D0)
         PARAMETER  (HALFP12 = 12.5D0)
         PARAMETER  (HALFP17 = 17.5D0)

         DATA  JUMP4  /1,2,2,2,2,3,3,3,3,3,
     +                 4,4,4,4,4,5,5,5,5,5,
     +                 6,6,6,6,6,6,6,6,6,6,
     +                 6,6,6,6,6,7,7,7,7,7,
     +                 7,7,7,7,7,7,7,7,7,7,
     +                 7,7,7,8/
C
C
C------------------------------------------------------------------------
C
C
C                 ********************************
C             ... *  # of roots and weights = 4  *
C                 ********************************
C
C
      M = 1

      DO 400 N = 1,NT

         T = TVAL (N)

         IF (T. LE. 3.0D-07) THEN
C
C
C             ...T-range: T essentially 0
C
C
             R1 = 3.48198973061471D-02 - 4.09645850660395D-03 * T
             R2 = 3.81567185080042D-01 - 4.48902570656719D-02 * T
             R3 = 1.73730726945891D+00 - 2.04389090547327D-01 * T
             R4 = 1.18463056481549D+01 - 1.39368301742312D+00 * T

             WTS (M)   = 3.62683783378362D-01 - 3.13844305713928D-02 * T
             WTS (M+1) = 3.13706645877886D-01 - 8.98046242557724D-02 * T
             WTS (M+2) = 2.22381034453372D-01 - 1.29314370958973D-01 * T
             WTS (M+3) = 1.01228536290376D-01 - 8.28299075414321D-02 * T

             RTS (M)   = R1 / (ONE + R1)
             RTS (M+1) = R2 / (ONE + R2)
             RTS (M+2) = R3 / (ONE + R3)
             RTS (M+3) = R4 / (ONE + R4)

             M = M + 4

             GOTO 400
         END IF

         TCASE = INT ( MIN (T+ONE,T4MAX))

         GOTO (4100,4200,4300,4400,4500,4600,4700,4800) JUMP4 (TCASE)
C
C
C             ...T-range: 0 < T < 1
C
C
 4100    WTS (M) = ((((((-1.14649303201279D-08  * T
     +                   +1.88015570196787D-07) * T
     +                   -2.33305875372323D-06) * T
     +                   +2.68880044371597D-05) * T
     +                   -2.94268428977387D-04) * T
     +                   +3.06548909776613D-03) * T
     +                   -3.13844305680096D-02) * T
     +                   +3.62683783378335D-01

         WTS (M+1) = ((((((((-4.11720483772634D-09  * T
     +                       +6.54963481852134D-08) * T
     +                       -7.20045285129626D-07) * T
     +                       +6.93779646721723D-06) * T
     +                       -6.05367572016373D-05) * T
     +                       +4.74241566251899D-04) * T
     +                       -3.26956188125316D-03) * T
     +                       +1.91883866626681D-02) * T
     +                       -8.98046242565811D-02) * T
     +                       +3.13706645877886D-01

         WTS (M+2) = ((((((((-3.41688436990215D-08  * T
     +                       +5.07238960340773D-07) * T
     +                       -5.01675628408220D-06) * T
     +                       +4.20363420922845D-05) * T
     +                       -3.08040221166823D-04) * T
     +                       +1.94431864731239D-03) * T
     +                       -1.02477820460278D-02) * T
     +                       +4.28670143840073D-02) * T
     +                       -1.29314370962569D-01) * T
     +                       +2.22381034453369D-01

         WTS (M+3) = ((((((((( 4.99660550769508D-09  * T
     +                        -7.94585963310120D-08) * T
     +                        +8.359072409485D-07)   * T
     +                        -7.422369210610D-06)   * T
     +                        +5.763374308160D-05)   * T
     +                        -3.86645606718233D-04) * T
     +                        +2.18417516259781D-03) * T
     +                        -9.99791027771119D-03) * T
     +                        +3.48791097377370D-02) * T
     +                        -8.28299075413889D-02) * T
     +                        +1.01228536290376D-01

         R1      = ((((((-1.95309614628539D-10  * T
     +                   +5.19765728707592D-09) * T
     +                   -1.01756452250573D-07) * T
     +                   +1.72365935872131D-06) * T
     +                   -2.61203523522184D-05) * T
     +                   +3.52921308769880D-04) * T
     +                   -4.09645850658433D-03) * T
     +                   +3.48198973061469D-02

         R2        = (((((-1.89554881382342D-08  * T
     +                    +3.07583114342365D-07) * T
     +                    +1.270981734393D-06)   * T
     +                    -1.417298563884D-04)   * T
     +                    +3.226979163176D-03)   * T
     +                    -4.48902570678178D-02) * T
     +                    +3.81567185080039D-01

         R3        = (((((( 1.77280535300416D-09  * T
     +                     +3.36524958870615D-08) * T
     +                     -2.58341529013893D-07) * T
     +                     -1.13644895662320D-05) * T
     +                     -7.91549618884063D-05) * T
     +                     +1.03825827346828D-02) * T
     +                     -2.04389090525137D-01) * T
     +                     +1.73730726945889D+00

         R4        = (((((-5.61188882415248D-08  * T
     +                    -2.49480733072460D-07) * T
     +                    +3.428685057114D-06)   * T
     +                    +1.679007454539D-04)   * T
     +                    +4.722855585715D-02)   * T
     +                    -1.39368301737828D+00) * T
     +                    +1.18463056481543D+01

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: 1 =< T < 5
C
C
 4200    X = T - THREE

         WTS (M) = ((((((((((-4.65801912689961D-14  * X
     +                       +7.58669507106800D-13) * X
     +                       -1.186387548048D-11)   * X
     +                       +1.862334710665D-10)   * X
     +                       -2.799399389539D-09)   * X
     +                       +4.148972684255D-08)   * X
     +                       -5.933568079600D-07)   * X
     +                       +8.168349266115D-06)   * X
     +                       -1.08989176177409D-04) * X
     +                       +1.41357961729531D-03) * X
     +                       -1.87588361833659D-02) * X
     +                       +2.89898651436026D-01

         WTS (M+1) = ((((((((((((-1.46345073267549D-14  * X
     +                           +2.25644205432182D-13) * X
     +                           -3.116258693847D-12)   * X
     +                           +4.321908756610D-11)   * X
     +                           -5.673270062669D-10)   * X
     +                           +7.006295962960D-09)   * X
     +                           -8.120186517000D-08)   * X
     +                           +8.775294645770D-07)   * X
     +                           -8.77829235749024D-06) * X
     +                           +8.04372147732379D-05) * X
     +                           -6.64149238804153D-04) * X
     +                           +4.81181506827225D-03) * X
     +                           -2.88982669486183D-02) * X
     +                           +1.56247249979288D-01

         WTS (M+2) = ((((((((((((( 9.06812118895365D-15  * X
     +                            -1.40541322766087D-13) * X
     +                            +1.919270015269D-12)   * X
     +                            -2.605135739010D-11)   * X
     +                            +3.299685839012D-10)   * X
     +                            -3.86354139348735D-09) * X
     +                            +4.16265847927498D-08) * X
     +                            -4.09462835471470D-07) * X
     +                            +3.64018881086111D-06) * X
     +                            -2.88665153269386D-05) * X
     +                            +2.00515819789028D-04) * X
     +                            -1.18791896897934D-03) * X
     +                            +5.75223633388589D-03) * X
     +                            -2.09400418772687D-02) * X
     +                            +4.85368861938873D-02

         WTS (M+3) = ((((((((((((((-9.74835552342257D-16  * X
     +                             +1.57857099317175D-14) * X
     +                             -2.249993780112D-13)   * X
     +                             +3.173422008953D-12)   * X
     +                             -4.161159459680D-11)   * X
     +                             +5.021343560166D-10)   * X
     +                             -5.545047534808D-09)   * X
     +                             +5.554146993491D-08)   * X
     +                             -4.99048696190133D-07) * X
     +                             +3.96650392371311D-06) * X
     +                             -2.73816413291214D-05) * X
     +                             +1.60106988333186D-04) * X
     +                             -7.64560567879592D-04) * X
     +                             +2.81330044426892D-03) * X
     +                             -7.16227030134947D-03) * X
     +                             +9.66077262223353D-03

         R1      = (((((((((-1.48570633747284D-15  * X
     +                      -1.33273068108777D-13) * X
     +                      +4.068543696670D-12)   * X
     +                      -9.163164161821D-11)   * X
     +                      +2.046819017845D-09)   * X
     +                      -4.03076426299031D-08) * X
     +                      +7.29407420660149D-07) * X
     +                      -1.23118059980833D-05) * X
     +                      +1.88796581246938D-04) * X
     +                      -2.53262912046853D-03) * X
     +                      +2.51198234505021D-02

         R2        = ((((((((( 1.35830583483312D-13  * X
     +                        -2.29772605964836D-12) * X
     +                        -3.821500128045D-12)   * X
     +                        +6.844424214735D-10)   * X
     +                        -1.048063352259D-08)   * X
     +                        +1.50083186233363D-08) * X
     +                        +3.48848942324454D-06) * X
     +                        -1.08694174399193D-04) * X
     +                        +2.08048885251999D-03) * X
     +                        -2.91205805373793D-02) * X
     +                        +2.72276489515713D-01

         R3        = ((((((((( 5.02799392850289D-13  * X
     +                        +1.07461812944084D-11) * X
     +                        -1.482277886411D-10)   * X
     +                        -2.153585661215D-09)   * X
     +                        +3.654087802817D-08)   * X
     +                        +5.15929575830120D-07) * X
     +                        -9.52388379435709D-06) * X
     +                        -2.16552440036426D-04) * X
     +                        +9.03551469568320D-03) * X
     +                        -1.45505469175613D-01) * X
     +                        +1.21449092319186D+00

         R4        = (((((((((-1.08510370291979D-12  * X
     +                        +6.41492397277798D-11) * X
     +                        +7.542387436125D-10)   * X
     +                        -2.213111836647D-09)   * X
     +                        -1.448228963549D-07)   * X
     +                        -1.95670833237101D-06) * X
     +                        -1.07481314670844D-05) * X
     +                        +1.49335941252765D-04) * X
     +                        +4.87791531990593D-02) * X
     +                        -1.10559909038653D+00) * X
     +                        +8.09502028611780D+00

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: 5 =< T < 10
C
C
 4300    X = T - HALFP7

         WTS (M) = ((((((((((-1.65995045235997D-15  * X
     +                       +6.91838935879598D-14) * X
     +                       -9.131223418888D-13)   * X
     +                       +1.403341829454D-11)   * X
     +                       -3.672235069444D-10)   * X
     +                       +6.366962546990D-09)   * X
     +                       -1.039220021671D-07)   * X
     +                       +1.959098751715D-06)   * X
     +                       -3.33474893152939D-05) * X
     +                       +5.72164211151013D-04) * X
     +                       -1.05583210553392D-02) * X
     +                       +2.26696066029591D-01

         WTS (M+1) = ((((((((((((-3.57248951192047D-16  * X
     +                           +6.25708409149331D-15) * X
     +                           -9.657033089714D-14)   * X
     +                           +1.507864898748D-12)   * X
     +                           -2.332522256110D-11)   * X
     +                           +3.428545616603D-10)   * X
     +                           -4.698730937661D-09)   * X
     +                           +6.219977635130D-08)   * X
     +                           -7.83008889613661D-07) * X
     +                           +9.08621687041567D-06) * X
     +                           -9.86368311253873D-05) * X
     +                           +9.69632496710088D-04) * X
     +                           -8.14594214284187D-03) * X
     +                           +8.50218447733457D-02

         WTS (M+2) = ((((((((((((( 1.64742458534277D-16  * X
     +                            -2.68512265928410D-15) * X
     +                            +3.788890667676D-14)   * X
     +                            -5.508918529823D-13)   * X
     +                            +7.555896810069D-12)   * X
     +                            -9.69039768312637D-11) * X
     +                            +1.16034263529672D-09) * X
     +                            -1.28771698573873D-08) * X
     +                            +1.31949431805798D-07) * X
     +                            -1.23673915616005D-06) * X
     +                            +1.04189803544936D-05) * X
     +                            -7.79566003744742D-05) * X
     +                            +5.03162624754434D-04) * X
     +                            -2.55138844587555D-03) * X
     +                            +1.13250730954014D-02

         WTS (M+3) = ((((((((((((((-1.55714130075679D-17  * X
     +                             +2.57193722698891D-16) * X
     +                             -3.626606654097D-15)   * X
     +                             +5.234734676175D-14)   * X
     +                             -7.067105402134D-13)   * X
     +                             +8.793512664890D-12)   * X
     +                             -1.006088923498D-10)   * X
     +                             +1.050565098393D-09)   * X
     +                             -9.91517881772662D-09) * X
     +                             +8.35835975882941D-08) * X
     +                             -6.19785782240693D-07) * X
     +                             +3.95841149373135D-06) * X
     +                             -2.11366761402403D-05) * X
     +                             +9.00474771229507D-05) * X
     +                             -2.78777909813289D-04) * X
     +                             +5.26543779837487D-04

         R1      = ((((((((( 4.64217329776215D-15  * X
     +                      -6.27892383644164D-15) * X
     +                      +3.462236347446D-13)   * X
     +                      -2.927229355350D-11)   * X
     +                      +5.090355371676D-10)   * X
     +                      -9.97272656345253D-09) * X
     +                      +2.37835295639281D-07) * X
     +                      -4.60301761310921D-06) * X
     +                      +8.42824204233222D-05) * X
     +                      -1.37983082233081D-03) * X
     +                      +1.66630865869375D-02

         R2        = ((((((((( 2.93981127919047D-14  * X
     +                        +8.47635639065744D-13) * X
     +                        -1.446314544774D-11)   * X
     +                        -6.149155555753D-12)   * X
     +                        +8.484275604612D-10)   * X
     +                        -6.10898827887652D-08) * X
     +                        +2.39156093611106D-06) * X
     +                        -5.35837089462592D-05) * X
     +                        +1.00967602595557D-03) * X
     +                        -1.57769317127372D-02) * X
     +                        +1.74853819464285D-01

         R3        = (((((((((( 2.93523563363000D-14  * X
     +                         -6.40041776667020D-14) * X
     +                         -2.695740446312D-12)   * X
     +                         +1.027082960169D-10)   * X
     +                         -5.822038656780D-10)   * X
     +                         -3.159991002539D-08)   * X
     +                         +4.327249251331D-07)   * X
     +                         +4.856768455119D-06)   * X
     +                         -2.54617989427762D-04) * X
     +                         +5.54843378106589D-03) * X
     +                         -7.95013029486684D-02) * X
     +                         +7.20206142703162D-01

         R4        = (((((((((((-1.62212382394553D-14  * X
     +                          +7.68943641360593D-13) * X
     +                          +5.764015756615D-12)   * X
     +                          -1.380635298784D-10)   * X
     +                          -1.476849808675D-09)   * X
     +                          +1.84347052385605D-08) * X
     +                          +3.34382940759405D-07) * X
     +                          -1.39428366421645D-06) * X
     +                          -7.50249313713996D-05) * X
     +                          -6.26495899187507D-04) * X
     +                          +4.69716410901162D-02) * X
     +                          -6.66871297428209D-01) * X
     +                          +4.11207530217806D+00

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: 10 =< T < 15
C
C
 4400    E = DEXP (-T)
         X = ONE / T
         Y = T - HALFP12

         W1 = (((-1.8784686463512D-01  * X
     +           +2.2991849164985D-01) * X
     +           -4.9893752514047D-01) * X
     +           -2.1916512131607D-05) * E + DSQRT (PI4*X)

         W2 = ((((((((((-6.22272689880615D-15  * Y
     +                  +1.04126809657554D-13) * Y
     +                  -6.842418230913D-13)   * Y
     +                  +1.576841731919D-11)   * Y
     +                  -4.203948834175D-10)   * Y
     +                  +6.287255934781D-09)   * Y
     +                  -8.307159819228D-08)   * Y
     +                  +1.356478091922D-06)   * Y
     +                  -2.08065576105639D-05) * Y
     +                  +2.52396730332340D-04) * Y
     +                  -2.94484050194539D-03) * Y
     +                  +6.01396183129168D-02

         W3 = ((((((((((((-4.19569145459480D-17  * Y
     +                    +5.94344180261644D-16) * Y
     +                    -1.148797566469D-14)   * Y
     +                    +1.881303962576D-13)   * Y
     +                    -2.413554618391D-12)   * Y
     +                    +3.372127423047D-11)   * Y
     +                    -4.933988617784D-10)   * Y
     +                    +6.116545396281D-09)   * Y
     +                    -6.69965691739299D-08) * Y
     +                    +7.52380085447161D-07) * Y
     +                    -8.08708393262321D-06) * Y
     +                    +6.88603417296672D-05) * Y
     +                    -4.67067112993427D-04) * Y
     +                    +5.42313365864597D-03

         W4 = ((((((((((((( 2.90401781000996D-18  * Y
     +                     -4.63389683098251D-17) * Y
     +                     +6.274018198326D-16)   * Y
     +                     -8.936002188168D-15)   * Y
     +                     +1.194719074934D-13)   * Y
     +                     -1.45501321259466D-12) * Y
     +                     +1.64090830181013D-11) * Y
     +                     -1.71987745310181D-10) * Y
     +                     +1.63738403295718D-09) * Y
     +                     -1.39237504892842D-08) * Y
     +                     +1.06527318142151D-07) * Y
     +                     -7.27634957230524D-07) * Y
     +                     +4.12159381310339D-06) * Y
     +                     -1.74648169719173D-05) * Y
     +                     +8.50290130067818D-05

         WTS (M)   = W1 - W2 - W3 - W4
         WTS (M+1) = W2
         WTS (M+2) = W3
         WTS (M+3) = W4

         R1      = ((((((((((( 4.94869622744119D-17  * Y
     +                        +8.03568805739160D-16) * Y
     +                        -5.599125915431D-15)   * Y
     +                        -1.378685560217D-13)   * Y
     +                        +7.006511663249D-13)   * Y
     +                        +1.30391406991118D-11) * Y
     +                        +8.06987313467541D-11) * Y
     +                        -5.20644072732933D-09) * Y
     +                        +7.72794187755457D-08) * Y
     +                        -1.61512612564194D-06) * Y
     +                        +4.15083811185831D-05) * Y
     +                        -7.87855975560199D-04) * Y
     +                        +1.14189319050009D-02

         R2        = ((((((((((( 4.89224285522336D-16  * Y
     +                          +1.06390248099712D-14) * Y
     +                          -5.446260182933D-14)   * Y
     +                          -1.613630106295D-12)   * Y
     +                          +3.910179118937D-12)   * Y
     +                          +1.90712434258806D-10) * Y
     +                          +8.78470199094761D-10) * Y
     +                          -5.97332993206797D-08) * Y
     +                          +9.25750831481589D-07) * Y
     +                          -2.02362185197088D-05) * Y
     +                          +4.92341968336776D-04) * Y
     +                          -8.68438439874703D-03) * Y
     +                          +1.15825965127958D-01

         R3        = (((((((((( 6.12419396208408D-14  * Y
     +                         +1.12328861406073D-13) * Y
     +                         -9.051094103059D-12)   * Y
     +                         -4.781797525341D-11)   * Y
     +                         +1.660828868694D-09)   * Y
     +                         +4.499058798868D-10)   * Y
     +                         -2.519549641933D-07)   * Y
     +                         +4.977444040180D-06)   * Y
     +                         -1.25858350034589D-04) * Y
     +                         +2.70279176970044D-03) * Y
     +                         -3.99327850801083D-02) * Y
     +                         +4.33467200855434D-01

         R4        = ((((((((((( 4.63414725924048D-14  * Y
     +                          -4.72757262693062D-14) * Y
     +                          -1.001926833832D-11)   * Y
     +                          +6.074107718414D-11)   * Y
     +                          +1.576976911942D-09)   * Y
     +                          -2.01186401974027D-08) * Y
     +                          -1.84530195217118D-07) * Y
     +                          +5.02333087806827D-06) * Y
     +                          +9.66961790843006D-06) * Y
     +                          -1.58522208889528D-03) * Y
     +                          +2.80539673938339D-02) * Y
     +                          -2.78953904330072D-01) * Y
     +                          +1.82835655238235D+00

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: 15 =< T < 20
C
C
 4500    E = DEXP (-T)
         X = ONE / T
         Y = T - HALFP17

         W1 = (( 1.9623264149430D-01  * X
     +          -4.9695241464490D-01) * X
     +          -6.0156581186481D-05) * E + DSQRT (PI4*X)

         W2 = (((((((((((-1.86506057729700D-16  * Y
     +                   +1.16661114435809D-15) * Y
     +                   +2.563712856363D-14)   * Y
     +                   -4.498350984631D-13)   * Y
     +                   +1.765194089338D-12)   * Y
     +                   +9.04483676345625D-12) * Y
     +                   +4.98930345609785D-10) * Y
     +                   -2.11964170928181D-08) * Y
     +                   +3.98295476005614D-07) * Y
     +                   -5.49390160829409D-06) * Y
     +                   +7.74065155353262D-05) * Y
     +                   -1.48201933009105D-03) * Y
     +                   +4.97836392625268D-02

         W3 = (((((((((((-5.54451040921657D-17  * Y
     +                   +2.68748367250999D-16) * Y
     +                   +1.349020069254D-14)   * Y
     +                   -2.507452792892D-13)   * Y
     +                   +1.944339743818D-12)   * Y
     +                   -1.29816917658823D-11) * Y
     +                   +3.49977768819641D-10) * Y
     +                   -8.67270669346398D-09) * Y
     +                   +1.31381116840118D-07) * Y
     +                   -1.36790720600822D-06) * Y
     +                   +1.19210697673160D-05) * Y
     +                   -1.42181943986587D-04) * Y
     +                   +4.12615396191829D-03

         W4 = ((((((((((((-7.56882223582704D-19  * Y
     +                    +7.53541779268175D-18) * Y
     +                    -1.157318032236D-16)   * Y
     +                    +2.411195002314D-15)   * Y
     +                    -3.601794386996D-14)   * Y
     +                    +4.082150659615D-13)   * Y
     +                    -4.289542980767D-12)   * Y
     +                    +5.086829642731D-11)   * Y
     +                    -6.35435561050807D-10) * Y
     +                    +6.82309323251123D-09) * Y
     +                    -5.63374555753167D-08) * Y
     +                    +3.57005361100431D-07) * Y
     +                    -2.40050045173721D-06) * Y
     +                    +4.94171300536397D-05

         WTS (M)   = W1 - W2 - W3 - W4
         WTS (M+1) = W2
         WTS (M+2) = W3
         WTS (M+3) = W4

         R1      = ((((((((((( 4.36701759531398D-17  * Y
     +                        -1.12860600219889D-16) * Y
     +                        -6.149849164164D-15)   * Y
     +                        +5.820231579541D-14)   * Y
     +                        +4.396602872143D-13)   * Y
     +                        -1.24330365320172D-11) * Y
     +                        +6.71083474044549D-11) * Y
     +                        +2.43865205376067D-10) * Y
     +                        +1.67559587099969D-08) * Y
     +                        -9.32738632357572D-07) * Y
     +                        +2.39030487004977D-05) * Y
     +                        -4.68648206591515D-04) * Y
     +                        +8.34977776583956D-03

         R2        = ((((((((((( 4.98913142288158D-16  * Y
     +                          -2.60732537093612D-16) * Y
     +                          -7.775156445127D-14)   * Y
     +                          +5.766105220086D-13)   * Y
     +                          +6.432696729600D-12)   * Y
     +                          -1.39571683725792D-10) * Y
     +                          +5.95451479522191D-10) * Y
     +                          +2.42471442836205D-09) * Y
     +                          +2.47485710143120D-07) * Y
     +                          -1.14710398652091D-05) * Y
     +                          +2.71252453754519D-04) * Y
     +                          -4.96812745851408D-03) * Y
     +                          +8.26020602026780D-02

         R3        = ((((((((((( 1.91498302509009D-15  * Y
     +                          +1.48840394311115D-14) * Y
     +                          -4.316925145767D-13)   * Y
     +                          +1.186495793471D-12)   * Y
     +                          +4.615806713055D-11)   * Y
     +                          -5.54336148667141D-10) * Y
     +                          +3.48789978951367D-10) * Y
     +                          -2.79188977451042D-09) * Y
     +                          +2.09563208958551D-06) * Y
     +                          -6.76512715080324D-05) * Y
     +                          +1.32129867629062D-03) * Y
     +                          -2.05062147771513D-02) * Y
     +                          +2.88068671894324D-01

         R4        = (((((((((((-5.43697691672942D-15  * Y
     +                          -1.12483395714468D-13) * Y
     +                          +2.826607936174D-12)   * Y
     +                          -1.266734493280D-11)   * Y
     +                          -4.258722866437D-10)   * Y
     +                          +9.45486578503261D-09) * Y
     +                          -5.86635622821309D-08) * Y
     +                          -1.28835028104639D-06) * Y
     +                          +4.41413815691885D-05) * Y
     +                          -7.61738385590776D-04) * Y
     +                          +9.66090902985550D-03) * Y
     +                          -1.01410568057649D-01) * Y
     +                          +9.54714798156712D-01

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: 20 =< T < 35
C
C
 4600    E = DEXP (-T)
         X = ONE / T

         W1 = (( 1.9623264149430D-01  * X
     +          -4.9695241464490D-01) * X
     +          -6.0156581186481D-05) * E + DSQRT (PI4*X)

         W2 = (((((( 7.29841848989391D-04  * T
     +              -3.53899555749875D-02) * T
     +              +2.07797425718513D+00) * T
     +              -1.00464709786287D+02) * T
     +              +3.15206108877819D+03) * T
     +              -6.27054715090012D+04) * T
     +              + (+1.54721246264919D+07  * X
     +                 -5.26074391316381D+06) * X
     +              +7.67135400969617D+05) * E + W24 * W1

         W3 = (((((( 2.36392855180768D-04  * T
     +              -9.16785337967013D-03) * T
     +              +4.62186525041313D-01) * T
     +              -1.96943786006540D+01) * T
     +              +4.99169195295559D+02) * T
     +              -6.21419845845090D+03) * T
     +              + ((+5.21445053212414D+07  * X
     +                  -1.34113464389309D+07) * X
     +                  +1.13673298305631D+06) * X
     +              -2.81501182042707D+03) * E + W34 * W1

         IF (T .LE. 25.0D+00) THEN
             W4 = ((((((( 2.33766206773151D-07  * T
     +                   -3.81542906607063D-05) * T
     +                   +3.51416601267000D-03) * T
     +                   -1.66538571864728D-01) * T
     +                   +4.80006136831847D+00) * T
     +                   -8.73165934223603D+01) * T
     +                   +9.77683627474638D+02) * T
     +                   +1.66000945117640D+04  * X
     +                   -6.14479071209961D+03) * E + W44 * W1
         ELSE
             W4 = (((((( 5.74245945342286D-06  * T
     +                  -7.58735928102351D-05) * T
     +                  +2.35072857922892D-04) * T
     +                  -3.78812134013125D-03) * T
     +                  +3.09871652785805D-01) * T
     +                  -7.11108633061306D+00) * T
     +                  +5.55297573149528D+01) * E + W44 * W1
         END IF

         WTS (M)   = W1 - W2 - W3 - W4
         WTS (M+1) = W2
         WTS (M+2) = W3
         WTS (M+3) = W4

         R1      = ((((((-4.45711399441838D-05  * T
     +                   +1.27267770241379D-03) * T
     +                   -2.36954961381262D-01) * T
     +                   +1.54330657903756D+01) * T
     +                   -5.22799159267808D+02) * T
     +                   +1.05951216669313D+04) * T
     +                   + (-2.51177235556236D+06  * X
     +                      +8.72975373557709D+05) * X
     +                   -1.29194382386499D+05) * E + R14/(T-R14)

         R2        = (((((-7.85617372254488D-02  * T
     +                    +6.35653573484868D+00) * T
     +                    -3.38296938763990D+02) * T
     +                    +1.25120495802096D+04) * T
     +                    -3.16847570511637D+05) * T
     +                    + ((-1.02427466127427D+09  * X
     +                        +3.70104713293016D+08) * X
     +                        -5.87119005093822D+07) * X
     +                    +5.38614211391604D+06) * E + R24/(T-R24)

         R3        = (((((-2.37900485051067D-01  * T
     +                    +1.84122184400896D+01) * T
     +                    -1.00200731304146D+03) * T
     +                    +3.75151841595736D+04) * T
     +                    -9.50626663390130D+05) * T
     +                    + ((-2.88139014651985D+09  * X
     +                        +1.06625915044526D+09) * X
     +                        -1.72465289687396D+08) * X
     +                    +1.60419390230055D+07) * E + R34/(T-R34)

         R4        = ((((((-6.00691586407385D-04  * T
     +                     -3.64479545338439D-01) * T
     +                     +1.57496131755179D+01) * T
     +                     -6.54944248734901D+02) * T
     +                     +1.70830039597097D+04) * T
     +                     -2.90517939780207D+05) * T
     +                     + (+3.49059698304732D+07  * X
     +                        -1.64944522586065D+07) * X
     +                     +2.96817940164703D+06) * E + R44/(T-R44)

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: 35 =< T < 53
C
C
 4700    X = T * T
         E = DEXP (-T) * X * X

         W1 = DSQRT (PI4/T)

         W2 = (( 6.16374517326469D-04  * T
     +          -1.26711744680092D-02) * T
     +          +8.14504890732155D-02) * E + W24 * W1

         W3 = (( 2.08294969857230D-04  * T
     +          -3.77489954837361D-03) * T
     +          +2.09857151617436D-02) * E + W34 * W1

         W4 = (( 5.76631982000990D-06  * T
     +          -7.89187283804890D-05) * T
     +          +3.28297971853126D-04) * E + W44 * W1

         WTS (M)   = W1 - W2 - W3 - W4
         WTS (M+1) = W2
         WTS (M+2) = W3
         WTS (M+3) = W4

         R1      = ((-4.07557525914600D-05  * T
     +               -6.88846864931685D-04) * T
     +               +1.74725309199384D-02) * E + R14 / (T - R14)

         R2        = ((-3.62569791162153D-04  * T
     +                 -9.09231717268466D-03) * T
     +                 +1.84336760556262D-01) * E + R24 / (T - R24)

         R3        = ((-9.65842534508637D-04  * T
     +                 -4.49822013469279D-02) * T
     +                 +6.08784033347757D-01) * E + R34 / (T - R34)

         R4        = ((-2.19135070169653D-03  * T
     +                 -1.19108256987623D-01) * T
     +                 -7.50238795695573D-01) * E + R44 / (T - R44)

         RTS (M)   = R1 / (ONE + R1)
         RTS (M+1) = R2 / (ONE + R2)
         RTS (M+2) = R3 / (ONE + R3)
         RTS (M+3) = R4 / (ONE + R4)

         M = M + 4

         GOTO 400
C
C
C             ...T-range: T >= 53
C
C
 4800    W1 = DSQRT (PI4/T)

         W2 = W24 * W1
         W3 = W34 * W1
         W4 = W44 * W1

C         R1 = R14 / (T - R14)
C         R2 = R24 / (T - R24)
C         R3 = R34 / (T - R34)
C         R3 = R44 / (T - R44)
C         RTS (M)   = R1 / (ONE + R1)
C         RTS (M+1) = R2 / (ONE + R2)
C         RTS (M+2) = R3 / (ONE + R3)
C         RTS (M+3) = R4 / (ONE + R4)

         WTS (M)   = W1 - W2 - W3 - W4
         WTS (M+1) = W2
         WTS (M+2) = W3
         WTS (M+3) = W4

         RTS (M)   = R14 / T
         RTS (M+1) = R24 / T
         RTS (M+2) = R34 / T
         RTS (M+3) = R44 / T

         M = M + 4

  400 CONTINUE
C
C
C             ...ready!
C
C
      RETURN
      END
