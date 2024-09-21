# Gettext, .pot- és .po-fájlok

## Működési elv

A `gettext` rendszer működési elve igen egyszerű: a fejlesztő megjelöli a lefordítható üzeneteket a forrásban, a `gettext` ezeket összegyűjti egy programneve.pot fájlba, a fordítók ezt lefordítják anyanyelvükre és `.po` kiterjesztéssel mentik, majd a program (gépi kóddá) fordítása során bináris formátumúvá alakul, amit a program már képes használni.

## Átalakítás más formátumokról

A Qt eszközkészletet használó programok fordítási fájlformátuma a `.ts`, ezt a Qt Linguist nevű eszközzel lehet szerkeszteni. Lehetőség van azonban ezt `po` formátumúvá és vissza alakítani, a [translate-toolkit](http://translate.sourceforge.net/) nevű programcsomag `ts2po` és `po2ts` eszközeivel, így ezeket a fájlokat is az alább ismertetett eszközökkel kezelhetjük. Ennek ellenére az átalakítás nem mindig jó ötlet, a két formátum közötti különbségek miatt. (Például: a `.ts` megengedi egy szó, vagy kifejezés többszöri előfordulását a nyelvi fájlban, a `.po` viszont nem.)

## Felépítés

### Általános

A .pot fájlok szerkezete igen egyszerű, üzenet-fordítás párokból és megjegyzés-sorokból áll, valamint az elején tartalmaz egy fejlécet, amely a fájllal és a fordítókkal kapcsolatos információkat tartalmazza.

Az üzenetet az msgid kezdetű sorok tartalmazzák, dupla idézőjelek között. A fordítást az msgstr kezdetű sorokba kell a fordítónak beírnia. A \# kezdetű sorok megjegyzések, ezek tartalmazhatják az üzenet előfordulásának helyét a programban fájl:sor alakban a po könyvárhoz viszonyítva (például \#: ../embed/downloader-view.c:470) a fejlesztő megjegyzését a fordítónak, stb.

### Az üzenetek állapotai

Egy üzenetnek három állapota lehet: lefordítatlan (az msgstr üres), lefordított (az msgstr nem üres) és fuzzy. Fontos tudni, hogy a felhasználó a program használata során csak a lefordított üzeneteket fogja látni, az egyéb állapotú üzenetek eredeti nyelven jelennek meg.

A fuzzy állapotról részletesebben: Technikailag ez úgy néz ki, mint egy lefordított üzenet, azzal a különbséggel, hogy az msgstr sort egy "\#, fuzzy" megjegyzés előzi meg, ennek beírásával illetve törlésével lehet a lefordított üzenetet fuzzy-vá alakítani és vissza. Példa egy fuzzy karakterláncra:

```python
#: ../plugins/typing-break/typing-break.gnome-settings-plugin.in.h:2
#, fuzzy
msgid "Typing break plugin"
msgstr "Gépelési szünet"
```

Ennek szerepe kettős: egyrészt a fordítók így jelezhetik egymásnak, ha az adott fordítást át kell nézni, bizonytalan, ellenőrizni kell. Másrészt a fordítások automatikus frissítése során a gettext megpróbálja újrahasznosítani a meglévő üzeneteket, a lefordított és az új üzenetek közötti hasonlóság alapján. Ha egy új angol karakterlánc eléggé hasonlít egy lefordított eredeti karakterláncra, akkor a gettext bemásolja a meglévő fordítást az új karakterlánchoz és beállítja a fuzzy jelzést. A fenti példa esetén az eredeti karakterlánc az alábbi volt:

```python
#: ../plugins/typing-break/typing-break.gnome-settings-plugin.in.h:1
msgid "Typing Break"
msgstr "Gépelési szünet"
```

Látható, hogy az új karakterlánc három szava közül kettő azonos egy meglévő fordítás eredetijével, így a gettext feltételezi, hogy valószínűleg a fordításuk is hasonló lehet. Az egész értelme, hogy így az új karakterlánc fordítása gyorsabban készülhet el, hiszen csak egy szót ("bővítmény") kell a meglévő rész végére írni. Hosszabb karakterláncok esetén ugyan kevésbé pontosak, mondhatni használhatatlanok a találatok, de ha egy bekezdésnyi karakterláncban csak egy elgépelést javítanak, akkor kifejezetten pontos és hasznos tud lenni :).

Ebből következik, hogy fordításkor a lefordítatlan karakterláncokkal együtt ezeket is ugyanúgy le kell fordítani, amit ez a szolgáltatás néha meggyorsít, de semmiképpen sem helyettesít!

Meg kell még említeni az elavult üzeneteket is, amelyek a negyedik állapotfajtát jelentik. Ezek mindig a fájl legvégén találhatók és valahogy így néznek ki:

```python
#~ msgid "\_Open"
#~ msgstr "\_Megnyitás"
```

Ezek a po fájlok frissítésekor keletkeznek, azok kerülnek ilyen állapotba, amelyek a régi fájlban le voltak fordítva, de az új verzióból kikerültek. Ha a későbbiekben visszakerülnek a forrásba, a gettext újrahasznosítja őket, de csak ennyi a szerepük.

### Többes szám

A gettext képes kezelni a többes számú üzeneteket, az alábbi formában:

```python
msgid "%d download"
msgid_plural "%d downloads"
msgstr[0] "%d letöltés"
msgstr[1] "%d letöltés"
```

Magyarul a 0 indexű fordítás tartalmazza az egyes- és az 1 indexű a többes számú változatot. Általában a két fordítás teljesen ugyanaz, mivel az eredeti legtöbbször tartalmazza az elemek konkrét számát, így nincs sok tennivaló ezzel. A .po fájl fejlécének viszont tartamaznia kell a

```python
"Plural-Forms: nplurals=2; plural=(n != 1);\\n"
```

sort (így, idézőjelben). Ugyanez a fordításhoz használt programból is elvégezhető, a többes számú forma beállításánál így kell megadni:

```python
nplurals=2; plural=(n != 1);
```

### Változók

A lefordítandó szöveg tartalmazhat változókat is, ezek nyelvéről az üzenet előtt egy megjegyzéssor tájékoztat, a többes számnál látott példa esetén \#, c-format.

A változókat a nyelvnek megfelelően kell kezelni, azaz a sorrend szerinti kötést valló nyelvek (pl.: C, C++, Python) esetén a változókat alapesetben változatlan sorrendben (és a darabszám sem változhat) kell leírni, míg a név szerinti kötést vallók esetén (C\#: a változók {0}, {1}, ... alakúak) nyugodtan átrendezhetjük őket.

C és C++ esetén lehetőség van a sorrend megváltoztatására. A változók egy % jelből és egy konverziós karakterből (s, d, f, stb) állnak, ezek közé kell egy számot (amely a sorrendet jelzi) és egy $ karaktert szúrni az átrendezéshez. Például:

 - Egyszerű eset:

```python
msgid "will not create hard link %s to directory %s"
msgstr "a(z) %2$s könyvtárra mutató %1$s hard link nem lesz létrehozva"
```

 - Ha egy változó sorrendje nem változna, akkor is meg kell számozni:

```python
msgid "%s: remove write-protected %s %s? "
msgstr "%1$s: eltávolítja az írásvédett %3$s nevű, „%2$s” típusú elemet? "
```

 - Különböző típusú változók sorrendje külön-külön is szabályozható:

```python
#. TRANSLATOR: "%d %s %d %s" are "%d hours %d minutes"
#. * Swap order with "%2$s %2$d %1$s %1$d if needed
msgid "%d %s %d %s (%d%%) remaining"
msgstr "%d %s %d %s (%d%%) van hátra"
```

Ennek most kevés értelme van, csak a példa kedvéért :)

### Speciális elemek

A fordítás során találkozhatunk speciálisan kezelendő elemekkel is. Ilyenek a gyorsbillentyűk jelei, amely GTK esetén az `_` jel, Qt esetén a `&` jel, amelyek a grafikus felületen gyorsbillentyűként működő karaktert jelölik. Ezekkel kapcsolatban az az ökölszabály, hogy ha az eredetiben van, akkor (és csakis akkor) a fordításban is legyen. Az adott kifejezés jellemző, hangsúlyos hangját vegyük figyelembe, műveleteknél az állítmányból jelöljünk ki gyorsbillentyűt. Továbbá inkább ne tegyünk ékezetes billentyűket gyorsbillentyűvé, mivel nem feltételezhetjük, hogy minden felhasználó rendelkezik magyar billentyűzettel. Ha lehetséges, kerüljük a <u>J</u> és <u>j</u>, illetve <u>I</u> és <u>i</u> gyorsbillentyűvé jelölését. Figyeljünk arra, hogy egy szinten ne legyen azonos gyorsbillentyű, itt az alapértelmezett fordítások (GTK, Qt) előnyt élveznek.

Másik kategória az XML címkék (`<valami>` és `</valami>`), ezeket soha nem fordítjuk le, át kell őket másolni. A köztük lévő szöveget azonban fordítjuk, például: `<application>Text editor</application>` &rarr; `<application>Szövegszerkesztő</application>`. Ezek hatására az adott szöveg a programban vagy dokumentációban más stílussal jelenik meg, például félkövéren, dőlten, kisebb/nagyobb méretben.

Figyelni kell még a karakterlánc végén lévő `\n` jelekre, amelyek sortörést végeznek a szövegben: ha a karakterlánc `\n`-re végződik, a fordításnak is arra kell, különben az `msgfmt` panaszkodni fog.

Ritkábban, de előforduló speciális eset az önálló `%` jel, például `for a literal % sign` esetén. Itt a szöveg magára a `%` jelre vonatkozik, viszont ez a C, C++ nyelvekben változót jelöl, emiatt a fordítás nem lesz menthető. Ilyenkor a `%%` használata megoldja a problémát, de ajánlott jelezni a fejlesztőnek, mert más fordítóknál is gond lesz.

#### A GTK alapértelmezett ikonjai

GNOME-os alkalmazások fordítandó üzenetei között fordulhatnak elő `gtk-\*` jellegűek (pl. `gtk-ok`, `gtk-yes`, `gtk-cancel`). Ezeket fölösleges lefordítani, mivel nem láthatók sehol. Érdemes ezeket is hibaként bejelenteni, ezeknek nem kellene fordíthatónak lenniük.

#### strftime(3) szerinti dátum- és időformátumok

Általánosan elterjedt a dátumok és idők megadása ebben a formátumban, ami gyakorlatilag teljesen C-szerű, `%` jel + egy betű, így a fordítók saját nyelvük helyesírásának megfelelővé alakíthatják a programokban megjelenő dátumokat és időket. Ezek fel nem ismerése és emiatt helytelen fordítása is gyakori, ezért itt a leggyakrabban használt formátumleírókra hívnánk fel a figyelmet. Magyarul csak folyó szövegben szokás a 12 órás időformátum használata, azonban nem minden esetben fordítható az ilyen alak a 24 órásra; különösen igaz ez arra az esetre, amikor a felhasználónak kell választania a 12 vagy 24 órás formátumot.

 - `%H:%M:%S` – óó:pp:mp, magyarul `%k:%M:%S` (például 9:15:13). Ennek oka, hogy a `%H` 00–23-ig, míg a `%k` 0–23-ig ábrázolja az órákat, ez utóbbi felel meg a magyar helyesírásnak.
 - `%I:%M %p` (vagy `%P`) – (vagy kisbetűvel ugyanez), 12 órás formátum. Magyarul `%l:%M %p`, a `%I` és `%l` közti különbség ugyanaz, mint előbb.
 - `%d %b %Y` - nn hh. éééé., (hónapnév rövidítve, `%B` esetén teljes) magyarul `%Y. %b. %e`, az év után pontot teszünk, valamint a rövidített hónapnév után is, (alapértelmezésben az nem tartalmazza a pontot) valamint a `%e` az előzőekhez hasonló ok miatt szükséges (1–31 között értelmezi a napot).

A dátumok tagolására angolul a `/` jel használatos, magyarul inkább szóközökkel, esetleg kötőjelekkel válasszuk el a dátum részeit.

## Fordítási fájlok kezelése

### POT-fájlok előállítása

A `.pot` fájlokat általában a projekt honlapjáról letölthető tarballok tartalmazzák, így ha egy ilyen formában beszerzett programot akarunk fordítani, a `/po` könyvtárban megtaláljuk. Más a helyzet, ha egy CVS-ből származó programunk van, vagy egyszerűen csak meg akarunk győződni, hogy a `.pot` fájl naprakész. A GTK-t használó programok esetén általában ezt a `/po` könyvtárban kiadott `intltool-update --pot` paranccsal állíthatjuk elő.

### PO-fájlok aktualizálása

Gyakoribb eset, hogy egy programnak már van fordítása, ám annak elkészülte óta a program fejlődött, karakterláncek jöttek-mentek, ám a .po-fájl még nem tükrözi ezeket a változásokat. Ez főleg a CVS-ből frissen letöltött forrásoknál fordulhat elő. Ekkor az intltool-t használó programok esetén a /po könyvtárban az intltool-update hu parancsot kell kiadni. Ezután a létező hu.po tartalmazni fogja az időközben keletkezett új üzeneteket. Ez az eset azért is érdekes, mert ilyenkor keletkeznek a fuzzy üzenetek: a gettext megpróbálja megtalálni azon üzeneteket, amelyek nagyon hasonlítanak egy már lefordított üzenetre, tehát valószínűleg a fordításuk is nagyon hasonló lesz. Ha talál egy ilyet, akkor az új, a lefordított régihez hasonló üzenethez beírja a régi fordítását, és megjelöli fuzzy-ként, így próbálja meg a fordítók munkáját segíteni.

A `/po` könyvtárban kiadott `make update-po` parancs a fenti műveletet az összes létező fordításra végrehajtja, ezt a fejlesztők a tarballok kiadása előtt ki szokták adni.

### Eltérő verziók kezelése

Előfordulhat, hogy mire egy `.pot/.po` fájl fordításával elkészülünk, addigra a forrásban új üzenetek jelennek meg, vagy egyszerűen tévedésből csak egy régebbi verziót fordítunk le. Ilyenkor rendelkezünk egy naprakész `.pot/.po` fájllal (`uj.po`) és egy nem naprakész, ám számottevő munkát tartalmazó korábbi verzióval (regi.po). Az üzenetek átvitele a `regi.po` fájlból az `uj.po` fájlba:

```
$ msgmerge -o eredmeny.po regi.po uj.po
```

Ekkor is keletkezhetnek fuzzy fordítások.

### PO-fájlok szintaktikai ellenőrzése

Miután befejeztük egy fájl fordítását, adjuk ki a következő parancsot:

```
$ msgfmt -cvo /dev/null hu.po
```

Hibás fájlt SOHA nem szabad visszaküldeni a fejlesztőknek, mert megakaszthatja a program fordítását.

### Beüzemelés

Ha a szintaktikai ellenőrzés nem talál hibát, akkor kipróbálhatjuk a programot az új fordításunkkal:

```
$ msgfmt -o $PREFIX/share/locale/hu/LC_MESSAGES/$GETTEXT_PACKAGE.mo hu.po
```

A `$GETTEXT\_PACKAGE` az a név, amelyet a program a fordítás azonosítására használ, ezt a forrásból vagy az `intltool-update --pot` kiadása után létrejött .pot fájl nevéből lehet kideríteni.

Általában megegyezik a program nevével, néha azonban tartalmazhat egy verziószámot. A célkönyvtár disztribúció-specifikus, általában az alapértelmezett használatos, egyes terjesztések (pl.: [Ubuntu](Ubuntu "wikilink"): locale helyett `locale-langpack` a nyelvi csomagokkal érkező fordítások esetén) viszont mást (is) használnak.

A `$PREFIX` a csomag fordításakor használt `--prefix` kapcsoló, bináris csomagoknál `/usr`, ha forrásból telepítünk, akkor `/usr/local`, SUSE esetén az `/opt/gnome` és az `/opt/kde3` is használatos. [FIXME](FIXME "wikilink"): egyéb disztribúciók?

Másik lehetőség a fordítás beüzemelésére, hogy `hu.po` néven bemásoljuk a `/po` könyvtárba, és módosítjuk a `configure.in` (esetleg .am) fájlban található ALL\_LINGUAS változót úgy, hogy az értékek közé felvesszük a `hu` jelölést is, majd kiadjuk az `autoconf` parancsot és hagyományos módon telepítjük a programot.

### Helyesírás-ellenőrzés

Az elkészült fordítás helyesírásának ellenőrzéséhez kövessük a [PO-fájlok helyesírás-ellenőrzése](http://forditas.fsf.hu/huspell-po.html) oldal utasításait. Ezt a lépést se hagyjuk ki.

<!-- FIXME: aktuális eszközök bemutatása
## A KBabel használata

Az alábbiakban a KBabel fontosabb beállításait és szolgáltatásait soroljuk fel. Ha egy beállításról itt nem esik szó, úgy az alapértelmezés megfelelő a munka megkezdéséhez.

### Projekt beállításai (Projekt -&gt; Beállítások)

A KBabel első indításakor megnyitja ezt az ablakot.

 - Személyi adatok: A GNU többesszám-kezelő mezőt a Lekérdezés gombbal tölthetjük ki, a többi mezőt értelemszerűen.
 - Mentés: Az automatikus mentést állítsuk be 5 perc körüli értékre, a program stabilitása ugyanis hagy némi kívánnivalót maga után. A leírás legyen a következő: Translation of @PACKAGE@ to Hungarian. A Kódolás UTF-8 legyen, a fájl kódolásának megtartása négyzetet pedig ne válasszuk ki, hacsak nem indokolt nagyon.
 - Helyesírás-ellenőrzés: Az alapértelmezett beállítások megfelelőek (szótár: magyar, kódolás: iso-8859-2, kliens: ispell).
 - Egyebek: Itt megadható a gyorsítóbillentyű, ami a GTK+-t használó programok esetén az \_, Qt esetén a & jel. A KBabel képes ellenőrizni ezek meglétét, ezért ezt a fordítani kívánt programnak megfelelően állítsuk be. A többi beállítás nem létfontosságú, ezekkel most nem foglalkozunk.

## Beállítások (Eszközök -&gt; A KBabel beállítása)

A program általános működésével kapcsolatos beállítások végezhetők itt el.

### Szerkesztés

Az Általános fülön kapcsoljuk be az alábbi ellenőrzéseket:

 - A címkék ellenőrzése: ez ellenőrzi a lefordított szövegben található HTML-címkék mennyiségét, illetve a kezdő-záró párokat.
 - A gyorsbillentyűk ellenőrzése: ellenőrzi, hogy a gyorsbillentyű szerepel-e a lefordított szövegben.
 - Az argumentumok ellenőrzése: az argumentumok meglétét és sorrendjét ellenőrzi.

Ha a fenti ellenőrzések valamelyike hibát észlel, akkor a program a lefordított szöveget a szín megváltoztatásával hibásnak jelzi. Erősen javasolt az ilyen hibák megszüntetésére törekedni.

### Keresés

Ajánlott az automatikus keresést a kiegészítő vagy az összefoglaló fájlra beállítani. A fordítási adatbázis használata stabilitási problémák miatt ellenjavallt.

### Betűtípusok

Itt tetszés szerint beállíthatók a program által használt betűk.

Tipp: Ha parancssoros alkalmazást fordítunk, amelynél a fordítónak kell odafigyelnie a sortörésekre -- konzolon csak az utolsó (80.) oszlopnál van sortörés, akár egy szó közepén is ami igen ronda tud lenni -- akkor praktikus rögzített szélességű betűt választani, körülbelül 80 karakter széles szerkesztőablakkal.

## Szótárak (Beállítások -&gt; A szótár beállításai)

A KBabel talán leghasznosabb szolgáltatásai a szótárak. Használatukkal a már lefordított szövegeket hívhatjuk segítségül munkánk során, ami nem csak a lefordítandó szöveg hosszát és az unalmas rabszolgamunkát csökkentheti, de a terminológia konzisztenciájára is jótékony hatással van. Vegyük sorra őket:

### Kiegészítő fájl

Itt egyetlen fájlt adhatunk csak meg, ebben keresi az aktuálissal egyező karaktersorozatokat. Funkciója az, hogy ha beszélünk az angolon kívül más idegen nyelvet is, amelyre már le van fordítva a program, akkor itt megadhatjuk a fordítási fájlt, a program pedig kikeresi az adott nyelvű fordítást. Igen hasznos, ha egy-egy kifejezés vagy mondat értelmét illetően kétségeink merülnek fel.

### Összefoglaló fájl

Ez egy adott projekt, például a [KDE](KDE "wikilink") adott nyelvre fordított összes karakterláncának összeláncolásával létrejövő fájlban való keresést tesz lehetővé. Gyorsan kereshetünk vele az adott projekt által lefordított összes karakterlánc között, a megadott feltételek szerint. A KDE magyar nyelvű összefoglaló fájljai a <http://i18n.kde.org/teams/infos.php?teamcode=hu> KDE Localization - Information about Hungarian Team \[hu\]\] címről tölthetők le (az alapértelmezés hibás a 3.4.x és korábbi KBabelben). A [GNOME](GNOME "wikilink") egyelőre nem biztosít ilyet. Más projektek: [FIXME](FIXME "wikilink").

A keresés beállításai közül érdemes a "tartalmazza a szöveg egy szavát" lehetőséget kihagyni, ugyanis ez rendkívül hosszú keresési időt eredményezhet még kis fájloknál is. Összefoglaló fájlként használhatunk egy terminológiai szótárat is, például a [<http://l10n-status.gnome.org/HEAD/PO/gnome-glossary.HEAD.hu.po>](http://l10n-status.gnome.org/HEAD/PO/gnome-glossary.HEAD.hu.po) címen elérhető gnome-glossaryt, ez a projekt által gyakran használt szavakat gyűjti össze, ez egy egységes terminológia kialakítását célozza.

### Fordítási adatbázis

A leghasznosabb mind közül. Egy adatbázisba gyűjthetünk tetszőleges projektekből származó po-fájlokat, majd ebben kereshetünk. Feltöltéséhez először is be kell szerezni néhány po-fájlt: a kde projekttől az összefoglaló fájlnál megadott címről letölthető hu.messages elégséges, azonban a po & docs archive a dokumentációkat is tartalmazza, valamint a redundáns eredeti karakterláncok is megtalálhatóak, amelyek esetleg eltérő fordítással rendelkeznek.

GNOME: az alábbi branchból beszerezhető gmirr.sh szkripttel:

 [http://bazaar.launchpad.net/~ubuntu-l10n-hu/ubuntu-hu-web/tools/files/head%3A/gmirr/](http://bazaar.launchpad.net/~ubuntu-l10n-hu/ubuntu-hu-web/tools/files/head%3A/gmirr/)
 

Letöltés bazaar használatával:

 bzr branch lp:~ubuntu-l10n-hu/ubuntu-hu-web/tools  

KDE: <ftp://ftp.kde.org/pub/kde/stable/> alatt letölthető tarball formában, most éppen az aktuális: <ftp://ftp.kde.org/pub/kde/stable/4.3.0/src/kde-l10n/kde-l10n-hu-4.3.0.tar.bz2>

Egyéb: [FIXME](FIXME "wikilink")

Ezeket a műveleteket két-három havonta érdemes ismételni, hogy az újabb fordítások folyamatosan bekerüljenek az adatbázisba. Ezek már elegendőek az induláshoz, vágjunk is neki: Az Általános fülön a figyelmen kívül hagyandó karakterek listáját bővíthetjük a \_,!?; karakterekkel, a jó kulcsok fülön pedig csökkenthetjük a két csúszkát több eredmény reményében. Az adatbázis fülön tölthetjük fel az adatbázist az imént beszerzett po-fájlokkal, az egyetlen po-fájl ellenőrzése, könyvtár ellenőrzése és ennek rekurzív változatát megvalósító gombok segítségével.

### TMX összefoglaló fájl

[FIXME](FIXME "wikilink")

## Gyorsfordítás (Eszközök -&gt; Gyorsfordítás)

Miután feltöltöttük a fordítási adatbázisunkat és megnyitottuk a fordítandó fájlt, alkalmazhatjuk a gyorsfordítást az egyszer már egy más fájlban lefordított karakterláncek átemelésére. A gyorsfordítás ablakban megadhatjuk a lefordítandó részeket alapértelmezésben ezek a le nem fordított és a javítandó bejegyzések, valamint a fordítás szempontjait. Itt a felhasznált szótárak beállításait érdemes bepipálni, az intelligens és a szavankénti fordítást viszont ne engedélyezzük, ezek eredménye alig használható valamire és egy-egy üzenetet gyakran tovább tart lefordítani ezek használatával.

A módosított bejegyzéseket MINDIG jelöltessük javítandónak! A ki tudja ki által fordított/ellenőrzött korábbi fájlok tartalmazhatnak butaságokat, vagy olyan bejegyzéseket, amelyek bár az adott eredeti fájlban teljesen helyénvalóak, az aktuálisban viszont hibásak/ütköznek a terminológiával, ezeket gondolkodás nélkül átvenni nem szabad! A használandó szótár általában a fordítási adatbázis, mivel ez tartalmaz mindent amivel eddig dolgunk volt, általános gyűjteményként működik. A használandó mező mellett megadhatjuk a szótárak sorrendjét, ha több van, illetve a szótárakat a Beállítás gombbal egyedi, csak az adott keresésre érvényes beállításokat adhatunk meg. Az indítás gombbal elindul a folyamat, melynek végére átlagosan az üzenetek 15-30%-a lefordításra kerül (Ezek persze általában rövidebb üzenetek, tehát mondhatjuk, hogy a munka legkönnyebb részét "ússzuk meg", ám a konzisztencia szempontjából ez még így is számottevő, nem beszélve arról, hogy ez valószínűleg a munka legunalmasabb része is egyben - kinek van kedve minden programhoz legépelni a "Fájl", "Szerkesztés", "Nézet", "Súgó" és társaikat?).

## Hasznos billentyűkombinációk

A gyors és hatékony munkavégzés érdekében érdemes használni az alábbiakat:

A megnyitott po-fájlban való gyors navigációt segítő kombinációk:

 - következő/előző: Page Down/Page Up
 - következő/előző le nem fordított: Alt+Page Down/Page Up
 - következő/előző ellenőrzendő: Ctrl+Page Down/Page Up
 - következő/előző le nem fordított vagy ellenőrzendő: Ctrl+Shift+Page Down/Page Up

Szerkesztést segítő kombinációk:

 - következő argumentum beszúrása: Ctrl+Alt+G
 - következő html tag beszúrása: Ctrl+Alt+N
 - fuzzy állapot átbillentése: Ctrl+U

## Ellenőrzések

### Helyesírás-ellenőrzés (Eszközök -&gt; Helyesírás-ellenőrzés)

A KBabel képes az automatikus ellenőrzés mellett a teljes fájlban (vagy egy részében) megkeresni a hibákat, ám a tapasztalat szerint a huspell-po szkript használata sokkal gyorsabb és hatékonyabb, így inkább ezt javaslom.

### Ellenőrzés menü

Ebből a szintaktikai ellenőrzést kell használni, valamint a tag-ek és a gyorsbillentyűk ellenőrzése is hasznos.

### Fejlécszerkesztő (Szerkesztés -&gt; A fejléc szerkesztése)

Az utolsó lényeges dolog a po-fájl fejlécének szerkesztésére szolgáló ablak. A projekt beállításainál a Mentés lapon állítható be az itt megjelenő megjegyzés illetve fejléc frissítése, általában az alapértelmezett beállítás használata megfelelő, ám ha ehhez képest mégis módosítást akarunk végezni, itt megtehetjük.

## A Qt Linguist használata

A Qt Linguist nem különálló eszköz, hanem a Qt platform szerves része. Mint ilyen, külön csomagként nem is létezik, hanem a qt4-dev-tools csomag része.

Használata elég egyszerű: balra egy panelen vannak a "kontextusok", ez általában egy C++ osztályt vagy Qt formot jelent (ami ugye szintén egy C++ osztály :-) ).

Jobbra található az az osztott panel, melynek felső harmadának bal oldalán a fordítási egységek vannak, jobbra pedig az adott form, vagy a szöveg forrásbeli környezete. Ugyanezen panel középső harmadában történik a lényegi fordítás, illetve itt lehet megtekinteni a fejlesztő kommentjét az adott szöveghez; ezen felül lehetőség nyílik fordítói kommentek beszúrására is, az erre szolgáló mezőben.

Az alsó harmad bal oldalán a kifejezéstár és a megnyitott fájl(ok) alapján kalkulált javaslatok találhatók, míg jobboldalt az aktuális fordítási egység problémáit listázza a program (kimaradó hívóbetű, hiányzó placeholder, etc.).

Egyszerre több fájl is megnyitható, de csak az első írható. A többi fájlt megpróbálja ráilleszteni a jelenlegi fordításra, így ha például te olyan török fordító vagy, aki a német nyelvben jobban kiismeri magát, mint az angolban, akkor lehetőséged van látni a német fordítást is - természetesen abba nem piszkálhatsz. Képes a kifejezéstár alapján automata fordításra is, azonban az automata fordítónak gondot okoznak a hívóbetűk, így arra ügyelni kell, hogy a kifejezéstárban meglegyen a legtöbbször használt verzió.

Meg kell jegyezni, hogy a Qt 3 és Qt 4 verziók Linguist programjai nem kompatibilisek egymással: a 4-es .ts fájljainak nem minden mezőjét ismeri a 3-as Linguist, illetve a 3-as lrelease által készített .qm fájlok nem működnek a Qt 4 programok binárisaival.
-->
