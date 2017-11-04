4.2.1
select datarealizacji, idzamowienia, nazwa from zamowienia natural join klienci where nazwa like '% Antoni';
4.2.2
select datarealizacji, idzamowienia, ulica from zamowienia natural join klienci where ulica like '%/%';
4.2.3
select datarealizacji, idzamowienia, miejscowosc from zamowienia natural join klienci where miejscowosc like 'Kraków' and date_part('month', datarealizacji) = 11 and date_part('year', datarealizacji) = 2013 order by 1;

4.3.1
select nazwa, ulica, miejscowosc, date_part('year', datarealizacji) as "Rok" from klienci natural join zamowienia where extract(year from datarealizacji) >= 2012;
-- more generally : where datarealizacji >= current_date - interval '5 years';

4.3.2
select k.nazwa, ulica, miejscowosc, p.nazwa  from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where p.nazwa in ('Kremowa fantazja', 'Kolekcja jesienna');

4.3.3
select nazwa, ulica, miejscowosc from klienci join zamowienia using(idklienta);

select distinct nazwa, ulica, miejscowosc from klienci natural join zamowienia order by 1;

4.3.4
select idklienta, nazwa, ulica, miejscowosc from klienci full join zamowienia using(idklienta) where idklienta is null order by 1;

select distinct z.idklienta, k.nazwa, k.ulica, k.miejscowosc
from zamowienia z right join klienci k on k.idklienta = z.idklienta
where z.idklienta is null or where idzamowienia is null
order by 1;

4.3.5
select distinct nazwa, ulica, miejscowosc, datarealizacji from klienci natural join zamowienia where extract(month from datarealizacji) = 11 and extract(year from datarealizacji) = 2013;

4.3.6
select distinct k.nazwa, ulica, miejscowosc, sztuk, p.nazwa from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) where sztuk >= 2 and p.nazwa in ('Kremowa fantazja', 'Kolekcja jesienna');

4.3.7
select distinct k.nazwa, ulica, miejscowosc, orzechy from klienci k natural join zamowienia natural join artykuly join pudelka p using (idpudelka) join zawartosc using (idpudelka) join czekoladki using (idczekoladki) where orzechy like 'migdały';

4.4.1
select left(rtrim(p.nazwa || ' : ' || p.opis),50) as "Pudełko", left(rtrim(c.nazwa || ' : ' || c.opis),50) as "Czekoladki" from pudelka p natural join zawartosc join czekoladki c using (idczekoladki);  

select left(rtrim(p.nazwa ||' - '|| p.opis),50) as "Pudelko", left(rtrim(z.sztuk || '-' || c.nazwa || ' - ' || c.opis),50) as "Zawartość"
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
order by 1;

4.4.2
select left(rtrim(p.nazwa || ' : ' || p.opis),50) as "Pudełko", left(rtrim(c.nazwa || ' : ' || c.opis),50) as "Czekoladki", p.idpudelka from pudelka p natural join zawartosc join czekoladki c using (idczekoladki) where p.idpudelka = 'heav';

4.4.3
select left(rtrim(p.nazwa || ' : ' || p.opis),50) as "Pudełko", left(rtrim(c.nazwa || ' : ' || c.opis),50) as "Czekoladki", p.nazwa from pudelka p natural join zawartosc join czekoladki c using (idczekoladki) where p.nazwa like '%Kolekcja%';

4.5.1
select left(rtrim(p.nazwa || ' : ' || p.opis),50) as "Pudełko", p.cena, idczekoladki from pudelka p natural join zawartosc join czekoladki c using (idczekoladki) where idczekoladki = 'd09';

select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.idczekoladki
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
where c.idczekoladki like 'd09'

4.5.2
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.nazwa
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) where c.nazwa like 'S%' order by 1;

4.5.3
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.idczekoladki, sztuk
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) where sztuk >= 4 order by 1;

4.5.4
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.nadzienie
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) where nadzienie like 'truskawki';

4.5.5
-- 36 rows
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.czekolada
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
except
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.czekolada
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) 
where c.czekolada like 'gorzka';

select distinct left(rtrim(p.nazwa ||' - '|| p.opis),50) as "Pudelko", p.cena, c.czekolada
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
except
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),50) as "Pudelko", p.cena, c.czekolada
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
where c.czekolada like 'gorzka'
order by 1;

select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena, c.czekolada
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
where c.czekolada not like 'gorzka';

4.5.6
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", sztuk, c.nazwa
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) where sztuk >= 3 and c.nazwa like 'Gorzka truskawkowa';

4.5.7
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko"
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
except 
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko"
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
where orzechy is not null; 

select distinct left(rtrim(p.nazwa ||' - '|| p.opis),50) as "Pudelko", p.cena
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
except
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),50) as "Pudelko", p.cena
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
where c.orzechy is not null
order by 1;

4.5.8
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", sztuk, c.nazwa
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) where c.nazwa like 'Gorzka truskawkowa';

4.5.9
select distinct left(rtrim(p.nazwa ||' - '|| p.opis),45) as "Pudelko", p.cena,  c.nadzienie
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki) where c.nadzienie is null;

select distinct left(rtrim(p.nazwa ||' - '|| p.opis),50) as "Pudelko", p.cena, c.nadzienie
from pudelka p natural join zawartosc z join czekoladki c using(idczekoladki)
where c.nadzienie is null
order by 1;

4.6.1
select (a.idczekoladki || ' : ' || a.nazwa) as "Czkoladka 1", (b.idczekoladki || ' : ' || b.nazwa) as "Czekoladka 2" from czekoladki a, czekoladki b where b.idczekoladki = 'd08' and a.koszt > b.koszt;

select c1.idczekoladki as "ID1", c1.nazwa, c1.koszt as "Koszt1", c2.idczekoladki as "ID2", c2.koszt as "Koszt2"
from czekoladki c1, czekoladki c2
where c2.idczekoladki like 'd08' and c1.koszt > c2.koszt;

select a.idczekoladki, b.idczekoladki from czekoladki a join czekoladki b on (b.idczekoladki = 'd08' and b.koszt < a.koszt);

4.6.2

select distinct k2.nazwa from klienci k1 natural join zamowienia z1 natural join artykuly a1, klienci k2 natural join zamowienia z2 natural join artykuly a2 where k1.nazwa like 'Górka Alicja' and a1.idpudelka = a2.idpudelka order by 1;

4.6.3
select distinct k2.nazwa, (k2.ulica || ' ' || k2.miejscowosc) as "Adres" from klienci k1 natural join zamowienia z1 natural join artykuly a1, klienci k2 natural join zamowienia z2 natural join artykuly a2 where k1.miejscowosc like 'Katowice' and a1.idpudelka = a2.idpudelka order by 1;

