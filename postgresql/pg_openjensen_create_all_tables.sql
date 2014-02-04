

-- This file populates (as user postgres) openjensen database with:
--
-- $ psql -d openjensen -U jensen -f pg_openjensen_create_all_tables.sql
--
-- Before creating all tables, run drop script (to remove old tables)

-- Creation order is defined by FK constraints (but we load FK's
-- at the end, and in this case the creation order is not important)


--
-- (A) Emilio tbl_user
--

CREATE TABLE tbl_user (
    user_id int NOT NULL,
    user_firstname varchar(255) NOT NULL,
    user_lastname varchar(255) NOT NULL,
    user_email varchar(255) NOT NULL,
    user_phonenumber varchar(255) NOT NULL,
    user_username varchar(255) NOT NULL,
    user_password varchar(255) NOT NULL,
    user_lastlogin timestamp NOT NULL,
    usertype_id int NOT NULL,
    user_program int NOT NULL,
    CONSTRAINT e_tbl_user_pk PRIMARY KEY (user_id)
)
;


--
-- (B) Emilio tbl_program
--

CREATE TABLE tbl_program (
  program_id int NOT NULL,
  program_name varchar(255) NOT NULL,
  program_startdate timestamp NOT NULL,
  program_enddate timestamp NOT NULL,
  CONSTRAINT e_tbl_program_pk PRIMARY KEY (program_id)
)
;


--
-- (C) Emilio tbl_usertype
--

CREATE TABLE tbl_usertype (
  usertype_id int NOT NULL,
  usertype_name varchar(255) NOT NULL,
  usertype_rights int  NOT NULL,
  CONSTRAINT e_tbl_usertype_pk PRIMARY KEY (usertype_id)
)
;


--
-- (D) Emilio tbl_grade
--

CREATE TABLE tbl_grade (
  grade_id int NOT NULL,
  grade_grade varchar(100) NOT NULL,
  grade_comment varchar(255) NOT NULL,
  user_id int NOT NULL,
  course_id int NOT NULL,
  CONSTRAINT e_tbl_grade_pk PRIMARY KEY (grade_id)
)
;


--
-- (E) Emilio tbl_course
--


CREATE TABLE tbl_course (
  course_id int NOT NULL,
  course_name varchar(255) NOT NULL,
  course_startdate timestamp NOT NULL,
  course_enddate timestamp NOT NULL,
  program_id int NOT NULL,
  CONSTRAINT e_tbl_course_pk PRIMARY KEY (course_id)
)
;


--
-- T_KONTAK (1)
--

CREATE TABLE T_KONTAK (
	Kontakt_id	INTEGER NOT NULL,
	Fornamn CHAR(40) NOT NULL,
	Efternamn CHAR(40) NOT NULL,	
	Gatunamn	CHAR(40),
	Gatunummer CHAR(40),
	Postnummer CHAR(5),
	Postort CHAR(40),
	Email CHAR(40) NOT NULL,
	Arbetstfn CHAR(40),
	Mobiltfn CHAR(40),
	Hemtfn	CHAR(40),
	/* Primary key */
	CONSTRAINT t_kontakt_pk PRIMARY KEY(Kontakt_id)
)
;


--
-- T_ORT (2)
--

CREATE TABLE T_ORT (
	Ort_id INTEGER NOT NULL,
	Enhetsnamn CHAR(40) NOT NULL,
	Gatunamn	CHAR(40),
	Gatunummer CHAR(40),
	Postnummer CHAR(5),
	Postort CHAR(40),
	Email CHAR(40),
	Arbetstfn CHAR(40),
	/* Primary key */
	CONSTRAINT t_ort_pk PRIMARY KEY(Ort_id)
)
;


--
-- T_UTBILD (3)
--

CREATE TABLE T_UTBILD (
	Utbild_id INTEGER NOT NULL,
	Utbildning CHAR(40) NOT NULL,
	Ort_id INTEGER NOT NULL,
	Startdatum DATE,
	/* Primary key */
	CONSTRAINT t_utbild_pk PRIMARY KEY (Utbild_id)
)
;


--
-- T_ELEV (4)
--


CREATE TABLE T_ELEV (
	Elev_id INTEGER NOT NULL,
    Personnummer CHAR(12) NOT NULL,
	Utbildningsniva CHAR(40),
	Klass CHAR(40) NOT NULL,
	Slutbetyg CHAR(40),
	Utbild_id INTEGER NOT NULL,
	Kontakt_id INTEGER NOT NULL,
	/* Primary key */
	CONSTRAINT t_elev_pk PRIMARY KEY(Elev_id)
)
;

--
-- T_JLOKAL (5)
--

CREATE TABLE T_JLOKAL (
	Lokal_id INTEGER NOT NULL,
	Lokalnamn CHAR(40) UNIQUE NOT NULL,
	Vaningsplan CHAR(40),
	Maxdeltagare CHAR(40),
	/* Primary key */
	CONSTRAINT t_jlokal_pk PRIMARY KEY (Lokal_id)
)
;


--
-- KURS_T (6)
--

CREATE TABLE T_KURS (
	Kurs_id INTEGER NOT NULL,
	Kursnamn CHAR(60) NOT NULL,
	Poang	INTEGER,
	Startdatum DATE,
	Slutdatum	DATE,
	Utbild_id INTEGER NOT NULL,
	Lokal_id INTEGER NOT NULL,
	/* Primary key */
	CONSTRAINT t_kurs_pk PRIMARY KEY (Kurs_id)
)
;


--
-- T_LARARE (7)
--


CREATE TABLE T_LARARE (
	Larar_id INTEGER NOT NULL,
	Lon DECIMAL (10,2),
	Kontakt_id INTEGER NOT NULL,
	/* Primary key */
	CONSTRAINT t_larare_pk PRIMARY KEY (Larar_id)
)
;


--
-- T_KOMPET (8)
--

CREATE TABLE T_KOMPET (
	Kompetens_id INTEGER NOT NULL,
	Kompetens CHAR(40) NOT NULL,
	/* Primary key */
	CONSTRAINT t_kompet_pk PRIMARY KEY (Kompetens_id)
)
;


--
-- T_KURLAR (9)
--

CREATE TABLE T_KURLAR (
	Kurs_id INTEGER NOT NULL,
	Larar_id INTEGER NOT NULL,
	/* Primary key */
	CONSTRAINT t_kurlar_pk PRIMARY KEY(Kurs_id,Larar_id)
)
;


--
-- T_LARKOM (10)
--

CREATE TABLE T_LARKOM (
	Larar_id INTEGER NOT NULL,
	Kompetens_id INTEGER NOT NULL,
	/* Primary key */
	CONSTRAINT t_larkom_pk PRIMARY KEY(Larar_id,Kompetens_id)
)
;


--
-- T_BETYG (11)
--

CREATE TABLE T_BETYG (
	Betyg CHAR(40),
	Kurs_id INTEGER NOT NULL,
	Elev_id INTEGER NOT NULL,
	/* Primary key */
	CONSTRAINT t_betyg_pk PRIMARY KEY(Kurs_id,Elev_id)
)
;


--
-- T_NYHETER (12)
--

CREATE TABLE T_NYHETER
(
   News_id INTEGER NOT NULL,
   News_title CHAR(255) NOT NULL,
   News_content TEXT NOT NULL,
   News_date DATE NOT NULL,
   News_author INTEGER NOT NULL,
   /* Primary key */
   CONSTRAINT pk_nyheter PRIMARY KEY(news_id)
)
;


--
-- Add all foreign key (FK) constraints
--

ALTER TABLE T_UTBILD ADD CONSTRAINT utbild_ort_id_fk
	FOREIGN KEY (Ort_id) REFERENCES T_ORT(Ort_id)
;

ALTER TABLE T_ELEV ADD CONSTRAINT elev_kontakt_id_fk
	FOREIGN KEY(Kontakt_id) REFERENCES T_KONTAK(Kontakt_id)
;

ALTER TABLE T_ELEV ADD CONSTRAINT elev_utbild_id_fk
    FOREIGN KEY(Utbild_id) REFERENCES T_UTBILD(Utbild_id)
;

ALTER TABLE T_KURS ADD CONSTRAINT kurs_utbild_id_fk
	FOREIGN KEY (Utbild_id) REFERENCES T_UTBILD(Utbild_id)
;

ALTER TABLE T_KURS ADD CONSTRAINT kurs_lokal_id_fk
	FOREIGN KEY (Lokal_id) REFERENCES T_JLOKAL(Lokal_id)
;

ALTER TABLE T_LARARE ADD CONSTRAINT larare_kontakt_id_fk
	FOREIGN KEY(Kontakt_id) REFERENCES T_KONTAK(Kontakt_id)
;

ALTER TABLE T_KURLAR ADD CONSTRAINT kurlar_kurs_id_fk
    FOREIGN KEY(Kurs_id) REFERENCES T_KURS(Kurs_id)
;

ALTER TABLE T_KURLAR ADD CONSTRAINT kurlar_larar_id_fk
	FOREIGN KEY (Larar_id) REFERENCES T_LARARE(Larar_id)
;

ALTER TABLE T_LARKOM ADD CONSTRAINT larkom_larar_id_fk
	FOREIGN KEY (Larar_id) REFERENCES T_LARARE(Larar_id)
;

ALTER TABLE T_LARKOM ADD CONSTRAINT larkom_kompetens_id_fk
	FOREIGN KEY(Kompetens_id) REFERENCES T_KOMPET(Kompetens_id)
;

ALTER TABLE T_BETYG ADD CONSTRAINT betyg_kurs_id_fk
	FOREIGN KEY(Kurs_id) REFERENCES T_KURS(Kurs_id)
;

ALTER TABLE T_BETYG ADD CONSTRAINT betyg_elev_id_fk
	FOREIGN KEY(Elev_id) REFERENCES T_ELEV(Elev_id)
;

ALTER TABLE T_NYHETER ADD CONSTRAINT fk_news_author
    FOREIGN KEY (news_author) REFERENCES T_KONTAK(kontakt_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
;