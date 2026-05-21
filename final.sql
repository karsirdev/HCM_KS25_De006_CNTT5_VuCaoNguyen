DROP DATABASE IF EXISTS final_db;
CREATE DATABASE final_db;
USE final_db;



DROP TABLE IF EXISTS Enrollments_detail;
DROP TABLE IF EXISTS Academic_logs; 
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;


CREATE TABLE Courses (
	course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    department VARCHAR(50) NOT NULL,
    creation_date timestamp NOT NULL
);

CREATE TABLE Students (
	student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    major VARCHAR(50) NOT NULL,
    phone_number VARCHAR(14) NOT NULL UNIQUE,
    gpa DECIMAL(2,1) DEFAULT 4.0,
    
    CONSTRAINT ck_gpa_student CHECK (gpa BETWEEN 0.0 AND 4.0)
);

CREATE TABLE Enrollments (
	enrollment_id VARCHAR(10) PRIMARY KEY,
    course_id INT NOT NULL,
    student_id INT NOT NULL,
    enroll_time TIMESTAMP NOT NULL,
    credits INT,
    status ENUM('Pending', 'Completed', 'Dropped'),
    
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
    
    CONSTRAINT ck_credit CHECK (credits > 0)
);

CREATE TABLE Enrollment_details (
	detail_id VARCHAR(10) PRIMARY KEY,
    enrollment_id VARCHAR(10) NOT NULL,
    attendance_check VARCHAR(50) NOT NULL,
    detail_date timestamp NOT NULL,
    
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

CREATE TABLE Academic_logs (
	log_id INT PRIMARY KEY,
    detail_id VARCHAR(10) NOT NULL,
    student_id INT NOT NULL,
    log_time timestamp NOT NULL,
    note TEXT,
    
    FOREIGN KEY (detail_id) REFERENCES Enrollment_details(detail_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


INSERT INTO Courses (course_id, course_name, course_code, department, creation_date)
VALUES (1, 'Lap Trinh Java', 'JAVA01', 'CNTT', '2023-12-03'),
(2, 'Cau Truc Du Lieu', 'DSA02', 'Khoa Hoc May Tinh', '1996-11-25'),
(3, 'Co So Du Lieu', 'SQL03','CNTT', '2001-07-08'),
(4, 'Mang May Tinh', 'NET04', 'Truyen Thong', '1998-01-19'),
(5, 'Tri Tue Nhan Tao','AI05', 'Khoa hoc May Tinh', '2000-09-30');

INSERT INTO Students (student_id, full_name, major, phone_number, gpa)
VALUE (1, 'Nguyen Van Hai', 'He Thong TT', '0931112223', 3.8),
(2, 'ran Thu Ha', 'Ky Thuat PM', '0932223334', 4.0),
(3, 'Le Quoc Tuan', 'An Toan TT', '0933334445', 3.6),
(4, 'Pham Minh Chau', 'Du Lieu Lon', '0934445556', 3.9),
(5, 'Pham Gia Bao', 'Ky Thuat PM', '0935556667', 3.7);

INSERT INTO Enrollments(enrollment_id, course_id, student_id, enroll_time, credits, status)
VALUES ('7001', 1, 1, '2024-05-20 08:00', 3, 'Pending'),
('7002', 2, 2, '2024-05-20 09:30', 4, 'Completed'),
('7003', 3, 3, '2024-05-20 10:15', 3, 'Pending'),
('7004', 4, 5, '2024-05-20 07:00', 3, 'Completed'),
('7005', 5, 4, '2024-05-20 08:45', 4, 'Dropped');

INSERT INTO Enrollment_details (detail_id, enrollment_id, attendance_check, detail_date)
VALUES ('8001', '7002', 'Du Dieu Kien Thi', '2024-05-20 10:00'),
('8002', '7004', 'Vang 1 buoi', '2024-05-20 08:00'),
('8003', '7001', 'Dang hoc', '2024-05-20 09:00'),
('8004', '7003', 'Nghi Phep', '2024-05-20 11:00'),
('8005', '7005', 'Khong di hoc', '2024-05-20 09:00');

INSERT INTO Academic_logs (log_id, detail_id, student_id, log_time, note)
VALUES (1, '8003', 1, '2024-05-20 09:05', 'Bat Dau Lop Hoc'),
(2, '8001', 2, '2024-05-20 10:05', 'Hoan Tat Mon Hoc'),
(3, '8004', 3, '2024-05-20 11:10', 'Dang Xep Lich Bu'),
(4, '8002', 5, '2024-05-20 08:10', 'Cho Phe Duyet Diem'),
(5, '8005', 4, '2024-05-20 09:05', 'Huy Do Vang Qua So Buoi');


-- ----------------------------------------------------------


-- cau 1 them 1 tin chi
UPDATE Enrollments 
SET credits = credits + 1 WHERE status = 'Completed' AND enroll_time < '2000-01-01';

SELECT * FROM Enrollments;


-- cau 2 Xoa ban ghi co truoc 20-05-2024
DELETE FROM Academic_logs WHERE log_time < '2024-05-20';


-- ----------------------------------------------------------


-- Phan 3
-- Cau 1 Liet ke GPA > 3.8  thuoc Ky Thuat PM
SELECT full_name, major, gpa FROM Students WHERE gpa > 3.8 OR major = 'Ky Thua PM';


-- cau 2 liet ke cac mon co tu 1998-01-01 den 2001-12-31 va bat dau bang A
SELECT course_name, course_code FROM Courses WHERE (creation_date BETWEEN '1998-01-01' AND '2001-12-31') AND course_code LIKE "A%";

-- cau 3 Sap xep so tin chi giam gian lay 2 ban ghi o trang 2
SELECT enrollment_id, enroll_time, credits FROM Enrollments 
ORDER BY credits DESC LIMIT 2 OFFSET 2;


-- --------------------------------------------------------------



-- Phan 4
-- cau 1
SELECT course_name, full_name, major, credits, creation_date FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;


-- cau 2
SELECT full_name, credits, status FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
WHERE status = 'Complete' AND credits > 120;

-- cau 3
SELECT s.student_id, s.full_name, s.gpa, AVG(gpa) AS gpa_max FROM Students s
ORDER BY gpa_max DESC LIMIT 1;



-- -----------------------------------------------------------


-- Phan 5 
-- cau 1
CREATE INDEX idx_status ON Enrollments(status, credits);

-- cau 2
CREATE VIEW view_Students AS 
SELECT s.full_name, c.course_name, e.credits, e.status FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id WHERE status <> 'Dropped';


-- ---------------------------------------------------------------


-- Phan 6 
-- cau 1
DELIMITER //
CREATE TRIGGER trg_before_enrollments
BEFORE UPDATE ON Enrollments
FOR EACH ROW
BEGIN 
	IF OLD.status = 'Completed' THEN
	INSERT INTO Academic_logs (detail_id, student_id, note)
	VALUES ('8007', '1', 'Course completed');
	END IF;
END //
DELIMITER ;

