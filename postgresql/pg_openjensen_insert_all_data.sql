--
-- Drop all foreign constraints (future tables)
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

ALTER TABLE T_NYHETER DROP CONSTRAINT fk_news_author ;

--
-- Drop all foreign constraints (current tables)
--

ALTER TABLE tbl_user DROP CONSTRAINT fk_user_usertype_id ;


ALTER TABLE tbl_user DROP CONSTRAINT fk_user_user_program ;


ALTER TABLE tbl_grade DROP CONSTRAINT fk_grade_user_id ;


ALTER TABLE tbl_grade DROP CONSTRAINT fk_grade_course_id ;


ALTER TABLE tbl_course DROP CONSTRAINT fk_course_program_id ;


ALTER TABLE tbl_news DROP CONSTRAINT fk_news_news_author ;


--
-- tbl_user
--

INSERT INTO tbl_user (user_id, user_firstname, user_lastname, user_email, user_phonenumber, user_username, user_password, user_lastlogin, usertype_id, user_program)
VALUES
(1, 'Samuel', 'Johansson', 'samuel@example.com', '070123123', 'samuel', 'samuel', '2013-12-18', 2, 1),
(2, 'Robert', 'Karlsson', 'robertk@example.com', '070321321', 'robert', 'robert', '2013-12-18', 2, 1),
(3, 'Pelle', 'Pellsson', 'pellep@example.com', '070333333', 'ppp', 'ppp', '2013-12-19', 1, 2),
(4, 'Bosse', 'Boss', 'bosse@example.com', '070444444', 'bbb', 'bbb', '1970-01-01', 1, 1),
(5, 'Mia', 'Yoo', 'miay@example.com', '070555555', 'mmm', 'mmm', '1970-01-01', 1, 1),
(6, 'Frida', 'Falkman', 'fridaf@example.com', '070666666', 'fff', 'fff', '1970-01-01', 1, 2),
(7, 'Woody', 'Wood', 'woodyw@example.com', '070777777', 'www', 'www', '1970-01-01', 1, 2),
(8, 'Elin', 'Testsson', 'elint@example.com', '070888888', 'eee', 'eee', '1970-01-01', 3, 2),
(9, 'Jens', 'Jensen', 'jensj@example.com', '070999999', 'jjj', 'jjj', '1970-01-01', 4, 2)
;


--
-- tbl_program
--

INSERT INTO tbl_program (program_id, program_name, program_startdate, program_enddate)
VALUES
(1, 'Webbutvecklare', '2013-11-26', '2014-08-27'),
(2, 'IT-projektledare', '2014-01-01', '2014-12-18')
;


--
-- tbl_usertype
--

INSERT INTO tbl_usertype (usertype_id, usertype_name, usertype_rights)
VALUES
(1, 'Elev', 1),
(2, 'Lärare', 2),
(3, 'Utbildningsledare', 4),
(4, 'Administratör', 16)
;


--
-- tbl_grade
--

INSERT INTO tbl_grade (grade_id, grade_grade, grade_comment, user_id, course_id)
VALUES
(1, 'G', 'Frida lite mer flit snart blir det VG', 6, 3),
(2, 'VG', 'Woody du har jobbat bra', 7, 3),
(3, 'VG', 'Pelle ett test betyg', 3, 3),
(8, 'IG', 'Inte bra Bosse', 4, 1)
;


--
-- tbl_course
--


INSERT INTO tbl_course (course_id, course_name, course_startdate, course_enddate, program_id)
VALUES
(1, 'Programmeringskunskaper', '2013-11-26', '2014-03-26', 1),
(2, 'Webblogik', '2014-03-30', '2014-06-26', 1),
(3, 'Systemutvecklingsprojekt', '2014-01-01', '2014-06-30', 2),
(4, 'Integrationsprojekt', '2014-07-01', '2014-12-31', 2)
;


--
-- tbl_news
--

INSERT INTO tbl_news
(news_id, news_title, news_content, news_date, news_author)
VALUES
(3, 'Nyhet1', 'Bacon ipsum dolor sit amet kielbasa hamburger cow pork. Cow ham jowl kevin swine. Doner filet mignon tail pork belly sausage beef ribs spare ribs shankle brisket sirloin pastrami kevin cow kielbasa jerky. Beef ribs cow spare ribs, t-bone andouille ground round prosciutto swine sausage. Swine meatball pastrami, beef tenderloin ham hock shank shankle rump strip steak beef ribs turducken fatback hamburger ribeye. Ham bresaola shoulder pork chop, sausage meatball pork rump spare ribs cow bacon filet mignon. Prosciutto pastrami pork loin, kevin kielbasa swine rump spare ribs beef ribs strip steak pork chop pork frankfurter sausage ground round.', '2014-02-25', 2)
;


--
-- T_KONTAK (1)
--


INSERT INTO T_KONTAK
(Kontakt_id, Fornamn, Efternamn, Gatunamn, Gatunummer,Postnummer,Postort,Email,Arbetstfn,Mobiltfn,Hemtfn)
VALUES
(1, 'Bert','Kronqvist','Dalagatan','25','14976','Värmdö','bert.kronqvist@gmail.com','0702401800',NULL,NULL),
(2, 'Karl','Kalkyl','Sveavägen','100','10254','Stockholm','karl.kalkyl@hotmail.com','076123456',NULL,'08123456'),
(3, 'Albert','Einstein','Pedalvägen','14','16123','Bromma','albert@yahoo.se','077123456','070234156','08987654'),
(4, 'Elisabeth','Land','Cobolstigen','64','17123','Sundbyberg','elisabeth@land.se','0705331058',NULL,NULL),
(5, 'Karl','Pedal','Karlbergsvägen','100','10712','Stockholm','kp@yahoo.se','0721234665',NULL,'08104123'),
(6, 'Filip','Svensson','Hästhagsvägen','34','16327','Spånga','filip@gmail.com','073222134',NULL,NULL),
(7, 'Pernilla','Grön','Jerntorget','4','41234','Göteborg','pgrön@yahoo.se','078132156',NULL,'031232456'),
(8, 'Pernilla','Blå','Olympiabacken','11','32156','Malmö','pbla@hotmail.com','0719998456',NULL,NULL),
(9, 'Kurt','Fellow','Vasagatan', '12', '11026','Stockholm','kfellow@gmail.com',NULL,'0701261254',NULL)
;


--
-- T_ORT (2)
--


INSERT INTO T_ORT
(Ort_id,Enhetsnamn,Gatunamn,Gatunummer,Postnummer,Postort,Email,Arbetstfn)
VALUES
(1,'Jensen Yrkeshögskola Stockholm','Karlbergsvägen', '77','11335','Stockholm','info@jensenyrkeshogskola.se','084502220'),
(2,'Jensen Yrkeshögskola Göteborg','Stora Nygatan', '23-25','41108','Göteborg','mella.stegs@jenseneducation.se','0107095078'),
(3,'Jensen Yrkeshögskola Malmö','Stadiongatan', '67','21767','Malmö','martin.wesseloh@jenseneducation.se','0107095067')
;

--
-- T_UTBILD (3)
--


INSERT INTO T_UTBILD
(Utbild_id, Utbildning,ort_id,Startdatum)
VALUES
(1,'COBOL-programmerare',1,'2013-08-21'),
(2,'Redovisningsekonom',2,'2013-08-21'),
(3,'Webbutvecklare',1,'2013-08-21'),
(4,'Certifierad IT-projektledare',1,'2013-08-21'),
(5,'Redovisningsekonom',3,'2014-01-14'),
(6,'COBOL-programmerare',1,'2014-08-21'),
(7,'Redovisningsekonom',2,'2014-08-21'),
(8,'Webbutvecklare',1,'2014-08-21'),
(9,'Certifierad IT-projektledare',1,'2014-08-21')
;

--
-- T_ELEV (4)
--


INSERT INTO T_ELEV
(Elev_id,Personnummer,Utbildningsniva,Klass,Slutbetyg,Utbild_id,Kontakt_id)
VALUES
(1,'196702081234','Högskola','CBKaug13',NULL,1,1),
(2,'196602071234','Universitet','CBKaug13',NULL,1,5),
(3,'199802071234','Gymnasieskola','CBKaug13',NULL,1,6),
(4,'198002071244','Gymnasieskola','REGaug13',NULL,2,7),
(5,'198802071244','Högskola','REMaug13',NULL,3,8),
(6,'196012012275','Högskola','CBKaug12','VG',1,9)
;

--
-- T_JLOKAL (5)
--


INSERT INTO T_JLOKAL
(Lokal_id, Lokalnamn,Vaningsplan,Maxdeltagare)
VALUES
(1,'S41','4','35'),
(2,'S42','4','40'),
(3,'LIA 1',NULL,NULL),
(4,'Examensarbete',NULL,NULL)
;

--
-- T_KURS (6)
--


INSERT INTO T_KURS
(Kurs_id, Kursnamn,Poang,Startdatum,Slutdatum,Utbild_id,Lokal_id)
VALUES
(1,'Databaser',20,'2013-10-07','2013-11-01',1,1),
(2,'Systemutveckling, utvecklingsverktyg, miljöer',25,'2013-11-04','2013-12-06',1,2),
(3,'LIA 1',5,'2013-12-09','2013-12-13',1,3),
(4,'Programmering block 2',45,'2014-01-06','2014-03-07',1,1),
(5,'Examensarbete',25,'2014-03-10','2014-06-13',1,4),
(6,'LIA 2',45,'2014-03-31','2014-05-30',1,3)
;



--
-- T_LARARE (7)
--


INSERT INTO T_LARARE
(Larar_id, Lon, Kontakt_id)
VALUES
(1,50000.00,4),
(2,45000.00,2),
(3,100000.00,3)
;

--
-- T_KOMPET (8)
--


INSERT INTO T_KOMPET
(Kompetens_id, Kompetens)
VALUES
(1,'COBOL-programmering'),
(2,'Projektledning'),
(3,'IT-säkerhet'),
(4,'Webbutveckling'),
(5,'Redovisninghsekonomi'),
(6,'Databaser')
;

--
-- T_KURLAR (9)
--



INSERT INTO T_KURLAR
(Kurs_id,Larar_id)
VALUES
(1,1),
(2,1),
(4,1),
(5,1),
(1,3)
;

--
-- T_LARKOM (10)
--



INSERT INTO T_LARKOM
(Larar_id,Kompetens_id)
VALUES
(1,1),
(1,2),
(2,1),
(2,3),
(3,5),
(3,4),
(1,6)
;

--
-- T_BETYG
--


INSERT INTO T_BETYG
(Betyg,Kurs_id,Elev_id)
VALUES
('VG',1,1),
('VG',2,1),
('VG',1,2),
('G',2,2),
('VG',1,3),
('VG',2,3)
;


--
-- T_NYHETER
--


INSERT INTO T_NYHETER
(News_id, News_title, News_content, News_date, News_author)
VALUES
(3, 'Nyhet1', 'Bacon ipsum dolor sit amet kielbasa hamburger cow pork. Cow ham jowl kevin swine. Doner filet mignon tail pork belly sausage beef ribs spare ribs shankle brisket sirloin pastrami kevin cow kielbasa jerky. Beef ribs cow spare ribs, t-bone andouille ground round prosciutto swine sausage. Swine meatball pastrami, beef tenderloin ham hock shank shankle rump strip steak beef ribs turducken fatback hamburger ribeye. Ham bresaola shoulder pork chop, sausage meatball pork rump spare ribs cow bacon filet mignon. Prosciutto pastrami pork loin, kevin kielbasa swine rump spare ribs beef ribs strip steak pork chop pork frankfurter sausage ground round.', '2014-02-25', 2)
;


    
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
        
ALTER TABLE T_NYHETER ADD CONSTRAINT fk_news_author
    FOREIGN KEY (news_author) REFERENCES T_KONTAK(kontakt_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION;
    

-------------------------------------------------------------------
--
-- Current applied foreign constraints
--
-------------------------------------------------------------------

ALTER TABLE tbl_user ADD CONSTRAINT fk_user_usertype_id
    FOREIGN KEY (usertype_id) REFERENCES tbl_usertype(usertype_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;

ALTER TABLE tbl_user ADD CONSTRAINT fk_user_user_program
    FOREIGN KEY (user_program) REFERENCES tbl_program(program_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;

ALTER TABLE tbl_grade ADD CONSTRAINT fk_grade_user_id
    FOREIGN KEY (user_id) REFERENCES tbl_user(user_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;

ALTER TABLE tbl_grade ADD CONSTRAINT fk_grade_course_id
    FOREIGN KEY (course_id) REFERENCES tbl_course(course_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;

ALTER TABLE tbl_course ADD CONSTRAINT fk_course_program_id
    FOREIGN KEY (program_id) REFERENCES tbl_program(program_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;

ALTER TABLE tbl_news ADD CONSTRAINT fk_news_news_author
    FOREIGN KEY (news_author) REFERENCES tbl_user(user_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;