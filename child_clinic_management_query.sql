IF NOT EXISTS (
    SELECT * FROM sys.databases WHERE name = 'childcare'
)
    CREATE DATABASE childcare
GO

USE childcare
GO


--DOWN


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_clinics_clinic_clinic_id')
        ALTER TABLE CUSTOMERS DROP CONSTRAINT fk_clinics_clinic_clinic_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_clinics_clinic_state')
        ALTER TABLE clinics DROP CONSTRAINT fk_clinics_clinic_state
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_employees_employee_clinic_id')
        ALTER TABLE employees DROP CONSTRAINT fk_employees_employee_clinic_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_appointments_appointment_patient_id')
        ALTER TABLE appointments DROP CONSTRAINT fk_appointments_appointment_patient_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_fix_appointments_fix_appointment_id')
        ALTER TABLE fix_appointments DROP CONSTRAINT fk_fix_appointments_fix_appointment_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_fix_appointments_fix_clinic_id')
        ALTER TABLE fix_appointments DROP CONSTRAINT fk_fix_appointments_fix_clinic_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_treatments_treatment_appointment_id')
        ALTER TABLE treatments DROP CONSTRAINT fk_treatments_treatment_appointment_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_patients_patient_doctor_id')
        ALTER TABLE patients DROP CONSTRAINT fk_patients_patient_doctor_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_patient_family_patient_id')
        ALTER TABLE patient_family DROP CONSTRAINT fk_patient_family_patient_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_emergency_contacts_patient_id')
        ALTER TABLE emergency_contacts DROP CONSTRAINT fk_emergency_contacts_patient_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_lab_patient_id')
        ALTER TABLE lab DROP CONSTRAINT fk_lab_patient_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_bills_patient_id')
        ALTER TABLE bills DROP CONSTRAINT fk_bills_patient_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_insurance_patient_id')
        ALTER TABLE insurance DROP CONSTRAINT fk_insurance_patient_id
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_insurance_covers_cover_code')
        ALTER TABLE insurance_covers DROP CONSTRAINT fk_insurance_covers_cover_code
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_patient_family_patient_id')
        ALTER TABLE patient_family DROP CONSTRAINT fk_patient_family_patient_id
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_medicines_patient_id')
        ALTER TABLE medicines DROP CONSTRAINT fk_medicines_patient_id

GO
DROP TABLE IF EXISTS pharmacy
DROP TABLE IF EXISTS test_price
DROP TABLE IF EXISTS insurance_covers
DROP TABLE IF EXISTS insurance
DROP TABLE IF EXISTS bills
DROP TABLE IF EXISTS lab
DROP TABLE IF EXISTS emergency_contacts
DROP TABLE IF EXISTS patient_family
DROP TABLE IF EXISTS vaccines
DROP TABLE IF EXISTS patients
DROP TABLE IF EXISTS treatments
DROP TABLE IF EXISTS doctors
DROP TABLE IF EXISTS appointments
DROP TABLE IF EXISTS fix_appointments
DROP TABLE IF EXISTS employees
DROP TABLE IF EXISTS clinic_contacts
DROP TABLE IF EXISTS clinics
DROP TABLE IF EXISTS state_lookup
DROP TABLE IF EXISTS medicines
GO


-- UP METADATA

CREATE TABLE state_lookup
(
   state_id       INT IDENTITY (1, 1),
   state_name     VARCHAR (32),
   state_abbrev   CHAR (2),
   CONSTRAINT pk_state_lookup_state_abbrev primary key (state_abbrev)
)


CREATE TABLE clinics (
    clinic_id int NOT NULL,
    clinic_name varchar(50) NOT NULL,
    address_line_one varchar (200) NOT NULL,
    address_line_two varchar (200) NULL,
    clinic_state CHAR(2) NOT NULL,
    clinic_city char(30) NOT NULL,
    clinic_zip int NOT NULL,
    CONSTRAINT pk_clinics_clinic_id PRIMARY KEY (clinic_id),
    CONSTRAINT u_clinics_clinic_name UNIQUE (clinic_name)
)
ALTER TABLE clinics
    ADD CONSTRAINT fk_clinics_clinic_state FOREIGN KEY (clinic_state)
        REFERENCES state_lookup (state_abbrev)


CREATE TABLE clinic_contacts (
    clinic_id int NOT NULL,
    contact_no bigint NOT NULL,
    email varchar(50) NOT NULL,
    URL varchar (50) NULL,
    CONSTRAINT pk_clinic_contacts_clinic_id PRIMARY KEY (clinic_id)
)
ALTER TABLE clinic_contacts
    ADD CONSTRAINT fk_clinic_contacts_clinic_id FOREIGN KEY (clinic_id)
        REFERENCES clinics(clinic_id)

CREATE TABLE employees(
    employee_id int NOT NULL,
    emp_firstname varchar(255) NOT NULL,
    emp_lastname VARCHAR(255) NOT NULL,
    emp_title varchar(255) NOT NULL,
    employee_clinic_id INT NOT NULL,
    CONSTRAINT pk_employees_employee_id PRIMARY KEY (employee_id)
)
ALTER TABLE employees
    ADD CONSTRAINT fk_employees_employee_clinic_id FOREIGN KEY (employee_clinic_id)
        REFERENCES clinics (clinic_id)

CREATE TABLE doctors(
    doctor_id INT NOT NULL,
    doctor_license_no INT NOT NULL,
    doctor_firstname VARCHAR(255),
    doctor_lastname VARCHAR(255),
    doctor_email VARCHAR(255),
    doctor_contact_no BIGINT NOT NULL,
    doctor_experience INT NULL,
    doctor_clinic_id INT NULL,
    CONSTRAINT pk_doctors_doctor_id PRIMARY KEY (doctor_id)
)
ALTER TABLE doctors
    ADD CONSTRAINT fk_doctors_doctor_clinic_id FOREIGN KEY (doctor_clinic_id)
        REFERENCES clinics (clinic_id)

CREATE TABLE patients(
    patient_id INT NOT NULL,
    patient_firstname VARCHAR(255) NOT NULL,
    patient_lastname VARCHAR(255) NOT NULL,
    patient_nationality VARCHAR(255) NULL,
    patient_gender VARCHAR(255) NOT NULL,
    patient_dob DATETIME NOT NULL,
    patient_age INT NOT NULL,
    patient_address_line_1 VARCHAR(255) NOT NULL,
    patient_address_line_2 VARCHAR(255) NULL,
    patient_city VARCHAR(255) NOT NULL,
    patient_state CHAR(2) NOT NULL,
    patient_zipcode INT NOT NULL,
    patient_existing_medical_conditions_1 VARCHAR(255) NULL,
    patient_existing_medical_conditions_2 VARCHAR(255) NULL,
    patient_allergy VARCHAR(255) NULL,
    patient_doctor_id INT NOT NULL
    CONSTRAINT pk_patients_patient_id PRIMARY KEY (patient_id)
)
ALTER TABLE patients
    ADD CONSTRAINT fk_patients_patient_doctor_id FOREIGN KEY (patient_doctor_id)
        REFERENCES doctors(doctor_id)

ALTER TABLE patients
    ADD CONSTRAINT fk_patients_patient_state FOREIGN KEY (patient_state)
        REFERENCES state_lookup (state_abbrev)


CREATE TABLE appointments(
    appointment_id INT NOT NULL,
    appointment_type VARCHAR(255) NOT NULL,
    appointment_created_date DATETIME NOT NULL,
    appointment_patient_id INT NOT NULL,
    CONSTRAINT pk_appointments_appointment_id PRIMARY KEY (appointment_id)
)
ALTER TABLE appointments
    ADD CONSTRAINT fk_appointments_appointment_patient_id FOREIGN KEY (appointment_patient_id)
        REFERENCES patients(patient_id)


CREATE TABLE fix_appointments(
    fix_appointment_id INT NOT NULL,
    fix_clinic_id INT NOT NULL,
    CONSTRAINT pk_fix_appointments_fix_appointment_id PRIMARY KEY (fix_appointment_id)
)
ALTER TABLE fix_appointments
    ADD CONSTRAINT fk_fix_appointments_fix_appointment_id FOREIGN KEY (fix_appointment_id)
        REFERENCES appointments(appointment_id)

ALTER TABLE fix_appointments
    ADD CONSTRAINT fk_fix_appointments_fix_clinic_id FOREIGN KEY (fix_clinic_id)
        REFERENCES clinics (clinic_id)


CREATE TABLE treatments(
    treatment_appointment_id INT NOT NULL,
    treatment_doctor_id INT NOT NULL,
    CONSTRAINT pk_treatments_treatment_appointment_id PRIMARY KEY (treatment_appointment_id)
)
ALTER TABLE treatments
    ADD CONSTRAINT fk_treatments_treatment_appointment_id FOREIGN KEY (treatment_appointment_id)
        REFERENCES appointments(appointment_id)

CREATE TABLE vaccines(
    vaccine_patient_id INT NOT NULL,
    vaccine_id INT NOT NULL,
    vaccine_name VARCHAR(255) NOT NULL,
    vaccine_patient_status BIT NULL,
    vaccine_date DATETIME NULL,
    vaccine_due_date DATETIME NULL
    CONSTRAINT pk_vaccines_vaccine_patient_id UNIQUE (vaccine_patient_id)
)

CREATE TABLE medicines(
    medicine_id INT NOT NULL,
    patient_id INT NOT NULL,
    medicine_name VARCHAR(255) NOT NULL,
    medicine_quantity BIGINT NOT NULL,
    medicine_type VARCHAR(255) NOT NULL
    CONSTRAINT pk_medicines_medicine_id PRIMARY KEY (medicine_id)
)
ALTER TABLE medicines
    ADD CONSTRAINT fk_medicines_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)

CREATE TABLE patient_family(
    patient_id INT NOT NULL,
    patient_father_firstname VARCHAR(255) NOT NULL,
    patient_father_lastname VARCHAR(255) NOT NULL,
    patient_mother_firstname VARCHAR(255) NOT NULL,
    patient_mother_lastname VARCHAR(255) NOT NULL,
    patient_father_contact_no BIGINT NOT NULL,
    patient_mother_contact_no BIGINT NOT NULL,
    patient_mother_medical_conditions VARCHAR(255) NULL,
    patient_father_medical_conditions VARCHAR(255) NULL,
)
ALTER TABLE patient_family
    ADD CONSTRAINT fk_patient_family_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)

CREATE TABLE emergency_contacts(
    patient_id INT NOT NULL,
    emergency_contact_firstname VARCHAR(255) NOT NULL,
    emergency_contact_lastname VARCHAR(255) NOT NULL,
    emergency_contact_address VARCHAR(255) NOT NULL,
    emergency_contact_email VARCHAR(255) NOT NULL,
    CONSTRAINT pk_emergency_contacts_patient_id PRIMARY KEY (patient_id)
)
ALTER TABLE emergency_contacts
    ADD CONSTRAINT fk_emergency_contacts_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)


CREATE TABLE lab(
    lab_no INT NOT NULL,
    lab_patient_id INT NOT NULL,
    lab_test_type VARCHAR(255) NOT NULL,
    lab_test_code INT NOT NULL,
    lab_patient_weight INT NOT NULL,
    lab_patient_height INT NOT NULL,
    lab_blood_pressure INT NOT NULL,
    lab_tempreture INT NOT NULL,
    lab_date DATETIME,
    lab_test_result BIT
    CONSTRAINT pk_lab_lab_no PRIMARY KEY (lab_no),
    CONSTRAINT u_lab_lab_weight_ UNIQUE (lab_patient_weight)
)
ALTER TABLE lab
    ADD CONSTRAINT fk_lab_patient_id FOREIGN KEY (lab_patient_id)
        REFERENCES patients(patient_id)


CREATE TABLE bills(
    bill_no INT NOT NULL,
    patient_id INT NOT NULL,
    bill_doctor_charge INT NOT NULL,
    bill_lab_charge INT NOT NULL,
    bill_insurance_code INT NOT NULL,
    bill_total_bill INT NOT NULL,
    CONSTRAINT pk_bills_bill_no PRIMARY KEY (bill_no)
)
ALTER TABLE bills
    ADD CONSTRAINT fk_bills_patient_id FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)

CREATE TABLE insurance(
    insurance_patient_id INT NOT NULL,
    insurance_policy_no INT NOT NULL,
    insurance_code INT NOT NULL,
    insurance_publish_date DATETIME NOT NULL,
    insurance_expiry_date DATETIME NOT NULL
    CONSTRAINT pk_insurance_insurance_patient_id PRIMARY KEY (insurance_patient_id)
)
ALTER TABLE insurance
    ADD CONSTRAINT fk_insurance_patient_id FOREIGN KEY (insurance_patient_id)
        REFERENCES patients(patient_id)

CREATE TABLE insurance_covers(
    insurance_cover_code INT NOT NULL,
    insurance_cover_company VARCHAR(255) NOT NULL,
    insurance_cover_entry_fee INT NOT NULL,
    insurance_cover_co_pay VARCHAR(255) NOT NULL,
    CONSTRAINT pk_insurance_covers_insurance_cover_code PRIMARY KEY (insurance_cover_code)
)
ALTER TABLE insurance
    ADD CONSTRAINT fk_insurance_insurance_code FOREIGN KEY (insurance_code)
        REFERENCES insurance_covers(insurance_cover_code)

CREATE TABLE test_price(
    test_code INT NOT NULL,
    test_price INT NULL
    CONSTRAINT pk_test_price_test_code PRIMARY KEY (test_code)
)

CREATE TABLE pharmacy(
    pharmacy_id INT IDENTITY NOT NULL,
    pharmacy_name VARCHAR(255) NOT NULL,
    pharmacy_address VARCHAR(255) NOT NULL,
    pharmacy_city VARCHAR(255) NOT NULL,
    pharmacy_state CHAR(2) NULL,
    pharmacy_zip INT NOT NULL,
    pharmacy_contact_no BIGINT NOT NULL,
    pharmacy_tax_number BIGINT NULL
)

GO
--UP DATA

INSERT INTO state_lookup
VALUES ('Alabama', 'AL'),
       ('Alaska', 'AK'),
       ('Arizona', 'AZ'),
       ('Arkansas', 'AR'),
       ('California', 'CA'),
       ('Colorado', 'CO'),
       ('Connecticut', 'CT'),
       ('Delaware', 'DE'),
       ('District of Columbia', 'DC'),
       ('Florida', 'FL'),
       ('Georgia', 'GA'),
       ('Hawaii', 'HI'),
       ('Idaho', 'ID'),
       ('Illinois', 'IL'),
       ('Indiana', 'IN'),
       ('Iowa', 'IA'),
       ('Kansas', 'KS'),
       ('Kentucky', 'KY'),
       ('Louisiana', 'LA'),
       ('Maine', 'ME'),
       ('Maryland', 'MD'),
       ('Massachusetts', 'MA'),
       ('Michigan', 'MI'),
       ('Minnesota', 'MN'),
       ('Mississippi', 'MS'),
       ('Missouri', 'MO'),
       ('Montana', 'MT'),
       ('Nebraska', 'NE'),
       ('Nevada', 'NV'),
       ('New Hampshire', 'NH'),
       ('New Jersey', 'NJ'),
       ('New Mexico', 'NM'),
       ('New York', 'NY'),
       ('North Carolina', 'NC'),
       ('North Dakota', 'ND'),
       ('Ohio', 'OH'),
       ('Oklahoma', 'OK'),
       ('Oregon', 'OR'),
       ('Pennsylvania', 'PA'),
       ('Rhode Island', 'RI'),
       ('South Carolina', 'SC'),
       ('South Dakota', 'SD'),
       ('Tennessee', 'TN'),
       ('Texas', 'TX'),
       ('Utah', 'UT'),
       ('Vermont', 'VT'),
       ('Virginia', 'VA'),
       ('Washington', 'WA'),
       ('West Virginia', 'WV'),
       ('Wisconsin', 'WI'),
       ('Wyoming', 'WY')
GO

INSERT INTO doctors (doctor_id, doctor_license_no, doctor_firstname, doctor_lastname, doctor_email, doctor_contact_no, doctor_experience)
VALUES (1001,1234, 'Steven', 'Nicolais', 'snicolais@gmail.com', 3152021222, 25),
       (1002,1435, 'Tom', 'Abbamont', 'tabbamont@gmail.com', 3151022822, 20),
       (1003,2314, 'Karina', 'Brown', 'kbrown@gmail.com', 3154045678, 18),
       (1004,4512, 'Daniel', 'Sari', 'dsari@gmail.com', 4356782345, 16),
       (1005,4489, 'Wayne', 'Lewis', 'wlevis@gmail.com', 2347612378, 10),
       (1006,4591, 'Jennifer', 'Gee', 'jgee@gmail.com', 4925673421, 5)

GO
INSERT INTO patients (patient_id, patient_firstname, patient_lastname, patient_nationality, patient_gender, patient_dob, patient_age, patient_address_line_1, patient_address_line_2, patient_city, patient_state, patient_zipcode, patient_existing_medical_conditions_1, patient_existing_medical_conditions_2, patient_allergy, patient_doctor_id)
VALUES (1, 'Indy', 'Draven', 'US', 'F', '2010-02-11', 12, '1961 Saint Marys Avenue', NULL, 'Syracuse', 'NY', 13202, NULL, NULL, 'no', 1001),
       (2, 'Eveline', 'Theodorus', 'US', 'F', '2007-06-08', 15, '4744 Buckhannan Avenue', NULL, 'Syracuse', 'NY', 13244, 'childhood obesity', NULL, 'no', 1002),
       (3, 'Sherlyn', 'Eliza', 'US', 'F', '2013-09-03', 9, '4883 Confederate Drive', NULL, 'Fayetteville', 'NY', 13066, NULL, NULL, 'no', 1003),
       (4, 'Danilla', 'Iggy', 'US', 'F', '2014-08-01', 8, '2835 Ashcraft Court', NULL, 'East Syracuse', 'NY', 13057, NULL, NULL, 'no', 1004),
       (5, 'Monte', 'Zanna', 'US', 'M', '2017-01-03', 5, '790 Buckhannan Avenue', NULL, 'Syracuse', 'NY', 13205, NULL, NULL, 'pollen', 1005),
       (6, 'Gaye', 'Chevonne', 'MEX', 'M', '2018-04-05', 4, '4560 Stone Lane', NULL, 'Syracuse', 'NY', 13207, NULL, NULL, 'no', 1006),
       (7, 'Eleanna', 'Marlene', 'CAN', 'F', '2015-06-09', 7, '1041 Oak Street', NULL, 'Fayetteville', 'NY', 13066, NULL, NULL, 'no', 1001),
       (8, 'Randy', 'Elisabeth', 'US', 'M', '2010-11-19', 12, '1295 Frederick Street', NULL, 'Syracuse', 'NY', 13244, 'dyslexia', NULL, 'peanut', 1002),
       (9, 'Jozefien', 'Dalton', 'US', 'M', '2010-12-25', 11, '3367 Collins Street', NULL, 'East Syracuse', 'NY', 13057, NULL, NULL, 'no', 1003),
       (10, 'Belinda', 'Fabian', 'US', 'F', '2017-09-08', 5, '4943 Yorkshire Circle', NULL, 'Syracuse', 'NY', 13208, NULL, NULL, 'no', 1004)
GO

INSERT INTO vaccines (vaccine_patient_id, vaccine_id, vaccine_name, vaccine_patient_status, vaccine_date, vaccine_due_date)
VALUES (1, 661, 'mmr', 0, '2019-05-06', NULL),
       (2, 662, 'dtap', 0, '2019-05-07', NULL),
       (3, 663, 'hepb', 0, '2019-05-08', NULL),
       (4, 661, 'mmr', 0, '2019-05-09', NULL),
       (5, 662, 'dtap', 0, '2019-05-10', NULL),
       (6, 663, 'hepb', 0, '2019-05-11', NULL),
       (7, 661, 'mmr', 0, '2019-05-12', NULL),
       (8, 662, 'dtap', 0, '2019-05-13', NULL),
       (9, 663, 'hepb', 0, '2019-05-14', NULL),
       (10, 661, 'mmr', 0, '2019-05-15', NULL),
       (11, 662, 'dtap', 1, '2022-05-06', NULL),
       (12, 663, 'hepb', 1, '2022-05-07', NULL),
       (13, 661, 'mmr', 1, '2022-05-08', NULL),
       (14, 662, 'dtap', 1, '2022-05-09', NULL)
GO

INSERT INTO test_price (test_code, test_price)
VALUES (4001, 800),
       (4002, 456),
       (4003, 78)
GO
INSERT INTO insurance_covers (insurance_cover_code, insurance_cover_company, insurance_cover_entry_fee, insurance_cover_co_pay)
VALUES (111222, 'Aetna', 0, 20),
       (112345, 'Cigna', 0, 50),
       (112312, 'Medicade', 100, 0),
       (115423, 'Humana', 200, 0)
GO
INSERT INTO lab (lab_no, lab_patient_id, lab_test_type, lab_test_code, lab_patient_weight, lab_patient_height, lab_blood_pressure, lab_tempreture, lab_date, lab_test_result)
VALUES (401, 3, 'blood', 4001, 56, 55, 98, 100, '2022-09-09', 1),
       (402, 6, 'blood', 4002, 78, 70, 98, 98, '2022-08-29', 0),
       (403, 3, 'blood', 4003, 63, 60, 98, 99, '2022-10-30', 1),
       (404, 8, 'blood', 4001, 74, 65, 98, 101, '2022-06-06', 0),
       (405, 9, 'blood', 4002, 100, 80, 98, 97, '2022-05-15', 1),
       (406, 10, 'blood', 4003, 85, 77, 98, 97, '2022-02-01', 0)
GO
INSERT INTO clinics (clinic_id, clinic_name, address_line_one, address_line_two, clinic_state, clinic_city, clinic_zip)
VALUES (1, 'Pediatrics Syracuse', '111 Sweet Rd.', NULL, 'NY', 'Syracuse', 13205),
       (2, 'Pediatrics Fayetteville', '222 Lyndon Rd.', NULL, 'NY', 'Fayetteville', 13066)
GO
INSERT INTO clinic_contacts (clinic_id, contact_no, email)
VALUES (1, 3158019999, 'clinic1@gmail.com'),
       (2, 3158029999, 'clinic2@gmail.com')
GO
INSERT INTO patient_family (patient_id, patient_father_firstname, patient_father_lastname, patient_mother_firstname, patient_mother_lastname, patient_father_contact_no, patient_mother_contact_no, patient_mother_medical_conditions, patient_father_medical_conditions)
VALUES (1, 'Scott', 'Draven', 'Jenna', 'Draven', 3152006397, 3152515999, 'High blood pressure', NULL),
       (2, 'James', 'Theodorus', 'Janet', 'Theodorus', 3152144728, 3152542318, NULL, 'Migreine'),
       (3, 'Dustin', 'Eliza', 'Alma', 'Eliza', 3152186802, 3152561390, NULL, NULL),
       (4, 'Tom', 'Iggy', 'Courtney', 'Iggy', 3152333242, 3152609207, 'Diabeties', NULL),
       (5, 'Toby', 'Zanna', 'Veronica', 'Zanna', 3152346711, 3152635415, NULL, NULL),
       (6, 'Doug', 'Chevonne', 'Raquel', 'Chevonne', 3152419639, 3152787424, NULL, NULL),
       (7, 'Albert', 'Marlene', 'Loretta', 'Marlene', 3152427244, 3152886656, NULL, NULL),
       (8, 'Frank', 'Elisabeth', 'Yvonne', 'Moor', 3152430236, 3152893529, NULL, NULL),
       (9, 'John', 'Dalton', 'Tonya', 'Dalton', 3152476241, 3152954187, NULL, NULL),
       (10, 'Angelo', 'Fabian', 'Victoria', 'Fabian', 3152499796, 3152995056, NULL, NULL)
GO
INSERT INTO insurance (insurance_patient_id, insurance_policy_no, insurance_code, insurance_publish_date, insurance_expiry_date)
VALUES (1, 2001, 111222, '2022-06-05', '2023-06-05'),
       (2, 2002, 112345, '2002-04-05', '2023-04-05'),
       (3, 2003, 112312, '2022-03-05', '2023-03-05'),
       (4, 2004, 115423, '2022-06-05', '2023-06-05'),
       (5, 2001, 111222, '2002-04-05', '2023-04-05'),
       (6, 2002, 112345, '2022-03-05', '2023-03-05'),
       (7, 2003, 112312, '2022-06-05', '2023-06-05'),
       (8, 2004, 115423, '2002-04-05', '2023-04-05'),
       (9, 2001, 111222, '2022-03-05', '2023-03-05'),
       (10, 2002, 112345, '2022-06-05', '2023-06-05')
GO
INSERT INTO employees (employee_id, emp_firstname, emp_lastname, emp_title, employee_clinic_id)
VALUES (1101, 'Ralph', 'Jacobs', 'receptionist', 1),
       (1102, 'Everett', 'Green', 'receptionist', 2),
       (1103, 'Pearl', 'More', 'receptionist', 1),
       (1104, 'Louis', 'Chase', 'receptionist', 2),
       (1105, 'Derrick', 'Lozano', 'nurse', 1),
       (1106, 'Eleanor', 'Petersen', 'nurse', 1),
       (1107, 'Claudia', 'Browning', 'nurse', 1),
       (1108, 'Paulette', 'Schwartz', 'nurse', 2),
       (1109, 'Kyle', 'Rhodes', 'nurse', 2),
       (1110, 'Emily', 'Ronald', 'nurse', 2)
GO
INSERT INTO appointments (appointment_id, appointment_type, appointment_created_date, appointment_patient_id)
VALUES (10001, 'well visit', '2022-09-08', 2),
       (10002, 'well visit', '2022-04-05', 4),
       (10003, 'vaccine', '2021-12-05', 3),
       (10004, 'vaccine', '2022-06-07', 1),
       (10005, 'sick', '2022-10-05', 8),
       (10006, 'sick', '2022-11-05', 7),
       (10007, 'sick', '2022-07-08', 9),
       (10008, 'well visit', '2022-10-20', 10),
       (10009, 'well visit', '2022-12-05', 5),
       (10010, 'vaccine', '2022-12-04', 6)
GO
INSERT INTO emergency_contacts (patient_id, emergency_contact_firstname, emergency_contact_lastname, emergency_contact_address, emergency_contact_email)
VALUES (1, 'Tiffany', 'Davis', '417 Churchill Ave #409 Syracuse, NY, 13205', 'tdavis@gmail.com'),
       (2, 'Joseph', 'Strickland', '5301 Springwater Dr Fayetteville, NY, 13066', 'jstrickland@gmail.com'),
       (3, 'Ernest', 'Hatfield', '148 W Brighton Ave Syracuse, NY, 13205', 'ehatfield@yahoo.com'),
       (4, 'Sylvia', 'McIntire', '700 E Genesee St Fayetteville, NY, 13066', 'smclintire@yahoo.com'),
       (5, 'Barbara', 'McAllister', '5100 Highbridge St Fayetteville, NY, 13066', 'bmcall@hotmai.com'),
       (6, 'Ingrid', 'George', '1206 Midland Ave Syracuse, NY, 13205', 'igeorge@gmail.com'),
       (7, 'Owen', 'Barker', '390 W Newell St Syracuse, NY, 13205', 'obarker@yahoo.com'),
       (8, 'Bryan', 'Webster', '5100 Highbridge St #APT 53D Fayetteville, NY, 13066', 'bwebster@gmail.com'),
       (9, 'Kellie', 'Ayala', '7824 Karakul Ln Fayetteville, NY, 1306', 'kayala@gmail.com'),
       (10, 'Joyce', 'Mueller', '2935 S Salina St Syracuse, NY, 1320', 'jmueller@yahoo.com')
GO
INSERT INTO treatments (treatment_appointment_id, treatment_doctor_id)
VALUES (10001, 1001),
       (10002, 1002),
       (10003, 1003),
       (10004, 1004),
       (10005, 1005),
       (10006, 1006),
       (10007, 1001),
       (10008, 1002),
       (10009, 1003),
       (10010, 1004)
GO
INSERT INTO bills (bill_no, patient_id, bill_doctor_charge, bill_lab_charge, bill_insurance_code, bill_total_bill)
VALUES (901, 4, 100, 156, 111222, 256),
       (902, 9, 160, 205, 112345, 365),
       (903, 1, 200, 589, 112312, 789),
       (904, 3, 100, 0, 115423, 100),
       (905, 5, 200, 265, 111222, 465),
       (906, 7, 250, 0, 112345, 250),
       (907, 8, 150, 148, 112312, 298),
       (908, 10, 200, 303, 115423, 503)

GO
INSERT INTO fix_appointments (fix_appointment_id, fix_clinic_id)
VALUES (10001, 1),
       (10002, 2),
       (10003, 1),
       (10004, 2),
       (10005, 1),
       (10006, 2),
       (10007, 1),
       (10008, 2),
       (10009, 1),
       (10010, 2)
GO
INSERT INTO pharmacy (pharmacy_name, pharmacy_address, pharmacy_city, pharmacy_zip, pharmacy_contact_no, pharmacy_tax_number)
VALUES ('BeWell', '5264 Jamesville Rd', 'Syracuse', 13214, 3154461673, 3154461675),
       ('Kinney', '206 Easterly Ter', 'Syracuse', 13214, 3154468185, 3154468187),
       ('Walgreens', '104 Harpers Ct', 'Syracuse', 13214, 3159561234, 3159561236)

GO

--VERIFY


-- TRIGGER 1 - TO update vaccine status to vaccinated once the vaccine date is updated in the table automatically.
DROP TRIGGER IF EXISTS t_after_update_vaccine_status
GO 
CREATE TRIGGER t_after_update_vaccine_status on vaccines
AFTER INSERT, UPDATE
AS BEGIN
    IF UPDATE(vaccine_date) BEGIN
    update vaccines   
    SET vaccine_patient_status='Vaccinated' 
END
end 

--VIEWS1 WHICH PATIENTS REFER TO THE DOCTOR NAME ALONG WITH THE CLINIC THEY VISIT.
select clinic_name, doctor_license_no, doctor_firstname + ' ' + doctor_lastname as doctor_name, patient_firstname + ' ' + patient_lastname  as patient_name from clinics c
left join doctors d
on c.clinic_id=d. doctor_clinic_id
left join patients p
on 
d.doctor_id=p.patient_doctor_id  

--VIEWS2 INSIGHTS FOR PHARMACY TO GET THE ALLERGY COUNT AND GET MEDICINE COUNT IN STOCK AND RECOMMEND TO DOCTORS BASED ON THE BELOW VIEW
select c.clinic_name, d.doctor_license_no, d.doctor_firstname + ' ' + d.doctor_lastname as doctor_name, count(distinct p.patient_allergy)  as allergy_count from clinics  as c
left join doctors as d
on c.clinic_id=d.doctor_clinic_id
left join patients p
on d.doctor_id=p.patient_doctor_id group by c.clinic_name,d.doctor_license_no,d.doctor_firstname,d.doctor_lastname

