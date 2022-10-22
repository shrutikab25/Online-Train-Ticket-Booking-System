USE master

DROP DATABASE RAILWAY

CREATE DATABASE RAILWAY

GO

USE RAILWAY

GO

--CREATE TABLES

CREATE TABLE COUNTRY(
[country_id] int primary key,
[country_name] varchar(max)
)

CREATE TABLE STATE(
[state_id] int primary key,
[state_name] varchar(max),
[country_id] int foreign key references [COUNTRY](country_id)
)

CREATE TABLE CITY(
[city_id] int primary key,
[city_name] varchar(max),
[state_id] int foreign key references [STATE](state_id)
)

CREATE TABLE PERMISSION(
[permission_id] int identity(1,1) primary key,
[permission_name] varchar(max),
[access] varchar(max)
)

CREATE TABLE ROLES(
[role_id] int identity(1,1) primary key,
[role_name] varchar(max),
[permission_id] int foreign key references [PERMISSION](permission_id)
)

CREATE TABLE WALLET(
[wallet_id] int primary key,
[amount] float
)

CREATE TABLE [USER](
[user_id] int identity(1,1) primary key,
[name] varchar(max),
[email] varchar(100) not null unique,
[password] varchar(12),
[dob] date,
[phone_no] bigint,
[city_id] int foreign key references [CITY](city_id),
[security_qn] varchar(max),
[security_ans] varchar(max),
[role_id] int foreign key references [ROLES](role_id),
[wallet_id] int foreign key references [WALLET](wallet_id)
)


CREATE TABLE STATION(
[station_id] varchar(10) not null primary key,
[station_name] varchar(30),
[city_id] int foreign key references [CITY](city_id)
)

CREATE TABLE TRAIN(
[train_no] int primary key,
[train_name] varchar(max),
[train_type] varchar(max)
)

CREATE TABLE [SOURCE STATION](
[train_no]  int foreign key references TRAIN(train_no),
[source_station_id] varchar(10) foreign key references [STATION](station_id)
)

CREATE TABLE [DESTINATION STATION](
[train_no]  int foreign key references TRAIN(train_no),
[destination_station_id] varchar(10) foreign key references [STATION](station_id)
)

CREATE TABLE [SOURCE DATE TIME](
[time_id] int identity(1,1) primary key,
[source_station_id] varchar(10) foreign key references [STATION](station_id),
[train_no]  int foreign key references TRAIN(train_no),
[source_station_date_time] smalldatetime
)

CREATE TABLE [DESTINATION DATE TIME](
[time_id] int identity(1,1) primary key,
[destination_station_id] varchar(10) foreign key references [STATION](station_id),
[train_no]  int foreign key references TRAIN(train_no),
[destination_station_date_time] smalldatetime
)

CREATE TABLE ROUTE(
[train_no] int foreign key references TRAIN(train_no),
[route_id] int identity(1,1) primary key,
[time] time(1),
[date] date,
[stop_number] int,
[station_id]  varchar(10) foreign key references [STATION](station_id)
)

CREATE TABLE QUOTA(
[quota_id] varchar(6) primary key,
[quota_name] varchar(max),
)


CREATE TABLE CLASS(
[class_id] varchar(4) primary key,
[class_name] varchar(30)
)

CREATE TABLE [BOOKED SEATS](
[train_no] int foreign key references [TRAIN](train_no),
[class_id] varchar(4) foreign key references [CLASS](class_id),
[quota_id] varchar(6) foreign key references [QUOTA](quota_id),
[date_time] smalldatetime, 
[booked_seats] int
)

CREATE TABLE [AVAILABLE SEATS](
[train_no] int foreign key references [TRAIN](train_no),
[class_id] varchar(4) foreign key references [CLASS](class_id),
[quota_id] varchar(6) FOREIGN KEY REFERENCES [QUOTA](quota_id),
[date_time] smalldatetime,
[available_seats] int
)

CREATE TABLE [WAITING SEATS](
[train_no] int foreign key references [TRAIN](train_no),
[class_id] varchar(4) foreign key references [CLASS](class_id),
[quota_id] varchar(6) foreign key references [QUOTA](quota_id),
[date_time] smalldatetime,
[waiting_seats] int
)

CREATE TABLE [TRANSACTION](
[transaction_id] int primary key,
amount [float],
[payment_type] varchar(20),
[payment_status] varchar(10)
)


CREATE TABLE PRICE(
[train_no] int foreign key references [TRAIN](train_no),
[class_id] varchar(4) foreign key references [CLASS] (class_id),
[quota_id] varchar(6) foreign key references [QUOTA](Quota_id),
[price_id] int identity(1,1) primary key,
[amount] float
)

CREATE TABLE PNR(
[PNR_no] bigint primary key,
[status_PNR] varchar(20)
)

CREATE TABLE [TRAVEL INSURANCE](
[insurance_id] int identity(1,1) primary key,
[insurance_name] varchar(50),
[insurance_amount] float
)

CREATE TABLE OFFERS(
[offer_id] int identity(1,1) primary key,
[offer_name] varchar(max),
[description] varchar(max),
[end_date] date,
[amount] float
)

CREATE TABLE RESERVATION(
[reservation_id] bigint identity(101010,1) primary key,
[user_id] int foreign key references [USER](user_id),
[train_no] int foreign key references [TRAIN](train_no),
[class_id] varchar(4) foreign key references [CLASS](class_id),
[quota_id] varchar(6) foreign key references [QUOTA](quota_id),
[arrival_station_id] varchar(10) foreign key references [STATION](station_id),
[departure_station_id] varchar(10) foreign key references [STATION](station_id),
[arrival_date_time] smalldatetime,
[departure_date_time] smalldatetime,
[PNR_no] bigint foreign key references [PNR](PNR_no),
[amount] float,
[transaction_id] int foreign key references [TRANSACTION](transaction_id),
[insurance_id] int foreign key references [TRAVEL INSURANCE](insurance_id),
[offer_id] int foreign key references [OFFERS](offer_id)
)	 

CREATE TABLE PASSENGER(
[reservation_id] bigint foreign key references [RESERVATION](reservation_id),
[passenger_id] int primary key,
[name] varchar(30),
[age] int,
[gender] varchar(1),
[seat_no] int,
[birthpreference] varchar(max)
)

CREATE TABLE CANCELLATION(
[cancellation_id] int identity(1,1) primary key,
[user_id] int foreign key references [USER](user_id),
[reservation_id] bigint foreign key references [RESERVATION](reservation_id),
[type_cancellation] varchar(20)
) 

CREATE TABLE REFUND(
[cancellation_id] int foreign key references CANCELLATION(cancellation_id),
[refund_id] int identity(1,1) primary key,
[transaction_id] int foreign key references [TRANSACTION](transaction_id),
[refund_initiated_date] smalldatetime
)

CREATE TABLE [PASSENGER CONTACT INFO](
[reservation_id] bigint foreign key references [RESERVATION](reservation_id),
[mail_id] varchar(50),
[phone_no] bigint
)

CREATE TABLE FEEDBACK(
[reservation_id] bigint foreign key references [RESERVATION](reservation_id),
[user_id] int foreign key references [USER](user_id),
[feedback_id] int primary key,
[feedback] varchar(max)
)

CREATE TABLE [SHIFT](
[shift_id] int identity(1,1) primary key,
[start_time] time,
[end_time] time,
)

CREATE TABLE SALARY(
[salary_id] int primary key,
[transaction_id] int foreign key references [TRANSACTION](transaction_id),
[last credited] smalldatetime,
[salary] int
)

CREATE TABLE DRIVER(
[driver_id] int identity(1,1) primary key,
[shift_id] int foreign key references [SHIFT](shift_id),
[driver_name] varchar(max),
[no_of_days_worked] int,
[train_no] int foreign key references [TRAIN](train_no),
[salary_id] int foreign key references [SALARY](salary_id)
)

CREATE TABLE STAFFS(
[staff_id] int identity(1,1) primary key,
[staff_name] varchar(50),
[shift_id] int foreign key references [SHIFT](shift_id),
[station_id] varchar(10) foreign key references [STATION](station_id),
[salary_id] int foreign key references [SALARY](salary_id),
[duty] varchar(40)
)

CREATE TABLE CONTRACT(
[contract_id] int identity(1,1) primary key,
[person_name] varchar(50),
[phone_no] bigint
)

CREATE TABLE PANTRY(
[pantry_no] int identity(1,1) primary key,
[contract_id] int foreign key references [CONTRACT](contract_id),
[train_no] int foreign key references [TRAIN](train_no)
)

CREATE TABLE [PLATFORM](
[train_no] int foreign key references [TRAIN](train_no),
[station_id]  varchar(10) foreign key references [STATION](station_id),
[platform_no] int,
[date_time] smalldatetime
)

CREATE TABLE GOODS(
[train_no] int foreign key references [TRAIN](train_no),
[goods_id] int identity(1,1) primary key,
[source_route_id] int,
[destination_route_id] int,
[type] varchar(50),
[price] float
)

CREATE TABLE VENDOR(
[vendor_id] int identity(1,1) primary key,
[name] varchar(50),
[dob] date,
[phone_no] bigint,
[email] varchar(max)
)

CREATE TABLE AD(
[ad_id] int identity(1,1) primary key,
[ad_name] varchar(max),
[description] varchar(max),
[start_datetime] smalldatetime,
[end_datetime] smalldatetime,
[transaction_id] int foreign key references [TRANSACTION](transaction_id),
[price] float,
[vendor_id] int foreign key references [VENDOR](vendor_id)
)

--INSERT DATA

INSERT INTO COUNTRY 
VALUES (91,'India'),(92,'China')

INSERT INTO STATE
VALUES (28, 'Tamilnadu',91),(27,'Maharashtra',91)

INSERT INTO CITY
VALUES (1, 'Chennai',28),(2, 'Pune', 27),(3,'Karur',28),(4,'Trichy',28),(5,'Villupuram',28) 

INSERT INTO PERMISSION
VALUES ('Ownership','RWX'),('Non-Ownership','RX')

INSERT INTO ROLES
VALUES ('Customer',2),('Admin',1)

INSERT INTO WALLET
VALUES (1, 0),(2,0)

INSERT INTO [USER]
VALUES ('Mustafa','iammustafatz26@gmail.com','abcdef12','2001-03-26', 918122697876, 1, 'What is my fav car?', 'Benz', 1,1),('Neha','neha@gmail.com','123456ab','2001-03-26', 918380894572, 2, 'What is my fav pet?', 'Fish', 1,2)
 
INSERT INTO STATION
VALUES ('MAS','Chennai Central', 1),('PUNE','Pune Central', 2),('KRR','Karur', 3),('TP','Tiruchirappalli Fort',4),('VM','Villupuram Junction',5)

INSERT INTO TRAIN
VALUES (22651, 'MAS KRR','EXPRESS'),(16159,'KRR PUNE','EXPRESS'),(160059,'MAS PUNE','DELUXE')

INSERT INTO [SOURCE STATION]
VALUES (22651,'MAS'),(16159,'KRR'),(160059,'MAS')

INSERT INTO [DESTINATION STATION]
VALUES (22651,'KRR'),(16159,'PUNE'),(160059,'PUNE')

INSERT INTO [SOURCE DATE TIME]
VALUES ('MAS',22651,'2022-08-13 00:00:00'),('KRR',16159,'2022-08-14 02:00:00'),('MAS',160059,'2022-08-13 03:00:00')

INSERT INTO [DESTINATION DATE TIME]
VALUES ('KRR',22651,'2022-08-14 06:00:00'),('PUNE',16159,'2022-08-15 00:00:00'),('PUNE',160059,'2022-08-15 10:00:00')

INSERT INTO ROUTE
VALUES (22651, '00:00:00.1','2022-08-13', 1, 'MAS'),(22651,'03:00:00.1','2022-08-14', 2, 'VM'),(22651, '04:00:00.1','2022-08-14', 3, 'TP'),(22651, '06:00:00.1','2022-08-14', 4, 'KRR'),(16159, '02:00:00.1','2022-08-14',1,'KRR'),(16159, '04:00:00.1','2022-08-14',2,'TP'),(16159, '00:00:00.1','2022-08-15',3,'PUNE')

INSERT INTO QUOTA
VALUES ('GN', 'General'),('L', 'Ladies'),('D', 'Defence'),('H', 'Handicapped'),('T', 'Toursist')

INSERT INTO CLASS
VALUES ('1A', 'First AC'),('2A', 'Second AC'),('3A', 'Third AC'),('CC', 'AC Chair Car'),('2S','Second Seating'),('FC','First Class'),('3E', '3 AC Economy'),('SL','Sleeper')

INSERT INTO [BOOKED SEATS]
VALUES (22651,'1A','GN', '2022-08-13 00:00:00', 24),(22651,'2A','GN', '2022-08-13 00:00:00', 44),(22651,'SL','GN', '2022-08-13 00:00:00', 164),(16159,'1A','GN','2022-08-14 02:00:00',26)

INSERT INTO [WAITING SEATS]
VALUES (22651,'1A','GN', '2022-08-13 00:00:00', 0),(22651,'2A','GN', '2022-08-13 00:00:00', 0),(22651,'SL','GN', '2022-08-13 00:00:00', 22),(16159,'1A','GN','2022-08-14 02:00:00',0)

INSERT INTO [AVAILABLE SEATS]
VALUES (22651,'1A','GN', '2022-08-13 00:00:00', 36),(22651,'2A','GN', '2022-08-13 00:00:00', 16),(22651,'SL','GN', '2022-08-13 00:00:00', 0),(16159,'1A','GN','2022-08-14 02:00:00',38)

INSERT INTO PRICE
VALUES (22651,'1A','GN',1000),(22651,'2A','GN', 800 ),(22651,'SL','GN', 360)

INSERT INTO [TRAVEL INSURANCE]
VALUES ('Health', 50.00),('Senior Citizen', 100.00)

INSERT INTO OFFERS
VALUES ('INDEPENDENTDEAL','Independence day ticket offer','2022-08-15',100.00)

INSERT INTO PNR
VALUES (123456,'CNF'),(123457,'CNF')

INSERT INTO [TRANSACTION]
VALUES (1001, 4100.00, 'UPI-DEBIT', 'SUCCESS'),(1002, 40000.00, 'CREDIT', 'SUCCESS'),(1003, 25000.00, 'CREDIT', 'SUCCESS'),(1004, 2500000.00, 'IOB-DEBIT', 'SUCCESS'),(1005, 5000.00, 'IOB-DEBIT', 'SUCCESS')  

INSERT INTO RESERVATION
VALUES (1, 22651, '1A','GN', 'MAS', 'KRR', '2022-08-13 00:00:00', '2022-08-14 00:00:00', 123456, 4100.00, 1001, null,1),(1, 16159, '1A','GN','KRR','PUNE', '2022-08-14 02:00:00', '2022-08-15 00:00:00', 123457, 5000.00, 1005, 1,null)

INSERT INTO PASSENGER
VALUES (101010, 1, 'Mustafa', 21, 'M', 16, null),(101010, 2, 'Neha', 23, 'F', 17, null),(101011, 3, 'Shruthika', 18, 'F', 16, null),(101011, 4, 'Gireesh', 25, 'M', 19, null)

INSERT INTO [PASSENGER CONTACT INFO]
VALUES (101010, 'iammustafatz26@gmail.com', 918122697876)

INSERT INTO FEEDBACK
VALUES (101010, 1, 100, 'Good service of food and train. Enjoyed my Journey.')


INSERT INTO SHIFT
VALUES ('8:00:00.0','14:00:00.0'),('14:01:00.0','00:00:00.0'),('00:01:00.0','08:00:00.0')

INSERT INTO SALARY
VALUES (1, 1002, '2022-08-12 14:00:00', 40000),(2, 1003, '2022-08-12 14:00:00', 25000.00)

INSERT INTO DRIVER
VALUES ( 1, 'Murali', 32, 22651, 1)

INSERT INTO STAFFS
VALUES ( 'Ram', 2, 'MAS', 2, 'Cleaning')

INSERT INTO [PLATFORM]
VALUES (22651, 'MAS', 1, '2022-08-13 00:00:00')

INSERT INTO CONTRACT
VALUES ('Lingam', 919988776612)

INSERT INTO PANTRY
VALUES ( 1, 22651)

INSERT INTO GOODS
VALUES (22651, 1, 3, 'Electronics', 200)

INSERT INTO VENDOR
VALUES ('Karan','2001-03-26',911234567890,'karan@gmail.com')

INSERT INTO AD
VALUES ('Dettol antiseptic', 'Keep the memories, but not the bacteria','2022-02-23 5:00:00','2022-08-14 5:00:00', 1004, 2500000.00,1)