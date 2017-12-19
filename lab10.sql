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

10.4.1
select nazwa, opis, cena from pudelka natural join zawartosc  where idczekoladki in (select idczekoladki from czekoladki where idczekoladki like 'd09');

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

10.6.1
pudełka o największej liczbie czekoladek (bez użycia klauzuli limit),

select nazwa, sztuk from pudelka natural join zawartosc where nazwa in (select nazwa from pudelka natural join zawartosc where sztuk = (select max(sztuk) from zawartosc) group by idpudelka); 
