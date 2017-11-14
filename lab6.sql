--6.1

insert into czekoladki values ('W98', 'Biały kieł', 'biała', 'laskowe', 'marcepan', 'Rozpływające się w rękach i kieszeniach', 0.45, 20);

insert into klienci values (90, 'Matusiak Edward', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'), 
(91, 'Matusiak Alina', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'), (92, 'Kimono Franek', 'Karateków 8', 'Mistrz', '30-029', '501 498 324');
 
insert into klienci values (93, 'Matusiak Iza', (select ulica from klienci where nazwa like 'Matusiak Edward'), (select miejscowosc from klienci where nazwa like 'Matusiak Edward'), (select kod from klienci where nazwa like 'Matusiak Edward'), (select telefon from klienci where nazwa like 'Matusiak Edward'));

insert into czekoladki values ('X91', 'Nieznana Nieznajoma', null, null, null, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0);

insert into czekoladki values ('M98', 'Mleczny Raj', 'mleczna', null, null, 'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);

delete from czekoladki where idczekoladki in ('X91', 'M98');

--6.4 

update klienci set nazwa = 'Nowak Iza' where nazwa like 'Matusiak Iza';

update czekoladki set koszt = koszt*0.9 where idczekoladki in ('W98', 'M98', 'X91');

update czekoladki set koszt = (select koszt from czekoladki where idczekoladki = 'W98') where nazwa = 'Nieznana Nieznajoma'; 

update klienci set miejscowosc = 'Piotrograd' where miejscowosc = 'Leningrad';

update czekoladki set koszt = koszt + 0.15 where idczekoladki like '%9%' and idczekoladki not like '%90';

-- 6.5
delete from klienci where nazwa like 'Matusiak%';

delete from klienci where idklienta > 91;

delete from czekoladki where koszt >= 0.45 or masa >= 36 or masa = 0;

-- 6.6

insert into pudelka values ('W99', 'fajne pudelko', 'moje pudelko', 100, 10), ('X99', 'pudelko2', 'tez moje pudelko', 101, 10);

insert into zawartosc values ('W99', 'b04', 10), ('W99', 'b02', 10), ('W99', 'b05', 1), ('W99', 'm11', 1);

insert into zawartosc values ('X99', 'm01', 10), ('X99', 'm05', 10), ('X99', 'm11', 1), ('X99', 'b05', 1);

-- 6.7
--COPY pudelka from STDIN;

--COPY zawartosc from STDIN  (delimiter('|'));

COPY pudelka [idpudelka, nazwa, opis, cena, stan] FROM 'pudelka.txt' with option [DELIMITER ','] ;
COPY zawartosc [idpudelka, idczekoladki, sztuk] FROM 'zawartosc.txt' with option [DELIMITER ','] ;

--6.8
update pudelka set stan = stan+1 where idpudelka in ('W99', 'X99');

update czekoladki set czekolada = 'brak' where czekolada is null;
update czekoladki set orzechy = 'brak' where orzechy is null;
update czekoladki set nadzienie = 'brak' where nadzienie is null;

update czekoladki set czekolada = null where czekolada like 'brak';
update czekoladki set orzechy = null where orzechy like 'brak';
update czekoladki set nadzienie = null where nadzienie like 'brak';
