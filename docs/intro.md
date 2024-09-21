---
title: Test
author: FSF.hu Alapítvány
date: 2024-01-07
geometry: margin=1in
indent: true
fontfamily: libertinus
mainfont: Libertinus Serif
monofont: inconsolata
fontsize: 11pt
toc: true
toc-title: Tartalomjegyzék
numbersections: true
secnumdepth: 3
colorlinks: true
urlcolor: fsfred
urlstyle: tt
pdfusetitle: true
lang: hu-HU
include-before:
- '`\newpage{}`{=latex}'
header-includes: |
    \usepackage{indentfirst}
    \frenchspacing

    \renewcommand{\thesection}{\arabic{section}.}
    \renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}.}
    \renewcommand{\thesubsubsection}{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}.}
    \renewcommand{\theparagraph}{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}.\arabic{paragraph}.}
    \usepackage{titlesec}
    \titlelabel{\thetitle\:}

    \usepackage{fancyhdr}
    \pagestyle{fancy}
    \fancyhead[C]{}
    \renewcommand{\sectionmark}[1]{\markright{\arabic{section}.\ #1}}
    \renewcommand{\subsectionmark}[1]{}
    \fancyhead[LE,RO]{\rightmark}
    \fancyhead[LO,RE]{Fordítás HOGYAN}
    \fancyfoot[LCR]{}

    \usepackage{xcolor}
    \definecolor{fsfred}{HTML}{900100}
...
\newpage 

# Bevezetés

Napjainkban számtalan szoftver és mellékelt dokumentum, használati útmutató érhető el angolul. A legtöbb projekt lehetőséget biztosít a felhasználói felületek, súgók és dokumentációk honosítására, így magyar változat is készíthető. Ezeket a fordításokat általában erre a célra kialakított webes fordítói felületen, vagy a nyelvi fájlokat letöltve – egy célprogramban – készítjük el. Ezek az eszközök segítenek az egységes és jó minőségű fordítások gyorsabb elkészítésében.

A legfontosabb szempontok fordításkor:

 - hibátlan nyelvtan
 - érthető, tömör és pontos fogalmazás
 - egységes fordítás
 - magyar kifejezések használata (amennyiben már van ilyen kifejezés)
 - fordítás az adott projekt már meglévő elvei szerint
 - a felhasználó megfelelő megszólítása
 - változók helyes használata
 - az alkalmas eszközök kiválasztása és használata

A fordítónak törekednie kell a fenti célok magvalósítására. Ezen munka segítésére, a minőség javítását és az egységesítést szem előtt tartva készítettük ezt az útmutatót, amely összegyűjti az alapvető fordítói ismereteket, másrészt igyekszik írásba foglalni azokat az íratlan szabályokat, melyek bár korántsem érvényesek minden fordítási munkára, az egységesség iránti igény miatt itt mégsem nélkülözhetők.

## Jelölések ebben a dokumentumban

 - A helyes szavakat, mondatokat **félkövér betűtípussal** szedjük ebben a dokumentumban.
 - <u>Aláhúzást</u> kapnak azok az alakok, melyek nem hibásak ugyan, de használatukat nem javasoljuk.
 - Sajnos elkerülhetetlen, hogy hibás alakokat is közöljünk helyenként. ~~Ezeket áthúzva írjuk~~.

## Ha valaki nem tud valamit…

Senki sem tudhat mindent. Nem csak azért, mert az emberi memória véges; azért sem, mert fordításainknál mind a terminológia, mind az alapelvek időről időre változnak. Minden fordítót arra szeretnénk kérni, hogy – legalábbis a fordítás idejére – néha bizonytalanodjon el akár a helyesírást, akár a kifejezéseket, akár az íratlan szabályokat illetően.

Mi a teendő, ha ez sikerült? A helyesírási kételyeket eloszlatja a tanácsadó szótár, a terminológiai gondokat többnyire megoldja a szószedet, a szabályok jórészt megtalálhatók ebben az útmutatóban. A többi fordító is készséggel segít, a Matrix csatornáinkon és a levelezőlistánkon bármikor segítséget lehet kérni:

 - Matrix-csatorna hivatkozása: <https://riot.grin.hu/#/room/#openscope:grin.hu>
 - Levelezőlista címe: <openscope@fsf.hu>
