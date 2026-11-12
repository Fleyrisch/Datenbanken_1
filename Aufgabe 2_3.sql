/*
• Öffnen Sie eine Transaktion.
• Bestimmen Sie die Zahl der Lieferungen.
• Löschen Sie alle Lieferanten.
• Bestimmen Sie die Zahl der Lieferungen. Warum sind welche verschwunden? Konsul-
tieren Sie zur Beantwortung auch die Datei hska_oracle_bike.sql.
• Stellen Sie durch Beenden der Transaktion den ursprünglichen Zustand wieder her.
• Bestimmen Sie die Zahl der Lieferungen.
*/

-- Transaktion öffnen
BEGIN;

-- Anzahl Lieferungen bestimmen
SELECT COUNT(*) AS anzahl_lieferungen
FROM lieferung;

-- Lieferanten löschen
DELETE FROM lieferant;

-- Anzahl Lieferungen nach DELETE bestimmen
SELECT COUNT(*) AS anzahl_lieferungen_nach_delete
FROM lieferung;

-- Zustand vor BEGIN wiederherstellen
ROLLBACK;

-- Anzahl Lieferungen nach ROLLBACK bestimmen
SELECT COUNT(*) AS anzahl_lieferungen_nach_rollback
FROM lieferung;

