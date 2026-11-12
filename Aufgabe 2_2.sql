-- 2.1 Ermitteln Sie die Auftragsnummern und das jeweilige Datum für alle Aufträge des Kunden „Fahrrad Shop“ mithilfe der IN-Anweisung.

select auftrnr, datum
from auftrag
where kundnr in
      (select nr
       from kunde
       where name = 'Fahrrad Shop');

-- 2.2 Formulieren Sie Ihre Anfrage aus 2.1 so um, dass Sie statt IN jetzt SOME verwenden.

select auftrnr, datum
from auftrag
where kundnr = some
      (select nr
       from kunde
       where name = 'Fahrrad Shop');

-- 2.3 Formulieren Sie die Anfrage aus 2.1 so um, dass Sie statt IN jetzt EXISTS verwenden

select auftrnr, datum
from auftrag
where EXISTS
          (select *
           from kunde
           where kunde.nr = auftrag.kundnr
             and kunde.name = 'Fahrrad Shop');

-- 2.4 Wie viele Aufträge gibt es je Kunde und in welchem Zeitraum lagen sie? Die Kundennummer reicht aus und soll gleichzeitig als Sortierschlüssel dienen.

select kundnr,
       count(*)   as anzahl,
       min(datum) as von,
       max(datum) as bis
from auftrag
group by kundnr
order by kundnr;

-- 2.5 Ändern Sie Aufgabe 2.4 so ab, dass nur Kunden mit einem Auftrag gewählt werden.

select kundnr,
       count(*)   as anzahl,
       min(datum) as von,
       max(datum) as bis
from auftrag
group by kundnr
having count(*) = 1
order by kundnr;

-- 2.6 Ermitteln Sie mithilfe der JOIN-Anweisung alle Kunden mit ihren zugehörigen Auftragsnummern.

select k.nr,
       k.name,
       a.auftrnr
from kunde k
         join auftrag a on k.nr = a.kundnr
order by k.nr;

-- 2.7 Ändern Sie die Lösung zu Aufgabe 2.6 so ab, dass Sie zusätzlich auch noch den Namen des Mitarbeiters ausgeben.

select k.nr,
       k.name as kunde,
       a.auftrnr,
       p.name as mitarbeiter
from kunde k
         join auftrag a on k.nr = a.kundnr
         join personal p on a.persnr = p.persnr
order by k.nr;

-- 2.8 Welcher Kunde hat für den höchsten Gesamtpreis Aufträge erteilt? Mit anderen Worten: Wer ist der beste Kunde? Geben Sie den Namen des Kunden inkl. seiner Gesamtauftragssumme aus.

select k.name              as kundenname,
       sum(ap.gesamtpreis) as Gesamtpreissumme
from kunde k
         join auftrag a on k.nr = a.kundnr
         join auftragsposten ap on a.auftrnr = ap.auftrnr
group by k.name
order by Gesamtpreissumme desc
limit 1;

-- 2.9 Schreiben Sie Ihre Lösung der Aufgabe 2.8 so um, dass Sie zunächst eine ungeordnete Hilfstabelle aller Kunden mit ihren Gesamtauftragssummen mithilfe der WITH-Anweisung und lesen Sie aus dieser Tabelle den Kunden mit dem höchsten Umsatz aus.

with hilfstabelle as
         (select k.name,
                 sum(ap.gesamtpreis) as gesamtumsatz
          from kunde k
                   join auftrag a on k.nr = a.kundnr
                   join auftragsposten ap on a.auftrnr = ap.auftrnr
          group by name)
select *
from hilfstabelle
order by gesamtumsatz desc
limit 1;

-- 2.10 Geben Sie die Bezeichnungen aller zusammengesetzten Teile der Teilstämme zusammen mit ihren Nettopreisen sowie dem Durchschnitt der Nettopreise dieser Teile aus.

select distinct t.bezeichnung,
                t.nettopreis,
                (select avg(t2.nettopreis)
                 from teilestamm t2
                          join teilestruktur ts2 on t2.teilnr = ts2.oberteilnr)
                    as durchschnitt
from teilestamm t
         join teilestruktur ts on t.teilnr = ts.oberteilnr;

-- 2.11 Geben Sie die Bezeichnungen und Typen aller zusammengesetzten Teil der Teilstämme zusammen mit ihren Nettopreisen sowie dem Durchschnitt der Nettopreise je Typ aus.

select distinct t.bezeichnung,
                t.typ,
                t.nettopreis,
                (select AVG(t2.nettopreis)
                 from teilestamm t2
                          join teilestruktur ts2
                               on t2.teilnr = ts2.oberteilnr
                 where t2.typ = t.typ) as durchschnitt
from teilestamm t
         join teilestruktur ts
              on t.teilnr = ts.oberteilnr
order by typ;

-- 2.12 Erzeugen Sie eine View (Ansicht) KundenUmsatz mit allen Kunden und den Summen Ihrer Aufträge. Lesen Sie alle Daten der View aus.

create view KundenUmsatz as
select k.nr,
       k.name              as kundenname,
       a.kundnr,
       sum(ap.gesamtpreis) as Gesamtumsatz
from kunde k
         join auftrag a on k.nr = a.kundnr
         join auftragsposten ap on a.auftrnr = ap.auftrnr
group by k.nr, k.name, a.kundnr;

select *
from KundenUmsatz;

-- 2.13 Löschen Sie die View aus Aufgabe 2.12 wieder.

drop view KundenUmsatz;