Rem NAME
Rem   iOrganizer.sql
Rem 
Rem FUNCTION
Rem   Create and populate tables and sequences to support the iOrganizer 
Rem   business scenario.  
Rem NOTES
Rem 
Rem MODIFIED 
Rem     PGIBERT@US.ORACLE.COM
Rem	  PKRUEGER@DE.ORACLE.COM
Rem	  DRMILLS@UK.ORACLE.COM

spool iorganizer.log

set feedback off
prompt Creating and populating tables and sequences.  Please wait.

DROP TABLE birthday CASCADE CONSTRAINTS;
DROP TABLE address_book CASCADE CONSTRAINTS;
DROP TABLE notes CASCADE CONSTRAINTS;
DROP TABLE appointment_attendees CASCADE CONSTRAINTS;
DROP TABLE appointments CASCADE CONSTRAINTS;
DROP TABLE to_do CASCADE CONSTRAINTS;
DROP TABLE frequency_classifications CASCADE CONSTRAINTS;
DROP TABLE category CASCADE CONSTRAINTS;
DROP TABLE users CASCADE CONSTRAINTS;

DROP SEQUENCE birthday_id;
DROP SEQUENCE address_book_id;
DROP SEQUENCE appointments_pk_id;
DROP SEQUENCE appointments_id;
DROP SEQUENCE users_id;
DROP SEQUENCE to_do_id;
DROP SEQUENCE notes_id;

DROP PACKAGE BODY appointments_pkg;
DROP PACKAGE appointments_pkg;

CREATE SEQUENCE birthday_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 1
   NOCACHE 
   NOORDER 
   NOCYCLE;

CREATE SEQUENCE address_book_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 1
   NOCACHE 
   NOORDER 
   NOCYCLE;
CREATE SEQUENCE notes_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 1
   NOCACHE 
   NOORDER 
   NOCYCLE;
CREATE SEQUENCE appointments_pk_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 20
   NOCACHE 
   NOORDER 
   NOCYCLE;
CREATE SEQUENCE appointments_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 20
   NOCACHE 
   NOORDER 
   NOCYCLE;
CREATE SEQUENCE to_do_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 1
   NOCACHE 
   NOORDER 
   NOCYCLE;
CREATE SEQUENCE users_id
   MINVALUE 1 
   MAXVALUE 9999999 
   INCREMENT BY 1 
   START WITH 1
   NOCACHE 
   NOORDER 
   NOCYCLE;

CREATE TABLE category
(
  id    NUMBER(2) CONSTRAINT category_id_pk PRIMARY KEY,
  label VARCHAR2(30) NOT NULL
);

INSERT INTO category VALUES ( 1, 'Phone Call');
INSERT INTO category VALUES ( 2, 'Customer Visit');
INSERT INTO category VALUES ( 3, 'Expenses');
INSERT INTO category VALUES ( 4, 'Ideas');
INSERT INTO category VALUES ( 5, 'Public Holiday');
INSERT INTO category VALUES ( 6, 'Personal');
INSERT INTO category VALUES ( 7, 'People');
INSERT INTO category VALUES ( 8, 'Projects');
INSERT INTO category VALUES ( 9, 'Questions');
INSERT INTO category VALUES ( 10, 'Internal Meeting');
INSERT INTO category VALUES ( 11, 'Follow up');
INSERT INTO category VALUES ( 12, 'Holidays');
INSERT INTO category VALUES ( 13, 'Business Trip');
INSERT INTO category VALUES ( 14, 'Training');
INSERT INTO category VALUES ( 15, 'Event/Tradeshow');
INSERT INTO category VALUES ( 16, '1 to 1');
INSERT INTO category VALUES ( 17, 'Group Meeting');

CREATE TABLE frequency_classifications
( id               NUMBER(4) CONSTRAINT frequency_classifications_pk PRIMARY KEY,
  label            VARCHAR2(40) NOT NULL,
  display_order    NUMBER(4),
  calculate_in     VARCHAR2(1),
  interval         NUMBER(4),
  shortlist        VARCHAR2(1),
  absolute         VARCHAR2(1),
  calculate_from   VARCHAR2(1),
  offset_day       NUMBER(4)
);

INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 0,  'Non-Repeating',                       0, NULL, NULL, 'Y', NULL, NULL, NULL);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 1,  'Daily',                               1, 'D', 1,  'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 2,  'Weekly',                              2, 'D', 7,  'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 3,  'Monthly',                             3, 'M', 1,  'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 4,  'Quarterly',                           4, 'M', 3,  'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 5,  'Twice a Year',                        5, 'M', 6,  NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 6,  'Every other week',                    6, 'D', 14, 'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 7,  'Every three weeks',                   7, 'D', 21, NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 8,  'Every four weeks',                    8, 'D', 28, NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 9,  'Every five weeks',                    9, 'D', 35, NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 10, 'Every six weeks',                    10, 'D', 42, NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 11, 'Every seven weeks',                  11, 'D', 49, NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 12, 'Every eight weeks',                  12, 'D', 56, NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 13, 'Every other month',                  13, 'M', 2,  'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 14, 'Every three months',                 14, 'M', 3,  NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 15, 'Every four months',                  15, 'M', 4,  NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 16, 'Every five months',                  16, 'M', 5,  NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 17, 'Every 6 months',                     17, 'M', 6,  NULL, 'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 18, 'Every other quarter',                18, 'M', 3,  'Y',  'N', NULL, NULL); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 19, 'The first Monday of the month',      19, 'D', 0,  'Y',  'Y', 'M',  2); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 20, 'The second Monday of the month',     20, 'D', 7,  NULL, 'Y', 'M',  2); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 21, 'The third Monday of the month',      21, 'D', 14, NULL, 'Y', 'M',  2); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 22, 'The fourth Monday of the month',     22, 'D', 21, NULL, 'Y', 'M',  2); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 23, 'The first Tuesday of the month',     23, 'D', 0,  'Y',  'Y', 'M',  3); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 24, 'The second Tuesday of the month',    24, 'D', 7,  NULL, 'Y', 'M',  3); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 25, 'The third Tuesday of the month',     25, 'D', 14, NULL, 'Y', 'M',  3); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 26, 'The fourth Tuesday of the month',    26, 'D', 21, NULL, 'Y', 'M',  3); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 27, 'The first Wednesday of the month',   27, 'D', 0,  'Y',  'Y', 'M',  4); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 28, 'The second Wednesday of the month',  28, 'D', 7,  NULL, 'Y', 'M',  4); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 29, 'The third Wednesday of the month',   29, 'D', 14, NULL, 'Y', 'M',  4); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 30, 'The fourth Wednesday of the month',  30, 'D', 21, NULL, 'Y', 'M',  4); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 31, 'The first Thursday of the month',    31, 'D', 0,  'Y',  'Y', 'M',  5); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 32, 'The second Thursday of the month',   32, 'D', 7,  NULL, 'Y', 'M',  5); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 33, 'The third Thursday of the month',    33, 'D', 14, NULL, 'Y', 'M',  5); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 34, 'The fourth Thursday of the month',   34, 'D', 21, NULL, 'Y', 'M',  5); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 35, 'The first Friday of the month',      35, 'D', 0,  'Y',  'Y', 'M',  6); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 36, 'The second Friday of the month',     36, 'D', 7,  NULL, 'Y', 'M',  6); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 37, 'The third Friday of the month',      37, 'D', 14, NULL, 'Y', 'M',  6); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 38, 'The fourth Friday of the month',     38, 'D', 21, NULL, 'Y', 'M',  6); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 39, 'The first Saturday of the month',    39, 'D', 0,  'Y',  'Y', 'M',  7); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 40, 'The second Saturday of the month',   40, 'D', 7,  NULL, 'Y', 'M',  7); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 41, 'The third Saturday of the month',    41, 'D', 14, NULL, 'Y', 'M',  7); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 42, 'The fourth Saturday of the month',   42, 'D', 21, NULL, 'Y', 'M',  7); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 43, 'The first Sunday of the month',      43, 'D', 0,  'Y',  'Y', 'M',  1); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 44, 'The second Sunday of the month',     44, 'D', 7,  NULL, 'Y', 'M',  1); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 45, 'The third Sunday of the month',      45, 'D', 14, NULL, 'Y', 'M',  1); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 46, 'The fourth Sunday of the month',     46, 'D', 21, NULL, 'Y', 'M',  1); 
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 47, 'The first Monday of the quarter',    47, 'D', 0,  NULL, 'Y', 'Q',  2);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 48, 'The first Tuesday of the quarter',   48, 'D', 0,  NULL, 'Y', 'Q',  3);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 49, 'The first Wednesday of the quarter', 49, 'D', 0,  NULL, 'Y', 'Q',  4);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 50, 'The first Thursday of the quarter',  50, 'D', 0,  NULL, 'Y', 'Q',  5);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 51, 'The first Friday of the quarter',    51, 'D', 0,  NULL, 'Y', 'Q',  6);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 52, 'The first Saturday of the quarter',  52, 'D', 0,  NULL, 'Y', 'Q',  7);
INSERT INTO FREQUENCY_CLASSIFICATIONS ( ID, LABEL, DISPLAY_ORDER, CALCULATE_IN, INTERVAL, SHORTLIST,ABSOLUTE, CALCULATE_FROM, OFFSET_DAY ) VALUES ( 53, 'The first Sunday of the quarter',    53, 'D', 0,  NULL, 'Y', 'Q',  1);

CREATE TABLE users
( id         NUMBER(4) CONSTRAINT users_id_pk PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL,
  userid     VARCHAR2(10) NOT NULL,
  email      VARCHAR2(30) NOT NULL,
  password   VARCHAR2(20) NOT NULL,
  phone      VARCHAR2(20));

INSERT INTO users VALUES( users_id.nextval, 'Guest', 'Guest', 'GUEST', 'guest@us.oracle.com', 'GUEST', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Pascal', 'Gibert', 'PGIBERT', 'pgibert@us.oracle.com', 'PGIBERT', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Candace', 'Stover', 'CSTOVER', 'cstover@us.oracle.com', 'CSTOVER', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Steve', 'Button', 'SBUTTON', 'sbutton@us.oracle.com', 'SBUTTON', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Duncan', 'Mills', 'DRMILLS', 'drmills@uk.oracle.com', 'DRMILLS', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Regis', 'Louis', 'RLOUIS', 'rlouis@us.oracle.com', 'RLOUIS', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Frank', 'Nimphius', 'FNIMPHIUS', 'fnimphiu@de.oracle.com', 'FNIMPHIUS', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Juliana', 'Lerc', 'JLERC', 'jlerc@us.oracle.com', 'JLERC', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Daryl', 'Porter', 'DPORTER', 'dporter@us.oracle.com', 'DPORTER', NULL);
INSERT INTO users VALUES( users_id.nextval, 'Tim', 'Eicher', 'TEICHER', 'teicher@us.oracle.com', 'TEICHER', NULL);

CREATE TABLE to_do
( id            NUMBER(4) CONSTRAINT to_do_id_pk PRIMARY KEY,
  subject       VARCHAR2(50) NOT NULL,
  priority      NUMBER(1),
  due_date      DATE,
  description   VARCHAR2(2000),
  date_creation DATE,
  user_id       NUMBER(4)CONSTRAINT to_do_user_id_fk REFERENCES users(id),
  completed     CHAR(1)
);

CREATE TABLE notes 
( id			NUMBER(4) CONSTRAINT notes_id_pk PRIMARY KEY,
  subject         VARCHAR2(50) NOT NULL,
  note            VARCHAR2(2000),
  create_date     date,
  user_id         NUMBER(4) CONSTRAINT notes_user_id_fk REFERENCES users(id),
  category_id     NUMBER(2) CONSTRAINT notes_category_id_fk REFERENCES category(id)
);            

CREATE TABLE appointments
( id                        NUMBER(4)  CONSTRAINT appointments_id_pk PRIMARY KEY,
  parent_appt_id            NUMBER(4)  CONSTRAINT appointments_id_self REFERENCES appointments(id),
  start_date                DATE,
  end_date                  DATE,
  start_time                DATE,
  end_time                  DATE,
  appt_type                 NUMBER(2) CONSTRAINT appointments_appt_type_fk REFERENCES category(id),
  short_desc                VARCHAR2(50),
  long_desc                 VARCHAR2(2000),
  remind_me                 NUMBER(4),
  frequency_id              NUMBER(4) CONSTRAINT appointments_freq_fk REFERENCES frequency_classifications(id),
  workdays_only             VARCHAR2(1),
  user_id                   NUMBER(4) CONSTRAINT appointments_user_id_fk REFERENCES users(id),
  creator_id                NUMBER(4) CONSTRAINT appointments_creator_id_fk REFERENCES users(id)
);

CREATE TABLE appointment_attendees
( appointment_id     NUMBER(4) CONSTRAINT attendees_appt_id_fk REFERENCES appointments(id),
  user_id            NUMBER(4) CONSTRAINT attendees_user_id_fk REFERENCES users(id),
  reminder_interval  NUMBER(4),
  deleted_on         DATE
);

ALTER TABLE appointment_attendees ADD CONSTRAINT attendees_pk PRIMARY KEY(appointment_id, user_id);

CREATE TABLE address_book
(
  id 					NUMBER(3) CONSTRAINT address_book_id_pk PRIMARY KEY,
  title 				VARCHAR2(5),
  first_name 			VARCHAR2(20),
  last_name 			VARCHAR2(30) NOT NULL,
  position 				VARCHAR2(50),
  company_name 			VARCHAR2(50),
  business_address 		VARCHAR2(100),
  business_city 			VARCHAR2(30),
  business_state 			VARCHAR2(20),
  business_zip_code 		VARCHAR2(6),
  business_country 		VARCHAR2(20),
  business_phone 			VARCHAR2(20),
  business_fax 			VARCHAR2(20),
  business_pager 			VARCHAR2(20),
  business_mobile 		VARCHAR2(20),
  business_other_phone 		VARCHAR2(20),
  business_email 			VARCHAR2(30),
  business_assistant_name 	VARCHAR2(50),
  category_id 			NUMBER(2) CONSTRAINT address_book_category_id_fk REFERENCES category(id),
  home_address 			VARCHAR2(100),
  home_city 			VARCHAR2(30),
  home_state 			VARCHAR2(20),
  home_zip_code 			VARCHAR2(6),
  home_country 			VARCHAR2(20),
  home_phone 			VARCHAR2(20),
  home_fax 				VARCHAR2(20),
  home_pager 			VARCHAR2(20),
  home_mobile 			VARCHAR2(20),
  home_other_phone 		VARCHAR2(20),
  home_email 			VARCHAR2(30),
  domestic_partner 		VARCHAR2(50),
  childrens_name 			VARCHAR2(100),
  notes 				VARCHAR2(2000),
  user_id 				NUMBER(4) CONSTRAINT address_book_user_id_fk REFERENCES users(id)
);

CREATE TABLE birthday
( id         NUMBER(4) NOT NULL,
  first_name VARCHAR2(20),
  name  VARCHAR2(20),
  user_id     NUMBER NOT NULL,
  birth_date DATE);

CREATE OR REPLACE PACKAGE APPOINTMENTS_PKG AS
/*-----------------------------------------------------------------------*\
 * Name               : APPOINTMENTS_PKG
 * Description        : The Scheduling Engine for the eOrganiser
 *                      Demo
 *
 *
 * Dependencies       : None
 *----------------------------------------------------------------------
 * Public Variables   : LAST_ERROR (Error handling)
 *          (if Any)
 *----------------------------------------------------------------------
 * Author             : DRMILLS
 * Version            : 1.0
 * Change History     : 
 *        10-SEP-2001 : Creation
\*-----------------------------------------------------------------------*/

  /*---------------------------------------------------------------------*\
   * Error Handling:
   *       When encountering an error the functions in this package will
   *       set the contents of the LAST_ERROR package variables.
   *       Generally a BOOLEAN FALSE will also be returned to indicate 
   *       An Error
  \*---------------------------------------------------------------------*/
  LAST_ERROR     VARCHAR2(2000);
  
  /*---------------------------------------------------------------------*\
   * Types
  \*---------------------------------------------------------------------*/

  TYPE typUserIdList IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

 /*---------------------------------------------------------------------*\
  *---------------------------------------------------------------------
  * Functions
  *---------------------------------------------------------------------
 \*---------------------------------------------------------------------*/
  FUNCTION CorrectDate (pdDate IN DATE, pdTime IN DATE) RETURN DATE;
  
  PRAGMA RESTRICT_REFERENCES(CorrectDate, WNDS, RNDS, WNPS, RNPS); 
 
/*----------------------------------------------------------------*\
 * Name      : Schedule
 * Function  : Takes a range of dates and a parent appointment 
 *             and then creates updates or deletes children of
 *             That parent for each attendee, including the 
 *             owner
 * Overloaded: N
 *----------------------------------------------------------------
 * Arguments: pnAppointmentId  -> The Parent Appointment's ID
 *            pdDateFrom       -> The start date for calculations
 *                                we might be altering an existing 
 *                                appointment so this value might 
 *                                not be the same as any value 
 *                                stored in the parent record
 *            pdDateTo         -> The End date for the appointment
 *                                range.
 *            pdOrigEnd        -> The before image End date
 *                                in case the schedule has been 
 *                                extended.
 *            pnOrigFreq       -> The before image frequency
 *                                in case the Frequency has been
 *                                changed
  *            pnOrigWorking   -> The before image Working_days
 *                                flag in case the scheduling 
 *                                has been changed
 *----------------------------------------------------------------
 * Return Value: TRUE (BOOLEAN) if successful
\*----------------------------------------------------------------*/

  FUNCTION Schedule         ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pdOrigEnd        IN DATE,
                              pnOrigFreq       IN NUMBER,
                              pvcOrigWorking   IN VARCHAR2) RETURN BOOLEAN;


/*----------------------------------------------------------------*\
 * Name      : AddAttendee
 * Function  : Adds one or more users to an existing appointment 
 *             schedule.
 * Overloaded: Y
 *----------------------------------------------------------------
 * Arguments: pnAppointmentId  -> The Parent Appointment's ID
 *            pdDateFrom       -> The start date for calculations
 *                                we might be altering an existing 
 *                                appointment so this value might 
 *                                not be the same as any value 
 *                                stored in the parent record
 *            pdDateTo         -> The End date for the appointment
 *                                range.
 *EITHER      pnUserId         -> If adding a single user - the id
 *                                of that user.
 *OR          UserIdList       -> If adding several users, a variable
 *                                of type typUserIdList which is 
 *                                simply an array of UserIDs
 *----------------------------------------------------------------
 * Return Value: TRUE (BOOLEAN) if successful
\*----------------------------------------------------------------*/

  FUNCTION AddAttendee      ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pnUserId         IN NUMBER) RETURN BOOLEAN;

  FUNCTION AddAttendeeBulk  ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              UserIdList       IN APPOINTMENTS_PKG.typUserIdList) RETURN BOOLEAN;


/*----------------------------------------------------------------*\
 * Name      : Remove
 * Function  : Removes all child appointments from a schedule,  
 *             or just the appointments from one user, or
 *             all the appointments from a list of users
 * Overloaded: Y
 *----------------------------------------------------------------
 * Arguments: pnAppointmentId  -> The Parent Appointment's ID
 *            pdDateFrom       -> The start date for calculations
 *                                we might be altering an existing 
 *                                appointment so this value might 
 *                                not be the same as any value 
 *                                stored in the parent record
 *EITHER      (No Third Argument) All Child Appointments are 
 *                                removed.
 *OR          pnUserId         -> If removing a single user - the id
 *                                of that user.
 *OR          UserIdList       -> If removing several users, a variable
 *                                of type typUserIdList which is 
 *                                simply an array of UserIDs
 * 
 *----------------------------------------------------------------
 * Return Value: TRUE (BOOLEAN) if successful
\*----------------------------------------------------------------*/

  FUNCTION Remove           ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE) RETURN BOOLEAN;

  FUNCTION Remove           ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pnUserId         IN NUMBER) RETURN BOOLEAN;

  FUNCTION Remove           ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              UserIdList       IN APPOINTMENTS_PKG.typUserIdList) RETURN BOOLEAN;


/*----------------------------------------------------------------*\
 * Name      : CascadeReminder
 * Function  : Allows a change made to the reminder flag on one 
 *             instance of an appoinment in the schedule to be 
 *             propagated to all instances
 * Overloaded: N
 *----------------------------------------------------------------
 * Arguments: pnAppointmentId  -> The Parent Appointment's ID
 *            pdDateFrom       -> The start date for calculations
 *                                we might be altering an existing 
 *                                appointment so this value might 
 *                                not be the same as any value 
 *                                stored in the parent record
 *            pnUserId         -> The Id of the user to cascade
 *            pnReminderInt    -> The Reminder Interval (in Mins)
 *----------------------------------------------------------------
 * Return Value: TRUE (BOOLEAN) if successful
\*----------------------------------------------------------------*/
  FUNCTION CascadeReminder  ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pnUserId         IN NUMBER,
                              pnReminderInt    IN NUMBER) RETURN BOOLEAN;


/*----------------------------------------------------------------*\
 * Name      : PreviewRepeats
 * Function  : Returns a textual List of all the dates that would 
 *             generated for this date range and frequency.
 * Overloaded: N
 *----------------------------------------------------------------
 * Arguments: pdDateFrom       -> The start date for calculations
 *            pdDateTo         -> The End date for the appointment
 *                                range.
 *            pnFreqCategory   -> The frequency code
 *            pvcFormatMask    -> The mask used to display the date
 *                                in the output string
 *            bWorkingDays     -> Should the list Returned only
 *                                Include Working days?
 *                                If TRUE the Code will select the
 *                                next working day if a non-working
 *                                day is calculated
 *----------------------------------------------------------------
 * Return Value: List of Dates separated by newline characters 
 *               ASCII(10)
\*----------------------------------------------------------------*/
  FUNCTION PreviewRepeats   ( pdDateFrom           IN DATE,
                              pdDateTo             IN DATE,
                              pnFreqCategory       IN NUMBER,
                              pvcFormatMask        IN VARCHAR2 DEFAULT 'DD-MON-YYYY',
                              pbWorkingDays        IN BOOLEAN  DEFAULT TRUE) return VARCHAR2;


/*----------------------------------------------------------------*\
 * Name      : GetFirstAppt
 * Function  : Returns the first calculated date for this schedule  
 * Overloaded: N
 *----------------------------------------------------------------
 * Arguments: pdDateFrom       -> The start date for calculations
 *            pdDateTo         -> The End date for the appointment
 *                                range.
 *            pnFreqCategory   -> The frequency code
 *            bWorkingDays     -> Should the calcualtion return only
 *                                Working days?
 *                                If TRUE the Code will select the
 *                                next working day if a non-working
 *                                day is calculated
 *----------------------------------------------------------------
 * Return Value: TRUE (BOOLEAN) if successful
\*----------------------------------------------------------------*/
  FUNCTION GetFirstAppt     ( pdDateFrom           IN DATE,
                              pdDateTo             IN DATE,
                              pnFreqCategory       IN NUMBER,
                              pbWorkingDays        IN BOOLEAN DEFAULT TRUE) return DATE;


/*----------------------------------------------------------------*\
 * Name      : GetLastError
 * Function  : Returns the text of the last error 
 * Overloaded: N
 *----------------------------------------------------------------
 * Arguments: (NONE)
 *----------------------------------------------------------------
 * Return Value: Error Text (VARCHAR2)
\*----------------------------------------------------------------*/
  FUNCTION GetLastError RETURN VARCHAR2;

END APPOINTMENTS_PKG;
/

CREATE OR REPLACE PACKAGE BODY APPOINTMENTS_PKG AS

  -- Private Type declarations
  TYPE typSchedDates IS TABLE OF DATE           INDEX BY BINARY_INTEGER;
  TYPE typResources  IS TABLE of VARCHAR2(200)  INDEX BY BINARY_INTEGER;

  -- Text For Errors
  ErrorRes  typResources;
  Days      typResources;
  
-- Private Exceptions 
  exInvalidAppointment EXCEPTION;
  exNotParent          EXCEPTION;
  exInvalidRange       EXCEPTION;
  exInvalidFrequency   EXCEPTION;
  
-- Private Cursors
    CURSOR curParentInfo (piAppointment IN NUMBER) is 
           select * 
           from appointments a
           where a.id = piAppointment;
           
    CURSOR curGetFreq (pnFreqCategory IN NUMBER) is
           select f.calculate_in, f.interval,f.absolute, f.calculate_from, f.offset_day
           from   frequency_classifications f
           where  f.id = pnFreqCategory;

  -- Private Program Units
  /*---------------------------------------------------------*\
   * CheckStartdate is used to prevent us from changing 
   * history.
   * It ensures that any start date we use is either today
   * or is in the future
  \*---------------------------------------------------------*/ 
  FUNCTION CheckStartDate (pdStartDate IN DATE) RETURN DATE;
  
  FUNCTION CheckStartDate (pdStartDate IN DATE) RETURN DATE is
  BEGIN
  RETURN greatest(pdStartDate,Sysdate);
  END CheckStartDate;

  /*---------------------------------------------------------*\
   * CheckEndDate imposes our rule that you can't schedule 
   * for more than a year beyond the startdate or today
   * Which ever is the greatest
  \*---------------------------------------------------------*/ 
  FUNCTION CheckEndDate (pdStartDate IN DATE, pdEndDate IN DATE) RETURN DATE;
  
  FUNCTION CheckEndDate (pdStartDate IN DATE, pdEndDate IN DATE) RETURN DATE is
    dCeiling  DATE;
  BEGIN
    dCeiling := add_months(greatest(pdStartDate,Sysdate),12);
  RETURN least(pdEndDate,dCeiling);
  END CheckEndDate;

  /*---------------------------------------------------------*\
   * WorkingDay Rounds the supplied date to the 
   * Nearest Working day
  \*---------------------------------------------------------*/
  FUNCTION WorkingDay       ( pdTestDate       IN DATE) RETURN DATE;

  FUNCTION WorkingDay       ( pdTestDate       IN DATE) RETURN DATE is
    vcDay    VARCHAR2(10);
    dRC      DATE;
  BEGIN
    -- We can increase the complexity of this routine as required
    -- For the moment I'll just classify Saturday and Sunday  
    -- as specials
    vcDay := to_char(pdTestDate,'DAY');
    if (vcDay = Days(1)) then /* Sunday */
      dRC := pdTestDate + 1;
    elsif (vcDay = Days(7)) then /* Saturday */
      dRc := pdTestDate + 2;
    else
      dRC := pdTestDate;
    end if;
  RETURN dRC;
  END WorkingDay;

  /*---------------------------------------------------------*\
   * CalculateFreq does the hard job of providing a  
   * list of dates for a particular frequency category
  \*---------------------------------------------------------*/ 
  FUNCTION CalculateFreq    ( pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pdIgnoreBefore   IN DATE,
                              pnFreqCategory   IN NUMBER,
                              pbWorkingDays    IN BOOLEAN) return APPOINTMENTS_PKG.typSchedDates;
  
  FUNCTION CalculateFreq    ( pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pdIgnoreBefore   IN DATE,
                              pnFreqCategory   IN NUMBER,
                              pbWorkingDays    IN BOOLEAN) return APPOINTMENTS_PKG.typSchedDates is

    arrFreqs      APPOINTMENTS_PKG.typSchedDates;
    arrTempFreqs  APPOINTMENTS_PKG.typSchedDates;
    dWorkingDate  DATE := pdDateFrom;
    dThisMonth    DATE;
    vcAbsolute    VARCHAR2(1);
    bAbsolute     BOOLEAN;
    vcCalcUnits   VARCHAR2(1);
    vcCalcFrom    VARCHAR2(1);
    iInterval     PLS_INTEGER;
    iOffsetDay    PLS_INTEGER;
    iNextStart    PLS_INTEGER := 1; /* Month by default */
    iIndex        PLS_INTEGER := 0;
    bQuarters     BOOLEAN     := FALSE;
    bFirstSpecial BOOLEAN;
    iRenumber     PLS_INTEGER := 0;

  BEGIN
    if (pdDateFrom > pdDateTo) then 
      RAISE exInvalidRange;
    elsif (pdDateFrom < pdDateTo) then 
      NULL; /* continue */
    else
      if (pnFreqCategory = 0) then /* Special case of non repeating appt */
        arrFreqs(1) := pdDateFrom;
        RETURN arrFreqs;
      else
        RAISE exInvalidRange;
      end if;
    end if;
    -- Gather info about this frequency
    open APPOINTMENTS_PKG.curGetFreq(pnFreqCategory);
    fetch APPOINTMENTS_PKG.curGetFreq into vcCalcUnits, iInterval, vcAbsolute, vcCalcFrom, iOffsetDay;
    if APPOINTMENTS_PKG.curGetFreq%NOTFOUND then
      CLOSE APPOINTMENTS_PKG.curGetFreq;
      RAISE exInvalidFrequency;
    end if;
    close APPOINTMENTS_PKG.curGetFreq;

    bAbsolute := (vcAbsolute = 'Y');

        -- Are we working in Months or Quarters?
    if vcCalcFrom = 'Q' then
      bQuarters := TRUE;
      iNextStart := 3;
    end if;

    -- Now loop around until we've covered the whole date range
    <<CalcLoop>>
    while dWorkingDate <= pdDateTo LOOP

      iIndex := iIndex + 1;
      arrFreqs(iIndex) := dWorkingDate;
      if dWorkingDate >= pdDateTo then 
         EXIT CalcLoop;
      end if;

      -- Is this frequency absolute or relative?
      -- If Absolute we have to work from a different basepoint each time, not the previous date
      <<AbsOrRel>>
      if bAbsolute then 
        if dThisMonth is NULL then
          -- Work out the "Startpoint" that we have to work from
          if bQuarters then
            dThisMonth := add_months(to_date('0101'||to_char(dWorkingDate,'YYYY'),'DDMMYYYY'),((to_number(to_char(dWorkingDate,'Q')) -1) * 3));
          else
            dThisMonth := to_date(to_char(dWorkingDate,'MMYYYY'),'MMYYYY');
          end if;
        end if;

        <<FirstIteration>>
        if (iIndex = 1) then
          -- It is possible that the first matching date will fall within the same month or quarter 
          -- asthe start date on the first iteration.
          dWorkingDate := next_day((dThisMonth - 1), Days(iOffsetDay)) + (iInterval);
          
          if (dWorkingDate <= pdDateFrom) then 
            bFirstSpecial := FALSE;
          else 
            bFirstSpecial := TRUE;
          end if;
        else
          bFirstSpecial := FALSE;
        end if;
        /* <<FirstItereation>> */
        
        if (NOT bFirstSpecial) then 
          dThisMonth := add_months(dThisMonth,iNextStart);
          dWorkingDate := next_day((dThisMonth - 1), Days(iOffsetDay)) + (iInterval);
        end if;
      else /* Relative */
        if vcCalcUnits = 'D' then 
          dWorkingDate := (dWorkingDate + iInterval);
        else /* Monthly */
          dWorkingDate := add_months(dWorkingDate,iInterval);
        end if;
      end if;
      /* <<AbsOrRel>> */

    end LOOP;
    /* <<CalcLoop>> */
    
    -- Now Adjust for Working Days if required
    if (pbWorkingDays and NOT bAbsolute) then 
      for i in 1..arrFreqs.COUNT LOOP
        dWorkingDate := WorkingDay(arrFreqs(i));
        if (iRenumber > 1) and (dWorkingDate = arrTempFreqs(iRenumber)) then 
          NULL; /* Ignore this it is a duplicate */
        else
          iRenumber := iRenumber + 1;
          arrTempFreqs(iRenumber) := dWorkingDate;
        end if;
      end LOOP;
    else 
      arrTempFreqs := arrFreqs;
    end if;
    
    -- If we are extending a schedule we just need to return
    -- the new days only
    arrFreqs.DELETE;
    if (pdIgnoreBefore <> pdDateFrom) then 
      iRenumber := 0;
      for i in 1..arrTempFreqs.COUNT LOOP
        if (arrTempFreqs(i) > pdIgnoreBefore) then
          iRenumber := iRenumber + 1; 
          arrFreqs(iRenumber) := arrTempFreqs(i);
        end if;
      end LOOP;
    else
      arrFreqs := arrTempFreqs;
    end if;
    

  RETURN arrFreqs;
  END CalculateFreq;


  PROCEDURE InsertAppt (      pnParentAppt     IN NUMBER,
                              pdTargetDate     IN DATE,
                              pdStartTime      IN DATE,
                              pnDuration       IN NUMBER,
                              pnApptType       IN NUMBER,
                              pvcShortDesc     IN VARCHAR2,
                              pvcLongDesc      IN VARCHAR2,
                              pnRemindInt      IN NUMBER,
                              pnFreq           IN NUMBER,
                              pvcWorkDays      IN VARCHAR2,
                              pnAttendee       IN NUMBER,
                              pnCreator        IN NUMBER);

  PROCEDURE InsertAppt (      pnParentAppt     IN NUMBER,
                              pdTargetDate     IN DATE,
                              pdStartTime      IN DATE,
                              pnDuration       IN NUMBER,
                              pnApptType       IN NUMBER,
                              pvcShortDesc     IN VARCHAR2,
                              pvcLongDesc      IN VARCHAR2,
                              pnRemindInt      IN NUMBER,
                              pnFreq           IN NUMBER,
                              pvcWorkDays      IN VARCHAR2,
                              pnAttendee       IN NUMBER,
                              pnCreator        IN NUMBER) is
    cursor curCheckExists is 
      select 'Y' 
      from  appointments a
      where a.parent_appt_id = pnParentAppt 
      and   a.user_id       = pnAttendee
      and   a.start_date    = pdTargetDate;
    vcCheck VARCHAR2(1);
    dThisDate DATE := APPOINTMENTS_PKG.CorrectDate(pdTargetDate,pdStartTime);
  BEGIN
    -- Check that this appointment has not already been inserted
    open curCheckExists;
    fetch curCheckExists into vcCheck;
    if curCheckExists%NOTFOUND then 
      insert into appointments ( id,
                               parent_appt_id,
                               start_date,
                               end_date, 
                               start_time, 
                               end_time, 
                               appt_type, 
                               short_desc, 
                               long_desc, 
                               remind_me, 
                               frequency_id, 
                               workdays_only, 
                               user_id, 
                               creator_id)
      values                 ( appointments_id.nextval,
                               pnParentAppt,
                               pdTargetDate,
                               pdTargetDate,
                               dThisDate,
                               dThisDate + pnDuration,
                               pnApptType,
                               pvcShortDesc,
                               pvcLongDesc,
                               pnRemindInt,
                               pnFreq,
                               pvcWorkdays,
                               pnAttendee,
                               pnCreator);
    end if;
    close curCheckExists;
  END InsertAppt;


  /*---------------------------------------------------------*\
   * CorrectDate Just keeps the Date portion of the start and  
   *            end times in step with the actaul appointment
   *            date.
   *            This is cosmetic as only the time portion
   *            is actually used. 
  \*---------------------------------------------------------*/ 
  
  FUNCTION CorrectDate (pdDate IN DATE, pdTime IN DATE) RETURN DATE is
  BEGIN
  RETURN to_date(to_char(pdDate,'DDMMYYYY')||' '||to_char(pdTime,'HH24:MI:SS'),'DDMMYYYY HH24:MI:SS');
  END CorrectDate;
  
  
  FUNCTION Schedule         ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pdOrigEnd        IN DATE,
                              pnOrigFreq       IN NUMBER,
                              pvcOrigWorking   IN VARCHAR2) RETURN BOOLEAN is
  -- Variable declarations
    ParentApp             appointments%rowtype;
    ExistingApp           appointments%rowtype;
    dStartDate            DATE                 := trunc(APPOINTMENTS_PKG.CheckStartDate(pdDateFrom));
    dEndDate              DATE                 := trunc(APPOINTMENTS_PKG.CheckEndDate(pdDateFrom,pdDateTo));
    bNewSchedule          BOOLEAN              := FALSE;
    bAdditionalSchedule   BOOLEAN              := FALSE;
    dScheduleStart        DATE;
    dExistingMaxDate      DATE;
    arrTargetDate         APPOINTMENTS_PKG.typSchedDates;
    bCheckForParent       BOOLEAN              := TRUE;
    bIgnoreRow            BOOLEAN              := FALSE;
    nDuration             NUMBER;

  --Cursors
  
    -- curExisting Info checks to see if there are any child
    -- appointments already in existance so that we can compare 
    -- the old and new values for columns like frequency.
    cursor curExistingInfo is
           select * 
           from appointments a
           where a.parent_appt_id = pnAppointmentId
           and   a.start_date >= dStartDate;

    -- curGetAttendees will give us a list of all the attendees who will
    -- Have to be processed if we are to create a new schedule
    cursor curGetAttendees is 
           select aa.user_id, 
                  aa.reminder_interval
           from appointment_attendees aa
           where aa.appointment_id = pnAppointmentId
           and   aa.deleted_on is NULL;

  BEGIN
    open  APPOINTMENTS_PKG.curParentInfo(pnAppointmentId);
    fetch APPOINTMENTS_PKG.curParentInfo into ParentApp;
    if    APPOINTMENTS_PKG.curParentInfo%NOTFOUND then
      close APPOINTMENTS_PKG.curParentInfo;
      RAISE exInvalidAppointment;
    end if;
    close APPOINTMENTS_PKG.curParentInfo;
    
    -- Work out the duration of this appointment 
    nDuration := ParentApp.end_time - ParentApp.start_time;
    
    -- Check that this truely is a parent Appointment 
    -- and that it is not itself a child
    if ParentApp.parent_appt_id is not null then 
      RAISE exNotParent;
    end if;

    -- Pull out an existing child of this appt for comparison
    open curExistingInfo;
    fetch curExistingInfo into ExistingApp;
    if curExistingInfo%NOTFOUND then
      bNewSchedule      := TRUE;
      dScheduleStart    := dStartDate;
    end if;
    close curExistingInfo;
    
    
    -- Action 1: Check has the Frequency Changed?
    <<CheckFreq>>
    if (not bNewSchedule and 
        (
         (ParentApp.frequency_id <> pnOrigFreq)
          or 
         (nvl(ParentApp.workdays_only,'N') <> nvl(pvcOrigWorking,'N'))
          or 
         (pdOrigEnd > ParentApp.End_date)
        )
       ) then 
      -- We are going to have to clean up all future runs of this appointment as
      -- the existing schedule is no longer valid.
      if not APPOINTMENTS_PKG.Remove(pnAppointmentId,dStartDate) then 
         RETURN FALSE;
      end if;
      -- Then treat this like a new schedule
      bNewSchedule   := TRUE;
      dScheduleStart := dStartDate;
    end if;
    /* <<CheckFreq>> */
    
    -- Action 2: Check has the owner extended the schedule.
    if ((NOT bNewSchedule) and (ParentApp.end_date > pdOrigEnd)) then 
      -- We'll have to schedule some extra meetings to meet the new 
      -- end date as well as potentially updating extings rows.
      bAdditionalSchedule := TRUE;
      dScheduleStart      := pdOrigEnd;
    end if;

    -- Action 3 - If we are not starting from scratch then we need to simply 
    -- update all the child rows with the new info.
    if not bNewSchedule then 
      update appointments a
      set    a.start_time  = APPOINTMENTS_PKG.CorrectDate(a.start_time,ParentApp.start_time),
             a.end_time    = APPOINTMENTS_PKG.CorrectDate(a.start_time,ParentApp.start_time) + nDuration,
             a.appt_type   = ParentApp.appt_type,
             a.short_desc  = ParentApp.short_desc,
             a.long_desc   = ParentApp.long_desc
      where  a.parent_appt_id =  pnAppointmentId
      and    a.start_date     >= dStartDate;
    end if;
    
    -- Action 4 - Do we have new rows to insert? 
    <<NewRows>>
    if (bNewSchedule or bAdditionalSchedule) then
      -- calculate the date list from the frequency information 
      arrTargetDate := APPOINTMENTS_PKG.CalculateFreq(ParentApp.start_date, ParentApp.end_date, dScheduleStart, ParentApp.frequency_id, (ParentApp.workdays_only = 'Y'));
      
      -- Check to see if the parent record is likely to be included in the list
      if (arrTargetDate(1) <> ParentApp.start_date) then
        bCheckForParent := FALSE;
      end if;
      -- Loop through each attendee (including the creator) and create the row for each appointment
      <<EachAttendee>>
      for recAttendee in curGetAttendees LOOP
        <<EachAppointment>>
        for i in 1..arrTargetDate.COUNT LOOP
          bIgnoreRow := FALSE;
          if bCheckForParent then 
            if (recAttendee.user_id = ParentApp.user_id) and (arrTargetDate(i) = trunc(ParentApp.start_date)) then 
              -- That is the source row which already exists so we can ignore it and 
              -- not do this check again
              bCheckForParent := FALSE;
              bIgnoreRow      := TRUE;
            end if;
          end if;
          
          if not bIgnoreRow then 
            -- Ok we can now insert the row, with the correct reminder time
            APPOINTMENTS_PKG.InsertAppt ( pnAppointmentId,
                                          arrTargetDate(i),
                                          ParentApp.start_time, 
                                          nDuration,
                                          ParentApp.appt_type,
                                          ParentApp.short_desc,
                                          ParentApp.long_desc,
                                          recAttendee.reminder_interval,
                                          ParentApp.frequency_id,
                                          ParentApp.workdays_only,
                                          recAttendee.user_id,
                                          ParentApp.user_id);
          end if;
        end LOOP EachAppointment;
      end LOOP EachAttendee;
    end if;
    /* <<NewRows>>*/

  RETURN TRUE;
  EXCEPTION
    WHEN exInvalidAppointment then
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(1);
      RETURN FALSE;
    WHEN exInvalidRange then
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(2);
      RETURN FALSE;
    WHEN OTHERS then 
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(4)||SQLERRM;
      RETURN FALSE;
  END Schedule;

  FUNCTION AddAttendee      ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pnUserId         IN NUMBER) RETURN BOOLEAN is
    arrUserList  APPOINTMENTS_PKG.typUserIdList;
  BEGIN
    arrUserList(1) := pnUserId;
  RETURN APPOINTMENTS_PKG.AddAttendeeBulk(pnAppointmentId, pdDateFrom, pdDateTo, arrUserList);
  END AddAttendee;

  FUNCTION AddAttendeeBulk  ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              UserIdList       IN APPOINTMENTS_PKG.typUserIdList) RETURN BOOLEAN is

    cursor curCheckAttendee (pnThisUser IN NUMBER) is 
           select aa.reminder_interval
           from appointment_attendees aa
           where aa.appointment_id = pnAppointmentId
           and   aa.user_id        = pnThisUser
           and  aa.deleted_on     is NULL;
    nReminderInt NUMBER;
    arrTargetDate         APPOINTMENTS_PKG.typSchedDates;
    ParentApp             APPOINTMENTS%ROWTYPE;
    dStartDate            DATE                 := APPOINTMENTS_PKG.CheckStartDate(pdDateFrom);
    dEndDate              DATE                 := APPOINTMENTS_PKG.CheckEndDate(pdDateFrom,pdDateTo);
    bIgnore               BOOLEAN;
    nDuration             NUMBER;
  BEGIN
    open  APPOINTMENTS_PKG.curParentInfo(pnAppointmentId);
    fetch APPOINTMENTS_PKG.curParentInfo into ParentApp;
    if    APPOINTMENTS_PKG.curParentInfo%NOTFOUND then
      close APPOINTMENTS_PKG.curParentInfo;
      RAISE exInvalidAppointment;
    end if;
    close APPOINTMENTS_PKG.curParentInfo;
    nDuration := ParentApp.end_time - parentApp.start_time;
 
    -- Calculate the Frequency Range
    arrTargetDate := APPOINTMENTS_PKG.CalculateFreq(dStartDate, dEndDate, dStartDate, ParentApp.frequency_id, (ParentApp.workdays_only = 'Y'));
    -- To add an attendee we basically use the same logic as the schedule
    -- Except that the control loops are slightly different
    <<UserLoop>>
    for i in 1..UserIdList.COUNT LOOP
      open curCheckAttendee(UserIdList(i));
      fetch curCheckAttendee into nReminderInt;
      if curCheckAttendee%FOUND then
         -- We need to remove the existing Rows and refresh 
         bIgnore :=  APPOINTMENTS_PKG.REMOVE(pnAppointmentId, pdDateFrom,UserIdList(i));
      end if;
      close curCheckAttendee;
      
      -- Now loop through each of the target dates
      <<TargetDates>>
      for j in 1..arrTargetDate.COUNT LOOP
        APPOINTMENTS_PKG.InsertAppt ( pnAppointmentId,
                                      arrTargetDate(j),
                                      ParentApp.start_time, 
                                      nDuration,
                                      ParentApp.appt_type,
                                      ParentApp.short_desc,
                                      ParentApp.long_desc,
                                      nReminderInt,
                                      ParentApp.frequency_id,
                                      ParentApp.workdays_only,
                                      UserIdList(i),
                                      ParentApp.user_id);
      end LOOP;
      /* <<TargetDates>> */
    end LOOP;
    /* <<UserLoop>> */
  RETURN TRUE;
  EXCEPTION
    WHEN exInvalidAppointment then
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(1);
      RETURN FALSE;
    WHEN OTHERS then 
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(4)||SQLERRM;
      RETURN FALSE;
  END AddAttendeeBulk;

  FUNCTION Remove           ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE) RETURN BOOLEAN is
    arrUserList  APPOINTMENTS_PKG.typUserIdLIst;
  BEGIN
  RETURN APPOINTMENTS_PKG.REMOVE(pnAppointmentId, pdDateFrom, arrUserList);
  END Remove;

  FUNCTION Remove           ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pnUserId         IN NUMBER) RETURN BOOLEAN is
    arrUserList  APPOINTMENTS_PKG.typUserIdList;
  BEGIN
    arrUserList(1) := pnUserId;
  RETURN APPOINTMENTS_PKG.REMOVE(pnAppointmentId, pdDateFrom, arrUserList);
  END Remove;

  FUNCTION Remove           ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              UserIdList       IN APPOINTMENTS_PKG.typUserIdList) RETURN BOOLEAN is 
    --Variables
    dChopDate  DATE := APPOINTMENTS_PKG.CheckStartDate(pdDateFrom);
  BEGIN
    -- Simply delete all records with this as a parent appointment
    -- After the specified date. for each user
    if UserIdList.COUNT = 0 then
      delete from appointments a 
      where a.parent_appt_id  =  pnAppointmentId
      and   a.start_time      >= dChopDate;
    else
      for i in 1..UserIdList.COUNT LOOP
        delete from appointments a 
        where a.parent_appt_id  =  pnAppointmentId
        and   a.start_time      >= dChopDate 
        and   a.user_id         =  UserIdList(i);
      end LOOP;
    end if;
  
  RETURN TRUE;
  EXCEPTION 
    WHEN OTHERS then 
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(4)||SQLERRM;
      RETURN FALSE;
  END Remove;

  FUNCTION GetLastError RETURN VARCHAR2 is
  BEGIN
  RETURN APPOINTMENTS_PKG.LAST_ERROR;
  END GetLastError;

  FUNCTION CascadeReminder  ( pnAppointmentId  IN NUMBER,
                              pdDateFrom       IN DATE,
                              pnUserId         IN NUMBER,
                              pnReminderInt    IN NUMBER) RETURN BOOLEAN IS
    dStartDate  DATE := trunc(APPOINTMENTS_PKG.CheckStartDate(pdDateFrom));
  BEGIN
    -- Update the Appointment Attendees Table with the new interval
    update appointment_attendees a
    set    a.reminder_interval = pnReminderInt
    where  a.appointment_id    = pnAppointmentId
    and    a.user_id           = pnUserId
    and    a.deleted_on is NULL;
    if SQL%FOUND then 
       -- Cascade the update to all child appointments for this user.
       update appointments a
       set    a.remind_me         =  pnReminderInt
       where  a.parent_appt_id    =  pnAppointmentId
       and    a.user_id           =  pnUserId
       and    a.start_date        >= dStartDate;
     end if;
  RETURN TRUE;
  EXCEPTION
    WHEN OTHERS then 
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(4)||SQLERRM;
      RETURN FALSE;
  END CascadeReminder;

  FUNCTION PreviewRepeats   ( pdDateFrom       IN DATE,
                              pdDateTo         IN DATE,
                              pnFreqCategory   IN NUMBER,
                              pvcFormatMask    IN VARCHAR2 DEFAULT 'DD-MON-YYYY',
                              pbWorkingDays    IN BOOLEAN  DEFAULT TRUE) return VARCHAR2 is
    vcBuffer    VARCHAR2(2000);
    vcChunk     VARCHAR2(60);
    arrDates    APPOINTMENTS_PKG.typSchedDates;
    iNumDates   PLS_INTEGER;
    iMaskLen    PLS_INTEGER := length(pvcFormatMask);
    iBuffLen    PLS_INTEGER := 0;
  BEGIN
    arrDates := APPOINTMENTS_PKG.CalculateFreq(pdDateFrom, pdDateTo, pdDateFrom, pnFreqCategory, pbWorkingDays);
    iNumDates := arrDates.COUNT; 
    if iNumDates = 0 then 
      vcBuffer := ErrorRes(3);
    else
      <<FillBuffer>>
      for i in 1..iNumDates LOOP
        vcChunk := to_char(arrDates(i),pvcFormatMask)||chr(10);
        iBuffLen := iBuffLen + length(vcChunk);
        if iBuffLen < 2000 then 
           vcBuffer := vcBuffer||vcChunk;
        else
           vcBuffer := vcBuffer||'...';
           EXIT FillBuffer;
        end if;
      end LOOP;
    end if;

  RETURN vcBuffer;
  EXCEPTION
    WHEN exInvalidRange then
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(2);
      RETURN APPOINTMENTS_PKG.LAST_ERROR;
  END PreviewRepeats;


  FUNCTION GetFirstAppt   ( pdDateFrom           IN DATE,
                            pdDateTo             IN DATE,
                            pnFreqCategory       IN NUMBER,
                            pbWorkingDays        IN BOOLEAN DEFAULT TRUE) return DATE is
    dFirstDate    DATE;
    dThisMonth    DATE;
    vcAbsolute    VARCHAR2(1);
    vcCalcUnits   VARCHAR2(1);
    vcCalcFrom    VARCHAR2(1);
    iInterval     PLS_INTEGER;
    iOffsetDay    PLS_INTEGER;
    bQuarters     BOOLEAN     := FALSE;
    iNextStart    PLS_INTEGER := 1;
    
  BEGIN
    if pdDateFrom >= pdDateTo then 
      RAISE exInvalidRange;
    end if;
    -- Gather info about this frequency
    open APPOINTMENTS_PKG.curGetFreq(pnFreqCategory);
    fetch APPOINTMENTS_PKG.curGetFreq into vcCalcUnits, iInterval, vcAbsolute, vcCalcFrom, iOffsetDay;
    if APPOINTMENTS_PKG.curGetFreq%NOTFOUND then
      CLOSE APPOINTMENTS_PKG.curGetFreq;
      RAISE exInvalidFrequency;
    end if;
    close APPOINTMENTS_PKG.curGetFreq;

    if (vcAbsolute = 'Y') then
      if vcCalcFrom = 'Q' then
        bQuarters := TRUE;
        iNextStart := 3;
      end if;
      if (bQuarters) then 
        dThisMonth := add_months(to_date('0101'||to_char(pdDateFrom,'YYYY'),'DDMMYYYY'),((to_number(to_char(pdDateFrom,'Q')) -1) * 3));
      else
        dThisMonth := to_date(to_char(pdDateFrom,'MMYYYY'),'MMYYYY');
      end if;
      
      dFirstDate := next_day((dThisMonth - 1), Days(iOffsetDay)) + (iInterval);
      
      if (dFirstDate < pdDateFrom) then
        dFirstDate := next_day((add_months(dThisMonth,iNextStart) - 1), Days(iOffsetDay)) + (iInterval);
      end if;
    else
      if (pbWorkingDays) then 
        dFirstDate := WorkingDay(pdDateFrom);
      else
        dFirstDate := pdDateFrom;
      end if;
    end if;
  RETURN dFirstDate;
  EXCEPTION
    WHEN exInvalidRange then
      APPOINTMENTS_PKG.LAST_ERROR      := ErrorRes(2);
      RAISE VALUE_ERROR;
  END GetFirstAppt; 

BEGIN
  ErrorRes(1) := 'Parent Appointment does not exist';
  ErrorRes(2) := 'The End Date for scheduling a Repeating Appointment should be greater than the Start Date';
  ErrorRes(3) := 'No Dates fit the range and frequency';
  ErrorRes(4) := 'SQL Error: ';
  -- Get the text name for each day in the current NLS setting
  Days(1)     := to_char(to_date('05091999','DDMMYYYY'),'DAY');/* Sunday */
  Days(2)     := to_char(to_date('06091999','DDMMYYYY'),'DAY');
  Days(3)     := to_char(to_date('07091999','DDMMYYYY'),'DAY');
  Days(4)     := to_char(to_date('08091999','DDMMYYYY'),'DAY');
  Days(5)     := to_char(to_date('09091999','DDMMYYYY'),'DAY');
  Days(6)     := to_char(to_date('10091999','DDMMYYYY'),'DAY');
  Days(7)     := to_char(to_date('11091999','DDMMYYYY'),'DAY');
END APPOINTMENTS_PKG;
/

delete from appointments;

delete from appointment_attendees;

insert into appointments values
(1, null, '8-dec-2001', '8-dec-2001', to_date('8-dec-2001 10:00', 'dd-mon-yyyy hh24:mi'), to_date('8-dec-2001 12:00', 'dd-mon-yyyy hh24:mi'),
17, 'Integration meeting', 'ongoing information to the integration meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(1, 1, null, null);

insert into appointments values
(2, null, '8-dec-2001', '8-dec-2001', to_date('8-dec-2001 15:00', 'dd-mon-yyyy hh24:mi'), to_date('8-dec-2001 16:30', 'dd-mon-yyyy hh24:mi'),
17, 'PRP meeting', 'ongoing information to the PRP meeting', 15, 0, 'Y', 1, 1);
insert into appointment_attendees values
(2, 1, null, null);

insert into appointments values
(3, null, '8-dec-2001', '8-dec-2001', to_date('8-dec-2001 17:00', 'dd-mon-yyyy hh24:mi'), to_date('8-dec-2001 18:00', 'dd-mon-yyyy hh24:mi'),
17, 'PMs meeting', 'ongoing information to the PMs meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(3, 1, null, null);

insert into appointments values
(4, null, '9-dec-2001', '9-dec-2001', to_date('9-dec-2001 8:30', 'dd-mon-yyyy hh24:mi'), to_date('9-dec-2001 9:30', 'dd-mon-yyyy hh24:mi'),
16, 'Vincent 1-1', 'ongoing information to the meeting', null, 5, 'Y', 1, 1);
insert into appointment_attendees values
(4, 1, null, null);

insert into appointments values
(5, null, '9-dec-2001', '9-dec-2001', to_date('9-dec-2001 10:30', 'dd-mon-yyyy hh24:mi'), to_date('9-dec-2001 12:00', 'dd-mon-yyyy hh24:mi'),
15, 'Developer Club', 'ongoing information to the Developer Club', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(5, 1, null, null);

insert into appointments values
(6, null, '9-dec-2001', '9-dec-2001', to_date('9-dec-2001 14:00', 'dd-mon-yyyy hh24:mi'), to_date('9-dec-2001 15:00', 'dd-mon-yyyy hh24:mi'),
17, 'Tanya''s Staff meeting', 'ongoing information to the staff meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(6, 1, null, null);

insert into appointments values
(7, null, '9-dec-2001', '9-dec-2001', to_date('9-dec-2001 15:30', 'dd-mon-yyyy hh24:mi'), to_date('9-dec-2001 17:00', 'dd-mon-yyyy hh24:mi'),
17, 'Marc''s Staff meeting', 'ongoing information to the staff meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(7, 1, null, null);

insert into appointments values
(8, null, '10-dec-2001', '10-dec-2001', to_date('10-dec-2001 8:00', 'dd-mon-yyyy hh24:mi'), to_date('10-dec-2001 9:30', 'dd-mon-yyyy hh24:mi'),
16, 'Axel 1-1', 'ongoing information to the meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(8, 1, null, null);

insert into appointments values
(9, null, '10-dec-2001', '10-dec-2001', to_date('10-dec-2001 10:00', 'dd-mon-yyyy hh24:mi'), to_date('10-dec-2001 11:00', 'dd-mon-yyyy hh24:mi'),
16, 'Tomas 1-1', 'ongoing information to the meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(9, 1, null, null);

insert into appointments values
(10, null, '10-dec-2001', '10-dec-2001', to_date('10-dec-2001 14:00', 'dd-mon-yyyy hh24:mi'), to_date('10-dec-2001 15:00', 'dd-mon-yyyy hh24:mi'),
10, 'Product Lead meeting', 'ongoing information to the Product Lead meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(10, 1, null, null);

insert into appointments values
(11, null, '10-dec-2001', '10-dec-2001', to_date('10-dec-2001 15:00', 'dd-mon-yyyy hh24:mi'), to_date('10-dec-2001 16:00', 'dd-mon-yyyy hh24:mi'),
16, 'Sandra 1-1', 'ongoing information to the meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(11, 1, null, null);

insert into appointments values
(12, null, '10-dec-2001', '10-dec-2001', to_date('10-dec-2001 16:00', 'dd-mon-yyyy hh24:mi'), to_date('10-dec-2001 17:00', 'dd-mon-yyyy hh24:mi'),
16, 'William 1-1', 'ongoing information to the meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(12, 1, null, null);

insert into appointments values
(13, null, '11-dec-2001', '11-dec-2001', to_date('11-dec-2001 9:00', 'dd-mon-yyyy hh24:mi'), to_date('11-dec-2001 10:30', 'dd-mon-yyyy hh24:mi'),
17, 'Team meeting', 'ongoing information to the Team meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(13, 1, null, null);

insert into appointments values
(14, null, '11-dec-2001', '11-dec-2001', to_date('11-dec-2001 10:30', 'dd-mon-yyyy hh24:mi'), to_date('11-dec-2001 12:30', 'dd-mon-yyyy hh24:mi'),
17, 'Customer Visit', 'ongoing information to the customer vistit', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(14, 1, null, null);

insert into appointments values
(15, null, '11-dec-2001', '11-dec-2001', to_date('11-dec-2001 13:00', 'dd-mon-yyyy hh24:mi'), to_date('11-dec-2001 14:00', 'dd-mon-yyyy hh24:mi'),
10, 'BPG Staff Meeting', 'ongoing information to the stuff meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(15, 1, null, null);

insert into appointments values
(16, null, '11-dec-2001', '11-dec-2001', to_date('11-dec-2001 14:00', 'dd-mon-yyyy hh24:mi'), to_date('11-dec-2001 15:30', 'dd-mon-yyyy hh24:mi'),
17, 'OOW Meeting', 'ongoing information to the OOW meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(16, 1, null, null);

insert into appointments values
(17, null, '12-dec-2001', '12-dec-2001', to_date('12-dec-2001 11:00', 'dd-mon-yyyy hh24:mi'), to_date('12-dec-2001 12:00', 'dd-mon-yyyy hh24:mi'),
17, 'Marketing Meeting', 'ongoing information to the marketing meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(17, 1, null, null);

insert into appointments values
(18, null, '12-dec-2001', '12-dec-2001', to_date('12-dec-2001 13:30', 'dd-mon-yyyy hh24:mi'), to_date('12-dec-2001 15:00', 'dd-mon-yyyy hh24:mi'),
17, 'Keynote Meeting', 'ongoing information to the keynote meeting', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(18, 1, null, null);

insert into appointments values
(19, null, '14-dec-2001', '18-dec-2001', to_date('14-dec-2001 18:00', 'dd-mon-yyyy hh24:mi'), to_date('18-dec-2001 13:00', 'dd-mon-yyyy hh24:mi'),
15, 'ORACLE Open World', 'ongoing information to the OOW in Los Angeles', null, 0, 'Y', 1, 1);
insert into appointment_attendees values
(19, 1, null, null);


prompt Tables and sequences created and populated.
set feedback on
COMMIT;

spool off

