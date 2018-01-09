-- Napisz funkcję masaPudelka wyznaczającą masę pudełka jako sumę masy czekoladek w nim zawartych. Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na podstawie prostej instrukcji select.

create or replace function masaPudelka (id_pudelka char(4)) returns integer as 
$$
declare
	suma integer;
begin
	select sum(masa*sztuk) into suma from pudelka natural join zawartosc join czekoladki using (idczekoladki) where idpudelka = id_pudelka;
	return suma;
end;
$$ 
language plpgsql;


--  Napisz funkcję liczbaCzekoladek wyznaczającą liczbę czekoladek znajdujących się w pudełku. Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na podstawie prostej instrukcji select. 

create or replace function liczbaCzekoladek (id_pudelka char(4)) returns integer as 
$$ 
declare
	liczba integer;
begin
	select sum(sztuk) into liczba from pudelka natural join zawartosc where id_pudelka = idpudelka;
	return liczba;
end;
$$ 
language plpgsql;

--Napisz funkcję zysk obliczającą zysk jaki cukiernia uzyskuje ze sprzedaży jednego pudełka czekoladek, zakładając, że zysk ten jest różnicą między ceną pudełka, a kosztem wytworzenia zawartych w nim czekoladek i kosztem opakowania (0,90 zł dla każdego pudełka). Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na podstawie prostej instrukcji select.

create or replace function liczZysk (id_pudelka char(4)) returns integer as 
$$ 
declare
	zysk integer;
begin
	select (zyskPudelko.cena - zyskPudelko.koszt) into zysk
	from ( select idpudelka, p.cena as cena, sum(z.sztuk*c.koszt) as koszt
	from pudelka p natural join zawartosc z join czekoladki c using (idczekoladki) where idpudelka = id_pudelka
	group by idpudelka) zyskPudelko;

	zysk := zysk + 0.9;
	return zysk;
end;
$$ 
language plpgsql;

--  Napisz instrukcję select obliczającą zysk jaki cukiernia uzyska ze sprzedaży pudełek zamówionych w wybranym dniu.

create or replace function liczZyskWDniu (data date) returns integer as 
$$ 
declare
	zysk integer;
	tmp integer;
	id_pudelka char(4)[];
	i smallint;
begin
	select idpudelka into id_pudelka from zamowienia natural join artykuly where datarealizacji = data;
	i := 1;
	while id_pudelka[i] is not null loop
		select liczZysk(id_pudelka[i]) into tmp;
		zysk := zysk + tmp;
		i := i + 1;
	end loop;
	return zysk;
end;
$$ 
language plpgsql;

-- Napisz funkcję sumaZamowien obliczającą łączną wartość zamówień złożonych przez klienta, które czekają na realizację (są w tabeli Zamowienia). Funkcja jako argument przyjmuje identyfikator klienta. Przetestuj działanie funkcji.

create or replace function sumaZamowien (id_klienta integer) returns integer as 
$$ 
declare
	wartosc integer;
begin
	select sum(cena) into wartosc from zamowienia natural join artykuly natural join pudelka where idklienta = id_klienta;

	return wartosc;
end;
$$ 
language plpgsql;

--  Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient składający zamówienie. Funkcja jako argument przyjmuje identyfikator klienta. Rabat wyliczany jest na podstawie wcześniej złożonych zamówień w sposób następujący:

 --   4 % jeśli wartość zamówień jest z przedziału 101-200 zł;
  --  7 % jeśli wartość zamówień jest z przedziału 201-400 zł;
  --  8 % jeśli wartość zamówień jest większa od 400 zł.

create or replace function obliczRabat (id_klienta integer) returns integer as 
$$ 
declare
	wartosc integer;
begin
	select sumaZamowien(id_klienta) into wartosc;
	if wartosc > 100 and wartosc <= 200 then return wartosc*0.04;

	elsif wartosc > 200 and wartosc <= 400 then return wartosc*0.07;

	elsif wartosc > 400 then return wartosc*0.08;

	else return wartosc; 
	end if;
end;
$$ 
language plpgsql;

--Napisz bezargumentową funkcję podwyzka, która dokonuje podwyżki kosztów produkcji czekoladek o:

  --  3 gr dla czekoladek, których koszt produkcji jest mniejszy od 20 gr;
  --  4 gr dla czekoladek, których koszt produkcji jest z przedziału 20-29 gr;
  --  5 gr dla pozostałych.

--Funkcja powinna ponadto podnieść cenę pudełek o tyle o ile zmienił się koszt produkcji zawartych w nich czekoladek.

create or replace function podwyzka () returns void as 
$$ 
declare
	k czekoladki%rowtype;
begin	
	for k in select * from czekoladki
	loop
		if k.koszt < 0.20 then
			UPDATE czekoladki SET koszt = k.koszt + 0.03 WHERE idczekoladki = k.idczekoladki;
		elseif k.koszt >= 0.20 and k.koszt <= 0.29 then
			UPDATE czekoladki SET koszt = k.koszt + 0.04 WHERE idczekoladki = k.idczekoladki;
		else
			UPDATE czekoladki SET koszt = k.koszt + 0.05 WHERE idczekoladki = k.idczekoladki;
		END IF;
	end loop;
end;
$$ 
language plpgsql;

-- Napisz funkcję zwracającą informacje o zamówieniach złożonych przez klienta, którego identyfikator podawany jest jako argument wywołania funkcji. W/w informacje muszą zawierać: idzamowienia, idpudelka, datarealizacji. Przetestuj działanie funkcji. Uwaga: Funkcja zwraca więcej niż 1 wiersz!

create temporary table dane (id_klienta int, id_zamowienia int, id_pudelka char(4), data_realizacji date);

create or replace function podsumowanie (id_klienta int) returns setof dane as 
$$ 

begin	
	return query 
		select idklienta, idzamowienia, idpudelka, datarealizacji from zamowienia natural join artykuly where idklienta = id_klienta;
	
end;
$$ 
language plpgsql;

-- Napisz funkcję zwracającą listę klientów z miejscowości, której nazwa podawana jest jako argument wywołania funkcji. Lista powinna zawierać: nazwę klienta i adres. Przetestuj działanie funkcji.

create temporary table dane_miejscowosc (nazwa_klienta varchar(130), ulicaK varchar(30), miejscowoscK varchar(15), kodK char(6));

create or replace function podsumowanieMiejscowosc (miejscowoscKlienta varchar(15)) returns setof dane_miejscowosc as 
$$ 
begin	
	return query 
		select nazwa, ulica, miejscowosc, kod from klienci where miejscowosc = miejscowoscKlienta;
	
end;
$$ 
language plpgsql;

