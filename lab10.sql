10.2.1

select idzamowienia, datarealizacji from zamowienia z natural join klienci k where k.nazwa in (select nazwa from klienci where nazwa like '%Antoni');  

10.2.2
select idzamowienia, datarealizacji from zamowienia z natural join klienci k where k.ulica in (select ulica from klienci where ulica like '%/%');  

10.2.3
select idzamowienia, datarealizacji from zamowienia z natural join klienci k where k.miejscowosc in (select miejscowosc from klienci where miejscowosc like 'Kraków') and datarealizacji::text similar to '2013-11%'; 

10.3.1
select nazwa, ulica, miejscowosc from klienci natural join zamowienia where datarealizacji in (select datarealizacji from zamowienia where datarealizacji::text similar to '2013-11-12');

10.3.2
select nazwa, ulica, miejscowosc from klienci natural join zamowienia where datarealizacji in (select datarealizacji from zamowienia where datarealizacji::text similar to '2013-11-%');

10.3.3 zamówili pudełko Kremowa fantazja lub Kolekcja jesienna,

select k.nazwa, k.ulica, k.miejscowosc, p.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where p.nazwa in (select nazwa from pudelka where nazwa in ('Kremowa fantazja', 'Kolekcja jesienna')); 

10.3.4 zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna w ramach jednego zamówienia,
select k.nazwa, k.ulica, k.miejscowosc, p.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where p.nazwa in (select nazwa from pudelka where nazwa in ('Kremowa fantazja', 'Kolekcja jesienna')) and sztuk >= 2; 

10.3.5 zamówili pudełka, które zawierają czekoladki z migdałami,
select k.nazwa, k.ulica, k.miejscowosc, c.nazwa, c.orzechy from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) natural join zawartosc join czekoladki c using (idczekoladki) where c.nazwa in (select nazwa from czekoladki where c.orzechy = 'migdały');

10.3.6 złożyli przynajmniej jedno zamówienie,
select nazwa, ulica, miejscowosc from klienci where idklienta in (select idklienta from zamowienia);

10.3.7 nie złożyli żadnych zamówień.
select nazwa, ulica, miejscowosc from klienci where nazwa not in (select nazwa from zamowienia);

10.4.1
select nazwa, opis, cena from pudelka natural join zawartosc  where idczekoladki in (select idczekoladki from czekoladki where idczekoladki like 'd09');

10.4.2 zaw czekoladki gorzka truskawkowa 
select p.nazwa, c.nazwa, p.cena from pudelka p natural join zawartosc join czekoladki c using(idczekoladki) where c.nazwa in (select nazwa from czekoladki where c.nazwa like 'Gorzka truskawkowa');

10.4.3 
zawierają przynajmniej jedną czekoladkę, której nazwa zaczyna się na S,

select p.nazwa, c.nazwa, p.cena from pudelka p natural join zawartosc join czekoladki c using(idczekoladki) where c.nazwa in (select nazwa from czekoladki where c.nazwa like 'S%');

10.4.4 zawierają przynajmniej 4 sztuki czekoladek jednego gatunku (o takim samym kluczu głównym),

select p.nazwa, c.nazwa, p.cena from pudelka p natural join zawartosc join czekoladki c using(idczekoladki) where c.idczekoladki in (select idczekoladki from zawartosc natural join czekoladki where sztuk > 4);

10.4.5 ★ zawierają co najmniej 3 sztuki czekoladki Gorzka truskawkowa,
select p.nazwa, c.nazwa, p.cena from pudelka p natural join zawartosc join czekoladki c using(idczekoladki) where c.nazwa in (select nazwa from czekoladki where c.nazwa like 'Gorzka truskawkowa') and sztuk >= 3;

★ zawierają czekoladki z nadzieniem truskawkowym,
10.4.6
select p.nazwa, c.nazwa, p.cena from pudelka p natural join zawartosc join czekoladki c using(idczekoladki) where c.nazwa in (select nazwa from czekoladki where nadzienie like 'truskawki');

10.4.7 nie zaw czekoladek w gorzkiej czekoladzie
select p.nazwa, p.opis, p.cena from pudelka p natural join zawartosc z where p.nazwa not in (select p.nazwa from pudelka p natural join zawartosc z join czekoladki c using (idczekoladki) where c.czekolada = 'gorzka');

10.4.8 nie zaw czekoladek z orzechami 
select p.nazwa, p.opis, p.cena from pudelka p natural join zawartosc z where p.nazwa not in (select p.nazwa from pudelka p natural join zawartosc z join czekoladki c using (idczekoladki) where c.orzechy is not null);

10.4.9
zaw przynajmniej jedna czekoladke bez nadzienia

select p.nazwa, p.opis, p.cena from pudelka p natural join zawartosc z where p.nazwa in (select p.nazwa from pudelka p natural join zawartosc z join czekoladki c using (idczekoladki) where c.nadzienie is null);

10.5.1
Wyświetl wartości kluczy głównych oraz nazwy czekoladek, których koszt jest większy od czekoladki o wartości klucza głównego równej D08.

select idczekoladki, nazwa from czekoladki where koszt > (select koszt from czekoladki where idczekoladki like 'd08');

10.5.2 
 Kto (nazwa klienta) złożył zamówienia na takie same czekoladki (pudełka) jak zamawiała Gorka Alicja.
 select distinct k.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where p.nazwa in (select p.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where k.nazwa like 'Górka Alicja');
 
 10.5.3
 Kto (nazwa klienta, adres) złożył zamówienia na takie same czekoladki (pudełka) jak zamawiali klienci z Katowic.
select distinct k.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where p.nazwa in (select p.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where k.miejscowosc like 'Katowice');

10.6.1
pudełka o największej liczbie czekoladek (bez użycia klauzuli limit),

select nazwa, sztuk from pudelka natural join zawartosc where nazwa in (select nazwa from pudelka natural join zawartosc where sztuk = (select max(sztuk) from zawartosc) group by idpudelka); 
