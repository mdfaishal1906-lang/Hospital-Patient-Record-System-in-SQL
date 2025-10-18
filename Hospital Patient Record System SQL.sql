USE EXCELR;

-- Create Database
CREATE DATABASE Hospital_Management;
USE Hospital_Management;

-- Patient Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    contact_number VARCHAR(15),
    address VARCHAR(200)
);

-- Doctor Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    specialization VARCHAR(50),
    contact_number VARCHAR(15)
);

-- Appointment Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    diagnosis VARCHAR(100),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Billing Table
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    treatment_cost DECIMAL(10,2),
    medicine_cost DECIMAL(10,2),
    total_bill AS (treatment_cost + medicine_cost) STORED,
    payment_status VARCHAR(20),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);


-- Patients
INSERT INTO Patients (patient_name, age, gender, contact_number, address) VALUES
('Amit Sharma', 34, 'Male', '9876543210', 'Delhi'),
('Neha Singh', 28, 'Female', '9876501234', 'Mumbai'),
('Rahul Verma', 45, 'Male', '9988776655', 'Bangalore'),
('Priya Nair', 52, 'Female', '9988123456', 'Chennai');

-- Doctors
INSERT INTO Doctors (doctor_name, specialization, contact_number) VALUES
('Dr. Meera Rao', 'Cardiologist', '9123456789'),
('Dr. Anil Kapoor', 'Dermatologist', '9123004567'),
('Dr. Suman Das', 'Neurologist', '9877001122');

-- Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, diagnosis) VALUES
(1, 1, '2025-09-10', 'Heart Checkup'),
(2, 2, '2025-09-12', 'Skin Allergy'),
(3, 1, '2025-09-15', 'Blood Pressure'),
(4, 3, '2025-09-18', 'Headache');

-- Billing
INSERT INTO Billing (appointment_id, treatment_cost, medicine_cost, payment_status) VALUES
(1, 1200.00, 300.00, 'Paid'),
(2, 800.00, 200.00, 'Pending'),
(3, 1500.00, 500.00, 'Paid'),
(4, 1000.00, 250.00, 'Pending');


/*Retrieve all patient and doctor appointment details*/

SELECT p.patient_name, d.doctor_name, d.specialization, a.appointment_date, a.diagnosis
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

/*Total revenue earned by the hospital*/

SELECT SUM(total_bill) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';


/*Doctor-wise number of patients treated*/

SELECT d.doctor_name, COUNT(a.patient_id) AS total_patients
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_name
ORDER BY total_patients DESC;


/*List of patients with pending bills*/

SELECT p.patient_name, b.total_bill, b.payment_status
FROM Billing b
JOIN Appointments a ON b.appointment_id = a.appointment_id
JOIN Patients p ON a.patient_id = p.patient_id
WHERE b.payment_status = 'Pending';


/*Average treatment cost by doctor*/

SELECT d.doctor_name, ROUND(AVG(b.treatment_cost),2) AS avg_treatment_cost
FROM Billing b
JOIN Appointments a ON b.appointment_id = a.appointment_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_name;


/*Find patients treated by a specific doctor*/

SELECT p.patient_name, a.diagnosis, a.appointment_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE d.doctor_name = 'Dr. Meera Rao'
ORDER BY a.appointment_date DESC;


/*Get list of appointments within a specific date range*/

SELECT a.appointment_id, p.patient_name, d.doctor_name, a.appointment_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date BETWEEN '2025-09-10' AND '2025-09-20'
ORDER BY a.appointment_date;


/*Find the most frequently visited doctor*/

SELECT d.doctor_name, COUNT(a.appointment_id) AS total_visits
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_name
ORDER BY total_visits DESC
LIMIT 1;

