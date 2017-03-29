CREATE TABLE PERSON(
PNAME VARCHAR2(20),
LOGINID NUMBER PRIMARY KEY,
PASSWORD VARCHAR2(20),
UNIQUE (PNAME, LOGINID,PASSWORD));
CREATE TABLE JOB_PROVIDER(
REG_ID NUMBER,
COMPANY_NAME VARCHAR2(25),
LOGINID NUMBER,
FOUNDATION_YEAR VARCHAR2(4),
EMAIL_ID VARCHAR2(30),
CONTACT_NUMBER NUMBER,
FORTUNE_500 CHAR(1),
PRIMARY KEY(REG_ID, COMPANY_NAME),
FOREIGN KEY (LOGINID) REFERENCES PERSON(LOGINID),
CONSTRAINT FORTUNE500  CHECK (FORTUNE_500 IN('Y','N')),
CONSTRAINT FOUNDATION_YR CHECK(LENGTH(FOUNDATION_YEAR)=4)); 
CREATE TABLE JOB_SEEKER(
SSN NUMBER, 
LOGINID NUMBER,
JOB_SEEKER_NAME VARCHAR2(30),
GPA NUMBER,
MAJOR VARCHAR2(25),
CONTACT_NUMBER NUMBER,
EMAIL_ID VARCHAR2(30),
JOB_SEEKER_TYPE VARCHAR2(15),
PRIMARY KEY(SSN),
FOREIGN KEY (LOGINID) REFERENCES PERSON(LOGINID)); 
CREATE TABLE JOB(
JOB_ID NUMBER,
JOB_TYPE VARCHAR2(10) DEFAULT 'NONIT',
REG_ID NUMBER,
COMPANY_NAME VARCHAR2(25),
VACANCY_COUNT NUMBER,
SALARY NUMBER,
GPA_REQ NUMBER,
EXPERIENCE_REQ NUMBER,
POSTING_DATE DATE,
PRIMARY KEY(JOB_ID, COMPANY_NAME),
FOREIGN KEY(REG_ID, COMPANY_NAME) REFERENCES JOB_PROVIDER(REG_ID, COMPANY_NAME) 
ON DELETE CASCADE); 
CREATE TABLE EXPERIENCED(
ESSN NUMBER PRIMARY KEY,
SALARY NUMBER,
EXPERIENCED_YEARS NUMBER,
LAST_COMPANY_NAME VARCHAR2(25),
FOREIGN KEY(ESSN) REFERENCES JOB_SEEKER(SSN) 
ON DELETE CASCADE); 
CREATE TABLE FRESHER(
FSSN NUMBER PRIMARY KEY,
FINAL_YEAR_PROJECT VARCHAR2(50),
INTERNSHIP_COMPANY VARCHAR2(25),
INTERNSHIP_DURATION NUMBER,
FOREIGN KEY(FSSN) REFERENCES JOB_SEEKER(SSN)
ON DELETE CASCADE); 
CREATE TABLE RESUME(
SSN NUMBER,
RESUME_FILE_NAME VARCHAR2(20), 
DESCRIPTION VARCHAR2(60),
PRIMARY KEY(SSN, RESUME_FILE_NAME),
FOREIGN KEY(SSN) REFERENCES JOB_SEEKER(SSN)
ON DELETE CASCADE); 
CREATE TABLE TECHNOLOGY(
ESSN NUMBER,
TECHNOLOGY VARCHAR2(20),
PRIMARY KEY(ESSN, TECHNOLOGY),
FOREIGN KEY(ESSN) REFERENCES EXPERIENCED(ESSN)
ON DELETE CASCADE); 
CREATE TABLE SEARCH_FOR(
JOB_ID NUMBER,
COMPANY_NAME VARCHAR2(25),
SSN NUMBER,
PRIMARY KEY(JOB_ID, COMPANY_NAME, SSN),
FOREIGN KEY(JOB_ID, COMPANY_NAME) REFERENCES JOB(JOB_ID, COMPANY_NAME),
FOREIGN KEY(SSN) REFERENCES JOB_SEEKER(SSN)
ON DELETE CASCADE); 
CREATE TABLE SEARCHS(
COMPANY_REG_ID NUMBER,
COMPANY_NAME VARCHAR2(25),
SSN NUMBER,
PRIMARY KEY(COMPANY_REG_ID, COMPANY_NAME, SSN),
FOREIGN KEY(COMPANY_REG_ID, COMPANY_NAME) REFERENCES JOB_PROVIDER(REG_ID, COMPANY_NAME),
FOREIGN KEY(SSN) REFERENCES JOB_SEEKER(SSN)
ON DELETE CASCADE); 
CREATE TABLE VIEW_RESUME(
REG_ID NUMBER,
COMPANY_NAME VARCHAR2(50),
SSN NUMBER,
RESUME_FILE_NAME VARCHAR2(40),
PRIMARY KEY(REG_ID, COMPANY_NAME, SSN, RESUME_FILE_NAME),
FOREIGN KEY(SSN, RESUME_FILE_NAME) REFERENCES RESUME(SSN, RESUME_FILE_NAME),
FOREIGN KEY(REG_ID, COMPANY_NAME) REFERENCES JOB_PROVIDER(REG_ID, COMPANY_NAME)
ON DELETE CASCADE); 
CREATE VIEW PRIORITY_CANDIDATES AS
SELECT S.SSN,S.JOB_SEEKER_NAME,S.EMAIL_ID 
FROM JOB_SEEKER S,EXPERIENCED E, JOB_PROVIDER P
WHERE S.SSN = E.ESSN AND
E.LAST_COMPANY_NAME = P.COMPANY_NAME; 