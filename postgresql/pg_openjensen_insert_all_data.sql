--
-- Drop all foreign constraints
--

ALTER TABLE T_UTBILD DROP CONSTRAINT utbild_ort_id_fk ;
  
ALTER TABLE T_ELEV DROP CONSTRAINT elev_kontakt_id_fk ;

ALTER TABLE T_ELEV DROP CONSTRAINT elev_utbild_id_fk ;

ALTER TABLE T_KURS DROP CONSTRAINT kurs_utbild_id_fk ;

ALTER TABLE T_KURS DROP CONSTRAINT kurs_lokal_id_fk ;

ALTER TABLE T_LARARE DROP CONSTRAINT larare_kontakt_id_fk ;


ALTER TABLE T_KURLAR DROP CONSTRAINT kurlar_kurs_id_fk ;

ALTER TABLE T_KURLAR DROP CONSTRAINT kurlar_larar_id_fk ;

ALTER TABLE T_LARKOM DROP CONSTRAINT larkom_larar_id_fk ;

ALTER TABLE T_LARKOM DROP CONSTRAINT larkom_kompetens_id_fk ;


ALTER TABLE T_BETYG DROP CONSTRAINT betyg_kurs_id_fk ;

ALTER TABLE T_BETYG DROP CONSTRAINT betyg_elev_id_fk ;


--
-- T_KONTAK (1)
--


INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (1, 'Bert','Kronqvist','Dalagatan','25','14976','Värmdö','bert.kronqvist@gmail.com','0702401800',NULL,NULL);

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (2, 'Karl','Kalkyl','Sveavägen','100','10254','Stockholm','karl.kalkyl@hotmail.com','076123456',NULL,'08123456');

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (3, 'Albert','Einstein','Pedalvägen','14','16123','Bromma','albert@yahoo.se','077123456','070234156','08987654');

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (4, 'Elisabeth','Land','Cobolstigen','64','17123','Sundbyberg','elisabeth@land.se','0705331058',NULL,NULL);

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (5, 'Karl','Pedal','Karlbergsvägen','100','10712','Stockholm','kp@yahoo.se','0721234665',NULL,'08104123');

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (6, 'Filip','Svensson','Hästhagsvägen','34','16327','Spånga','filip@gmail.com','073222134',NULL,NULL);

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (7, 'Pernilla','Grön','Jerntorget','4','41234','Göteborg','pgrön@yahoo.se','078132156',NULL,'031232456');

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (8, 'Pernilla','Blå','Olympiabacken','11','32156','Malmö','pbla@hotmail.com','0719998456',NULL,NULL);

INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES (9, 'Kurt','Fellow','Vasagatan', '12', '11026','Stockholm','kfellow@gmail.com',NULL,'0701261254',NULL);


--
-- T_ORT (2)
--


INSERT INTO T_ORT
(Ort_id,Enhetsnamn,Gatunamn,Gatunummer,Postnummer,Postort,Email,Arbetstfn)
VALUES (1,'Jensen Yrkeshögskola Stockholm','Karlbergsvägen', '77','11335','Stockholm','info@jensenyrkeshogskola.se','084502220');

INSERT INTO T_ORT
(Ort_id,Enhetsnamn,Gatunamn,Gatunummer,Postnummer,Postort,Email,Arbetstfn)
VALUES (2,'Jensen Yrkeshögskola Göteborg','Stora Nygatan', '23-25','41108','Göteborg','mella.stegs@jenseneducation.se','0107095078');

INSERT INTO T_ORT
(Ort_id,Enhetsnamn,Gatunamn,Gatunummer,Postnummer,Postort,Email,Arbetstfn)
VALUES (3,'Jensen Yrkeshögskola Malmö','Stadiongatan', '67','21767','Malmö','martin.wesseloh@jenseneducation.se','0107095067');

--
-- T_UTBILD (3)
--


INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (1,'COBOL-programmerare',1,'2013-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (2,'Redovisningsekonom',2,'2013-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (3,'Webbutvecklare',1,'2013-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (4,'Certifierad IT-projektledare',1,'2013-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (5,'Redovisningsekonom',3,'2014-01-14');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (6,'COBOL-programmerare',1,'2014-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (7,'Redovisningsekonom',2,'2014-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (8,'Webbutvecklare',1,'2014-08-21');

INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES (9,'Certifierad IT-projektledare',1,'2014-08-21');


--
-- T_ELEV (4)
--


INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES (1,'196702081234','Högskola','CBKaug13',NULL,1,1);

INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES (2,'196602071234','Universitet','CBKaug13',NULL,1,5);

INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES (3,'199802071234','Gymnasieskola','CBKaug13',NULL,1,6);

INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES (4,'198002071244','Gymnasieskola','REGaug13',NULL,2,7);

INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES (5,'198802071244','Högskola','REMaug13',NULL,3,8);

INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES(6,'196012012275','Högskola','CBKaug12','VG',1,9);


--
-- T_JLOKAL (5)
--


INSERT INTO T_JLOKAL
(Lokal_id, Lokalnamn,Vaningsplan,Maxdeltagare)
VALUES (1,'S41','4','35');

INSERT INTO T_JLOKAL
(Lokal_id, Lokalnamn,Vaningsplan,Maxdeltagare)
VALUES (2,'S42','4','40');

INSERT INTO T_JLOKAL
(Lokal_id, Lokalnamn,Vaningsplan,Maxdeltagare)
VALUES (3,'LIA 1',NULL,NULL);

INSERT INTO T_JLOKAL
(Lokal_id, Lokalnamn,Vaningsplan,Maxdeltagare)
VALUES (4,'Examensarbete',NULL,NULL);


--
-- T_KURS (6)
--


INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES (1,'Databaser',20,'2013-10-07','2013-11-01',1,1);

INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES (2,'Systemutveckling, utvecklingsverktyg, miljöer',25,'2013-11-04','2013-12-06',1,2);

INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES (3,'LIA 1',5,'2013-12-09','2013-12-13',1,3);

INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES (4,'Programmering block 2',45,'2014-01-06','2014-03-07',1,1);

INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES (5,'Examensarbete',25,'2014-03-10','2014-06-13',1,4);

INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES (6,'LIA 2',45,'2014-03-31','2014-05-30',1,3);




--
-- T_LARARE (7)
--


INSERT INTO T_LARARE
(Larar_id, Lon, Kontakt_id)
VALUES (1,50000.00,4);

INSERT INTO T_LARARE
(Larar_id, Lon, Kontakt_id)
VALUES (2,45000.00,2);

INSERT INTO T_LARARE
(Larar_id, Lon, Kontakt_id)
VALUES (3,100000.00,3);


--
-- T_KOMPET (8)
--


INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES (1,'COBOL-programmering');

INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES (2,'Projektledning');

INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES (3,'IT-säkerhet');

INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES (4,'Webbutveckling');

INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES (5,'Redovisninghsekonomi');

INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES (6,'Databaser');

--
-- T_KURLAR (9)
--



INSERT INTO T_KURLAR
(Kurs_id,Larar_id)
VALUES (1,1);

INSERT INTO T_KURLAR
(Kurs_id,Larar_id)
VALUES (2,1);

INSERT INTO T_KURLAR
(Kurs_id,Larar_id)
VALUES (4,1);

INSERT INTO T_KURLAR
(Kurs_id,Larar_id)
VALUES (5,1);

INSERT INTO T_KURLAR
(Kurs_id,Larar_id)
VALUES (1,3);

--
-- T_LARKOM (10)
--



INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (1,1);

INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (1,2);

INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (2,1);

INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (2,3);
INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (3,5);

INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (3,4);

INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES (1,6);

--
-- T_BETYG
--


INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES ('VG',1,1);

INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES ('VG',2,1);

INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES ('VG',1,2);

INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES ('G',2,2);

INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES ('VG',1,3);

INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES ('VG',2,3);

--
-- Add all foreign key (FK) constraints
--

ALTER TABLE T_UTBILD ADD CONSTRAINT utbild_ort_id_fk
	FOREIGN KEY (Ort_id) REFERENCES T_ORT(Ort_id);
  
ALTER TABLE T_ELEV ADD CONSTRAINT elev_kontakt_id_fk
	FOREIGN KEY(Kontakt_id) REFERENCES T_KONTAK(Kontakt_id);

ALTER TABLE T_ELEV ADD CONSTRAINT elev_utbild_id_fk
    FOREIGN KEY(Utbild_id) REFERENCES T_UTBILD(Utbild_id);
 
ALTER TABLE T_KURS ADD CONSTRAINT kurs_utbild_id_fk
	FOREIGN KEY (Utbild_id) REFERENCES T_UTBILD(Utbild_id);

ALTER TABLE T_KURS ADD CONSTRAINT kurs_lokal_id_fk
	FOREIGN KEY (Lokal_id) REFERENCES T_JLOKAL(Lokal_id);

ALTER TABLE T_LARARE ADD CONSTRAINT larare_kontakt_id_fk
	FOREIGN KEY(Kontakt_id) REFERENCES T_KONTAK(Kontakt_id);

ALTER TABLE T_KURLAR ADD CONSTRAINT kurlar_kurs_id_fk
    FOREIGN KEY(Kurs_id) REFERENCES T_KURS(Kurs_id);
  
ALTER TABLE T_KURLAR ADD CONSTRAINT kurlar_larar_id_fk
	FOREIGN KEY (Larar_id) REFERENCES T_LARARE(Larar_id);

ALTER TABLE T_LARKOM ADD CONSTRAINT larkom_larar_id_fk
	FOREIGN KEY (Larar_id) REFERENCES T_LARARE(Larar_id);

ALTER TABLE T_LARKOM ADD CONSTRAINT larkom_kompetens_id_fk
	FOREIGN KEY(Kompetens_id) REFERENCES T_KOMPET(Kompetens_id);

ALTER TABLE T_BETYG ADD CONSTRAINT betyg_kurs_id_fk
	FOREIGN KEY(Kurs_id) REFERENCES T_KURS(Kurs_id);

ALTER TABLE T_BETYG ADD CONSTRAINT betyg_elev_id_fk
	FOREIGN KEY(Elev_id) REFERENCES T_ELEV(Elev_id);
