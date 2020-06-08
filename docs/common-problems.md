# Gyakori hibák

## Hamis barátok

Ebben a részben olyan gyakori hibákat soroltunk fel, amelyeket a legtöbb kezdő fordító elkövet, ezekből álljon itt egy kis gyűjtemény. 

|angol|magyar|
|-|-|
|virtually|~~virtuálisan~~ helyett **_gyakorlatilag_**|
|specific|~~speciális~~ helyett **_különleges_**, **_jellemző_** |
|powerful|~~erőteljes~~ helyett **_hatékony_**|
|technically|~~technikailag~~ helyett **_szigorúan véve_**|
|tricky|~~trükkös~~ helyett **_nehéz_**, **_problémás_**|

## „A %s-hez…”

A _%s_ és úgy általában, minden változó névelője **_a(z)_**. Két-vagy háromalakú toldalékot pedig nem kap, ugyanezért: mert akármi állhat helyette, nem tudhatjuk, melyik kell. Az egyalakú toldalékok (-ig, -kor, stb.) elfogadhatók. A ragozás megkerülésére használt módszerek:

 - ha tudjuk, hogy micsoda a %s (fájl, könyvtár): „a(z) %s \[ fájlhoz | könyvtárhoz \]”
 - ha nem tudjuk, vagy több dolog is lehet: „a következőhöz: %s”
 - ha kis helyre kell beszorítani, vagy egy beviteli mező előtt áll egy „to:” (vagy hasonló): „ehhez:”

## „<programneve> is a…”

Az angol eredetiben gyakran láthatók ehhez hasonló szerkezetek, például névjegy panelen vagy állapotjelzésként, mert az angol nem használ névelőt a tulajdonnevek előtt. Viszont magyarul tegyünk elé névelőt, például: „A Gaim egy többfunkciós csevegőkliens”.

## „Mondatközi Nagybetűk”

Általános hiba, hogy ha egy mondaton belül több szó is nagybetűvel kezdődik, azt a magyarban is nagybetűvel kezdik. Ez helytelen.

## Gyorsbillenty\_ű ékezet előtt

Lehetőleg ne használjuk. Nem feltételezhetjük ugyanis, hogy mindenki, aki magyarul akarja a grafikus felületű alkalmazásokat használni, rendelkezik magyar billentyűzettel vagy magyar kiosztást használ.

## Gyorsbillentyűk ütközése

Ha egy menün/ablakon belül több menüpont/vezérlőelem is ugyanazzal a gyorsbillentyűvel rendelkezik, akkor annak megnyomása sorrendben aktiválja a vezérlőelemeket, amelyeket a szóközzel/enterrel lehet ténylegesen kiválasztani. Ez megnehezíti a program használatát, így kerülendő. Elkerülésére több, együttesen használandó módszer kínálkozik:

 - A fordítási fájlban egymást követő karakterláncok figyelése. Ezek jó eséllyel azonos ablakhoz/menühöz tartoznak, így az ezek közötti átfedések megszüntetése javasolt.
 - A magyarban ritkábban előforduló betűk használata, például: c, d, o, p, u, z
 - Végül az elkészült fordítás tesztelése a program verziókövetőben lévő verziójával.

## Két szóköz mondatvégi pont után

Ha ilyen van az angol eredetiben, akkor a magyarban nem vesszük át. (Lásd: French spacing)

## Szóköz karakterláncok végén

Az előbbihez hasonló jelenség amikor karakterlánc végén is áll egy szóköz, például:

```python
msgid "Options "
msgstr "Beállítások "
```

Ezt a szóközt általában azért érdemes meghagyni, mert lehet, hogy a programozó sietett és nem állította be [helyesen a térközt](http://library.gnome.org/devel/hig-book/stable/design-text-labels.html.en#layout-label-position), és helyette egy szóközzel javított a felület megjelenésén. Praktikus hibaként bejelenteni és kérni az eredetiből a szóköz eltávolítását, akár hivatkozva az imént hivatkozott GNOME HIG-re (ha az adott projektnél ezt figyelembe veszik).

## Két karakterláncból álló mondatok

Néha előfordul, hogy egy mondat két külön `msgid`-ben van leírva, a kettő között pedig általában valamilyen felületi elem például léptetőgomb áll. Ezt arról lehet felismerni, hogy egymás után két fél-mondat áll, amik „mintha” összetartoznának, és a megjegyzésben az előfordulási helyük csak néhány (&lt;10) sornyira van egymástól. Ilyenkor nem kell nagyon ragaszkodni külön-külön az eredeti karakterláncok értelméhez, elég, ha a két üzenet együtt adja vissza a teljes mondat értelmét. Például:

```python
msgid "S_witch off after:"
msgstr "Kika_pcsolás:"
 
msgid "minutes"
msgstr "perc után"
```

Ez a programban valahogy így néz ki: Kika\_pcsolás: &lt;10&gt; perc után

Az ilyen karakterláncokat is érdemes hibaként bejelenteni.

## Nem elérhető, nem kikereshető, nem feldolgozható, nem visszaváltható

Gyakran látni ezekhez hasonló helytelen szerkezeteket kezdő fordítók munkáiban. Ezeket **_nem érhető el_**, **_nem kereshető ki_**, **_nem dolgozható fel_** és **_nem váltható vissza_** alakban kell helyesen írni.

## 6:3

A rövidítés azt jelenti, hogy a három vagy több szóból és hat vagy több szótagból (egy szótagú igekötők és toldalékok nélkül) álló szóösszetételeket a fő összetételi határon kötőjellel kapcsoljuk össze, az olvashatóság megkönnyítése érdekében.

A kétszavas összetételeket egybeírjuk. Például: **_menüikon_**, **_szintaxiskiemelés_**, **_sortörés_**. Az eredetiben ezek általában külön állnak, de ez ne tévesszen meg.

## Speciális helyeken lévő üzenetek

Gyakran fordulnak elő olyan üzenetek, amelyek többféleképpen értelmezhetők/fordíthatók, attól függően, hogy hol vannak a programban, például ugyanaz a szöveg lehet egy parancssori kapcsoló, egy program vagy (GNOME esetén) egy GConf-kulcs leírása ugyanúgy, mint egy, a felhasználótól adatokat bekérő ablak címsora, így kezdő fordítók néha az előbbi három esetén is megszólítják a felhasználót, ami adott esetben szükségtelen. Ezeket arról lehet felismerni, hogy a főprogram első &lt;1000 sorában vannak (ez általában a programneve --help segítségével ellenőrizhető), vagy .desktop.in illetve `.schemas.in` fájlokban.

Például, a „Specify a value” üzenet „Érték megadása”-ként fordítandó, ha a fenti három feltétel egyike teljesül, illetve „Adjon meg egy értéket”-ként, ha nem.

## CSUPANAGYBETŰS szavak

Általában ezek a parancssori kapcsolók paramétereit jelölik, például: `--prefix PREFIX`. Parancssori kapcsolók esetén maga a kapcsoló nem fordítandó, a csupa nagybetűs szó viszont igen.

## DConf-kulcsok és -értékek

Ez egy GNOME-specifikus dolog, a DConf konfigurációs adatbázisban gyakran fordul elő, hogy a kulcsok leírásai más kulcsok nevére hivatkoznak, illetve ha a kulcs értékének néhány karakterlánc típusú elem egyikének kell lennie, akkor ezeket leírással együtt felsorolják. Ezek `.schemas.in` fájlokban fordulnak elő, a szabály velük kapcsolatban az, hogy a kulcsneveket és -értékeket nem fordítjuk (a DConf ezt nem támogatja) és a lehetséges értékek mögé zárójelben odatesszük a fordítást, ha van értelme, például: „Az ablak elhelyezkedése. Lehetséges értékek: top (fent), bottom (lent)”. (Nyilván ha n darab kódlapból kell egyet választani, akkor nem.)

## Mondatvégi írásjelek

Általában, ha az eredetiben nincs, akkor a fordításban sincs. Felszólító mondatok után, hacsak nem hangsúlyozott felszólításról/figyelmeztetésről van szó, nincs felkiáltójel. Például: „Válasszon ki egy dokumentumot” (fájlválasztó ablak címsora).

<!-- FIXME
## A szöveg érthetősége mindenek felett

Az alábbi rész a [Fordítás HOGYAN](http://tldp.fsf.hu/Forditas-HOGYAN/Forditas-HOGYAN.html) oldalról származik, mondandóját érdemes megszívlelni:

-   A munka megkezdése előtt nézd át a szógyűjteményt, amely egyes angol szavak magyar megfelelőjét tartalmazza a [MLDP](MLDP "wikilink") szerint.
-   Nézz bele egy-két magyarított HOGYANba, és az egyes részeket hasonlítsd össze azok angol változatával. Így könnyebben ráérzel arra, mit és hogyan kell és/vagy érdemes fordítanod.
-   Ragaszkodj az angol eredeti szöveg értelméhez, mondanivalójához, de ne ragaszkodj annak megfogalmazásához/mondatszerkezetéhez.
-   Angolul teljesen másképp kell gondolkodni, mint magyarul. Előfordulhat, hogy egy angol mondatot két magyar mondatra érdemes fordítani és viszont.
-   A minőségi munka érdekében inkább lassan, de precízen fordíts. Teljesen felesleges összedobni valami ferdítés félét, aztán a lektorra bízni, hadd fordítsa le újra az egészet...
-   Ha valamely szó, kifejezés vagy mondat jelentésében bizonytalan vagy illetve végképp nem boldogulsz, kérdezz rá a levelezőlistán, amelyre a [A Magyar Linux Dokumentációs Projekt](https://lists.sch.bme.hu/wws/info/linuxhowto) honlapon iratkozhatsz fel. A lista ugyanis ezért (is) van.
-   Ha az angol szó vagy kifejezés látszólag nem illik a mondatba, akkor gyanakodj! Valószínűleg többértelmű szóról/kifejezésről van szó. Például a "double check" kifejezést többen, csont nélkül "dupla ellenőrzés"-nek fordították, ez annyira magyartalan, hogy csak na. A "double check" helyesen "alapos ellenőrzés". Ilyen esetben használjátok a fordítási segédleteket, ha végképp nem boldogulsz, akkor a teendőket lásd az előző bekezdésben.
-   A munka végeztével olvasd végig fordításodat a helyesírási hibákat is figyelve/javítva. Ha épeszű magyar emberként megérted amit abban leírtál, valószínűleg jó munkát végeztél. Tartsd észben: a fordításokat a Linux-felhasználók népes tábora olvassa.
-->

