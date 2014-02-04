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

ALTER TABLE T_NYHETER DROP CONSTRAINT fk_news_author ;


--
-- Drop Emilio tbl_user
--

ALTER TABLE tbl_user DROP CONSTRAINT e_tbl_user_pk ;

DROP TABLE tbl_user ;


--
-- Drop Emilio tbl_program
--

ALTER TABLE tbl_program DROP CONSTRAINT e_tbl_program_pk ;

DROP TABLE tbl_program ;


--
-- Drop Emilio tbl_usertype
--

ALTER TABLE tbl_usertype DROP CONSTRAINT e_tbl_usertype_pk ;

DROP TABLE tbl_usertype ;

--
-- Drop Emilio tbl_grade
--

ALTER TABLE tbl_grade DROP CONSTRAINT e_tbl_grade_pk ;

DROP TABLE tbl_grade ;


--
-- Drop Emilio tbl_course
--

ALTER TABLE tbl_course DROP CONSTRAINT e_tbl_course_pk ;

DROP TABLE tbl_course ;


--
-- Drop T_KONTAKT
--

ALTER TABLE T_KONTAK DROP CONSTRAINT t_kontakt_pk ;

DROP TABLE T_KONTAK ;

--
-- Drop T_ORT
--

ALTER TABLE T_ORT DROP CONSTRAINT t_ort_pk ;

DROP TABLE T_ORT ;

--
-- Drop T_UTBILD
--

ALTER TABLE T_UTBILD DROP CONSTRAINT t_utbild_pk ;

DROP TABLE T_UTBILD ;

--
-- Drop T_ELEV (drops also dependent objects)
--

ALTER TABLE T_ELEV DROP CONSTRAINT t_elev_pk ;

DROP TABLE T_ELEV CASCADE ;


--
-- Drop T_JLOKAL
--

ALTER TABLE T_JLOKAL DROP CONSTRAINT t_jlokal_pk ;

DROP TABLE T_JLOKAL ;

--
-- Drop T_KURS
--

ALTER TABLE T_KURS DROP CONSTRAINT t_kurs_pk ;

DROP TABLE T_KURS ;


--
-- Drop T_LARARE
--


ALTER TABLE T_LARARE DROP CONSTRAINT t_larare_pk ;

DROP TABLE T_LARARE ;

--
-- Drop T_KOMPET
--

ALTER TABLE T_KOMPET DROP CONSTRAINT t_kompet_pk ;

DROP TABLE T_KOMPET ;

--
-- Drop T_KURLAR
--

ALTER TABLE T_KURLAR DROP CONSTRAINT t_kurlar_pk ;

DROP TABLE T_KURLAR ;

--
-- Drop T_LARKOM
--

ALTER TABLE T_LARKOM DROP CONSTRAINT t_larkom_pk ;

DROP TABLE T_LARKOM ;


--
-- Drop T_BETYG
--

ALTER TABLE T_BETYG DROP CONSTRAINT t_betyg_pk ;

DROP TABLE T_BETYG ;


--
-- Drop T_NYHETER
--

ALTER TABLE T_NYHETER DROP CONSTRAINT pk_nyheter ;

DROP TABLE T_NYHETER ;
