3.1.1
select * from zamowienia where (datarealizacji > '2013-11-12') and (datarealizacji < '2013-11-20');
3.1.2
select * from zamowienia where ((datarealizacji > '2013-12-01')	and	(datarealizacji < '2013-12-06')) or	((datarealizacji > '2013-12-15') and (datarealizacji < '2013-12-20'));
3.1.3
select * from zamowienia where (datarealizacji >= '2013-12-01' and datarealizacji <= '2013-12-31');
3.1.4
select * from zamowienia where (date_part('year', datarealizacji) = 2013) and (date_part('month', datarealizacji) = 11);

3.2.1
select * from czekoladki where nazwa like 'S%';
3.2.2
select * from czekoladki where nazwa like 'S%i';
3.2.3
select * from czekoladki where nazwa like 'S%' and nazwa like '% m%' and nazwa not like '%m';
3.2.4
select * from czekoladki where nazwa similar to '(A|B|C)%';
3.2.5
select * from czekoladki where nazwa similar to '%(O|o)rzech%';
3.2.6
select * from czekoladki where nazwa similar to 'S%m_%';

3.3.1
select * from klienci where miejscowosc similar to '% %';