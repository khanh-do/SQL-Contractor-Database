/* Khanh Do CIS 1200 Project 04/19/2017 */

USE HOME_CONTRACTORS;

CREATE TABLE CONTACT (
CONT_CODE			INTEGER PRIMARY KEY,
CONT_FNAME			VARCHAR(20)  NOT NULL,
CONT_LNAME			VARCHAR(20)
);

CREATE TABLE CONTRACTOR (
CONTR_NUM			INTEGER PRIMARY KEY,
CONTR_NAME			VARCHAR(35)  NOT NULL,
CONTR_PHONE			CHAR(12),
CONTR_ADDRESS		VARCHAR(40),
CONTR_CITY			VARCHAR(20) NOT NULL,
CONTR_STATE			CHAR(2) NOT NULL, 
COMMENT				VARCHAR(200),
USED_BEFORE			BIT NOT NULL DEFAULT 0,
CONT_CODE			INTEGER CONSTRAINT CONTRACTOR_CONT_CODE_FK REFERENCES CONTACT		
);

CREATE TABLE SOURCE (
SOURCE_CODE			INTEGER PRIMARY KEY,
SOURCE_FNAME		VARCHAR(25)  NOT NULL,
SOURCE_LNAME		VARCHAR(20)
);

CREATE TABLE SERV (
SERV_CODE			INTEGER PRIMARY KEY,
SERV_DESC			VARCHAR(20) NOT NULL
);

CREATE TABLE REFERRAL (

CONTR_NUM			INTEGER NOT NULL,
SERV_CODE			INTEGER NOT NULL,
SOURCE_CODE			INTEGER NOT NULL,
PRIMARY KEY (CONTR_NUM,SERV_CODE),
FOREIGN KEY (CONTR_NUM) REFERENCES CONTRACTOR ON DELETE CASCADE,
FOREIGN KEY (SERV_CODE) REFERENCES SERV ON DELETE CASCADE,
FOREIGN KEY (SOURCE_CODE) REFERENCES  SOURCE (SOURCE_CODE)
);

CREATE TABLE SERV_SEARCH (
CONTR_NUM			INTEGER NOT NULL,
SERV_CODE			INTEGER NOT NULL,
SERV_RATING			INTEGER NOT NULL CHECK(SERV_RATING IN(1, 2, 3, 4, 5)),
SERV_COST			VARCHAR(10) NOT NULL,
SERV_COMMENT		VARCHAR(200),
PRIMARY KEY (CONTR_NUM, SERV_CODE),
FOREIGN KEY (CONTR_NUM) REFERENCES CONTRACTOR ON DELETE CASCADE,
FOREIGN KEY (SERV_CODE) REFERENCES SERV ON DELETE CASCADE
);

/* Loading data rows					*/

/* CONTACT rows						*/
INSERT INTO CONTACT VALUES(1, 'Mr.','Centro');
INSERT INTO CONTACT VALUES(2, 'Mike','Sudik');
INSERT INTO CONTACT VALUES(3, 'Tom', NULL);
INSERT INTO CONTACT VALUES(4, 'Aidas', NULL);
INSERT INTO CONTACT VALUES(5, 'Alex','Santos');

/* CONTRACTOR rows						*/
INSERT INTO CONTRACTOR VALUES(101, 'Centro Construction', '248-348-5533', '44950 Steeple Path', 'Novi', 'MI', 'The roads and driveways at Dover Hill look great.', 0, 1);
INSERT INTO CONTRACTOR VALUES(102, 'Majic Windows Co', '248-668-9090', '30580 Beck Rd', 'Wixom', 'MI', 'Do not use this company', 0, 2);
INSERT INTO CONTRACTOR VALUES(103, 'Thornton & Grooms', '248-644-7810', '24565 Hallwood Ct', 'Farmington Hills', 'MI', 'They do a great job, but charge a lot.', 1, 3);
INSERT INTO CONTRACTOR VALUES(104, 'AIG Heating & Cooling', '810-986-0160', '5982 Tall Oak Way', 'Brighton', 'MI', 'Aidas is skilled and knowledgeable.', 1, 4);
INSERT INTO CONTRACTOR VALUES(105, 'StepByStep Home Services LLC', '734-646-5594', '1470 Aberdeen St', 'Canton', 'MI', 'Alex does a thorough inspection.', 1, 5);
INSERT INTO CONTRACTOR VALUES(106, '123 Cabinets Direct', '248-513-4995', '40400 Grand River Ave, Suite B', 'Novi', 'MI', 'Doug’s cabinets look nice.', 0, NULL);

/* SOURCE rows						*/
INSERT INTO SOURCE VALUES(1001, 'Dover Hill Condo Board', NULL);
INSERT INTO SOURCE VALUES(1002, 'Solicitation', NULL);
INSERT INTO SOURCE VALUES(1003, 'Yelp', NULL);
INSERT INTO SOURCE VALUES(1004, 'Home Advisor', NULL);
INSERT INTO SOURCE VALUES(1005, 'Neighbor Doug', NULL);

/* SERV rows						*/
INSERT INTO SERV VALUES(10001, 'Cement');
INSERT INTO SERV VALUES(10002, 'Windows');
INSERT INTO SERV VALUES(10003, 'Plumbing');
INSERT INTO SERV VALUES(10004, 'Heating & Cooling');
INSERT INTO SERV VALUES(10005, 'Home Inspection');
INSERT INTO SERV VALUES(10006, 'Kitchen Design');
INSERT INTO SERV VALUES(10007, 'Cabinets');

/* REFERRAL rows						*/
INSERT INTO REFERRAL VALUES(101, 10001, 1001);
INSERT INTO REFERRAL VALUES(102, 10002, 1002);
INSERT INTO REFERRAL VALUES(103, 10003, 1003);
INSERT INTO REFERRAL VALUES(103, 10004, 1003);
INSERT INTO REFERRAL VALUES(104, 10004, 1004);
INSERT INTO REFERRAL VALUES(105, 10005, 1003);
INSERT INTO REFERRAL VALUES(106, 10006, 1005);
INSERT INTO REFERRAL VALUES(106, 10007, 1005);

/* SERV_SEARCH rows						*/
INSERT INTO SERV_SEARCH VALUES(101, 10001, 4, 'Moderate', 'They did a great job on the roads and driveways at Dover Hill.');
INSERT INTO SERV_SEARCH VALUES(102, 10002, 1, 'Expensive', 'The salesman employed a high-pressure sales tactic.');
INSERT INTO SERV_SEARCH VALUES(103, 10003, 4, 'Expensive', 'The master plumber was skilled and professional.');
INSERT INTO SERV_SEARCH VALUES(103, 10004, 4, 'Expensive', 'They did a good job on my HVAC.');
INSERT INTO SERV_SEARCH VALUES(104, 10004, 5, 'Moderate', 'Aidas is responsive and gets the job done.');
INSERT INTO SERV_SEARCH VALUES(105, 10005, 5, 'Moderate', 'Alex was thorough and a good communicator.');
INSERT INTO SERV_SEARCH VALUES(106, 10006, 5, 'Moderate', 'Florin had some good suggestions for my kitchen design.');
INSERT INTO SERV_SEARCH VALUES(106, 10007, 4, 'Moderate', 'The cabinets have soft close doors and drawers.');

/* Purpose: Create indexes */
CREATE INDEX SERV_DESCX ON SERV(SERV_DESC);
CREATE INDEX CONTR_STATEX ON CONTRACTOR(CONTR_STATE);

/* Purpose: Create a list of contractors with their service and rating as a View */
CREATE VIEW LIST1 AS
SELECT CONTR_NAME AS "Contractor", SERV_DESC AS "Service", SERV_RATING AS "Rating"
FROM CONTRACTOR, SERV_SEARCH, SERV
WHERE CONTRACTOR.CONTR_NUM = SERV_SEARCH.CONTR_NUM AND SERV_SEARCH.SERV_CODE = SERV.SERV_CODE
GROUP BY CONTR_NAME, SERV_DESC, SERV_RATING;

/* Purpose: Use the View from the previous query to print a list of contractors with a rating greater than 4 */
SELECT [Contractor], [Service], [Rating]
FROM LIST1
WHERE [Rating] > 4
ORDER BY [Service];

/* Purpose: Use the View from the previous query to print a list of contractors with a rating equal to or lower than 3 */
SELECT [Contractor], [Service], [Rating]
FROM LIST1
WHERE [Rating] <=3
ORDER BY [Service];

/* Purpose: Print a list of the contractors with their services that were referred by Yelp */
SELECT CONTR_NAME AS "Contractor", SERV_DESC AS "Service"
FROM CONTRACTOR C, SOURCE S, REFERRAL R, SERV SE
WHERE C.CONTR_NUM = R.CONTR_NUM AND R.SOURCE_CODE = S.SOURCE_CODE AND R.SERV_CODE = SE.SERV_CODE
AND S.SOURCE_FNAME = 'Yelp'
GROUP BY CONTR_NAME, SE.SERV_DESC; 

/* Purpose: Print a list of contractors that provide Heating & Cooling service.  Include their rating for that service */
SELECT CONTR_NAME AS "Contractor", SERV_RATING AS "Rating"
FROM CONTRACTOR C, SERV_SEARCH SS, SERV S
WHERE C.CONTR_NUM = SS.CONTR_NUM AND SS.SERV_CODE = S.SERV_CODE AND SERV_DESC = 'Heating & Cooling'
GROUP BY CONTR_NAME, SERV_RATING
ORDER BY CONTR_NAME;

/* Purpose: Print a list of contractors sorted by the service they provide in alphabetical order.  Within each service, sort by that rating in descending order */
SELECT CONTR_NAME AS "Contractor", CONCAT(CONT_FNAME, ' ', CONT_LNAME) AS "Contact", CONTR_PHONE AS "Phone", CONTR_ADDRESS AS "Address", CONTR_CITY AS "City", 
	CONTR_STATE AS "State", SERV_DESC AS "Service", SERV_RATING AS "Rating"
FROM CONTRACTOR LEFT JOIN CONTACT ON CONTRACTOR.CONT_CODE = CONTACT.CONT_CODE JOIN SERV_SEARCH ON CONTRACTOR.CONTR_NUM = SERV_SEARCH.CONTR_NUM 
	JOIN SERV ON SERV_SEARCH.SERV_CODE = SERV.SERV_CODE 
ORDER BY SERV_DESC, SERV_RATING DESC;

/* Purpose: Using a mathematical operator, increase the rating for Centro Construction for cement.  */
SELECT * FROM SERV_SEARCH;

UPDATE SERV_SEARCH
	SET SERV_RATING = SERV_RATING + 1
	WHERE CONTR_NUM = 101 AND SERV_CODE = 10001;

SELECT * FROM SERV_SEARCH;

/* Purpose: Using a subquery, print a list of contractors where we don't have a last name listed for their main contact person */
SELECT CONTR_NAME
FROM CONTRACTOR C
WHERE CONT_CODE IN (SELECT DISTINCT CONT_CODE FROM CONTACT WHERE CONT_LNAME IS NULL);

/* Purpose: Queries using aggregate functions.  Count the number of contractors in the database. Print the lowest rating on record */
SELECT COUNT (DISTINCT CONTR_NAME) AS "Number of contractors"
FROM CONTRACTOR;

SELECT MIN (SERV_RATING) AS "Lowest rating on record"
FROM SERV_SEARCH;

BEGIN TRANSACTION
COMMIT;

SELECT * FROM CONTRACTOR;
SELECT * FROM CONTACT;
SELECT * FROM SOURCE;
SELECT * FROM SERV;
SELECT * FROM REFERRAL;
SELECT * FROM SERV_SEARCH;

DROP TABLE SERV_SEARCH;
DROP TABLE REFERRAL;
DROP TABLE SERV;
DROP TABLE SOURCE;
DROP TABLE CONTRACTOR;
DROP TABLE CONTACT;
DROP VIEW LIST1;




