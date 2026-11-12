-- Aufgabe 2.1
-- 1.1 Geben Sie alle Zeilen der Relation teilestaemme aus.
select * from teilestamm;

-- 1.2 Welche Zeilen in teilestaemme haben in ihrer Bezeichnung das Wort „City“ in beliebiger
-- Groß- oder Kleinschreibung?
select * from teilestamm where lower(bezeichnung) like '%city%';

-- 1.3 Welches Teil hat den höchsten Umsatz in der Tabelle Auftragsposten erzielt?
select * from auftragsposten order by anzahl * gesamtpreis desc
    fetch first 1 row only;

-- 1.4 Wie viele kunden-, personal-, teilestaemme-Zeilen gibt es jeweils?
select
    (select count(*) from kunde) as num_kunden,
    (select count(*) from personal) as num_personal,
    (select count(*) from teilestamm) as num_teilestamm;

-- 1.5 Aus welchem Zeitraum stammen die Aufträge?
select
    (select datum from auftrag order by datum asc limit 1) as start_datum,
    (select datum from auftrag order by datum desc limit 1) as end_datum;

-- 1.6 Schauen Sie sich die Relationen kunden, personal und auftraege an. Notieren Sie den
-- Namen des Kunden sowie den Namen des zuständigen Mitarbeiters zu Auftrag 2. Welchen
-- Namen hat der Vorgesetzte dieses Mitarbeiters? Lösen Sie diese Aufgabe mit vier einzelnen
-- SELECT-Abfragen ohne komplizierte JOINs etc.

-- auftrnr = 2 -> persnr -> vorgesetzt -> name

select
    (select name from kunde where nr = (select kundnr from auftrag where auftrnr = 2)) as Kunde,
    (select name from personal where persnr = (select persnr from auftrag where auftrnr = 2)) as Mitarbeiter,
    (select name from personal where persnr =
        (select vorgesetzt from personal where persnr =
                        (select persnr from auftrag where auftrnr = 2))) as Vorgesetzter;

-- 1.7 Geben Sie alle Teile, die sich mindestens einmal im Lager befinden, aufsteigend sortiert
-- nach der Anzahl der Teile aus.

select * from lager where bestand > 0 order by bestand asc;

-- 1.8 Finden Sie die Nummern aller Teile, die geliefert wurden, und geben Sie diese absteigend,
-- anhand ihrer Nummer sortiert, und ohne Mehrfachnennung aus.

select distinct teilnr from lieferung order by teilnr asc;

-- 1.9 Zeigen Sie die Teilenummern, Bezeichnungen und (Brutto-)Preise für alle Teile, die brut-
-- to mehr als 30 Euro kosten. Geben Sie jeder Spalte der Ausgabe eine selbsterklärende
-- Überschrift.

select teilnr as Teilenr,
       bezeichnung as Bezeichnung,
       preis as Bruttopreis
       from teilestamm where preis > 30;

-- 1.10 Von welchen Einzelteilen des Teils 300001 werden jeweils mehr als 100 cm benötigt?

select einzelteilnr from teilestruktur where oberteilnr = 300001 and anzahl > 100 and einheit = 'CM' ;