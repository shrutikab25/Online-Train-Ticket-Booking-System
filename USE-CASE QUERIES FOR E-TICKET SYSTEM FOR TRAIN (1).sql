USE RAILWAY

-- To read the details of the train of a particular station.

SELECT * FROM [ROUTE]
INNER JOIN [TRAIN]
ON ROUTE.train_no = TRAIN.train_no
WHERE ROUTE.station_id='KRR'

-- To read the reservation details of a particular passenger.

SELECT * FROM RESERVATION
INNER JOIN PASSENGER
ON RESERVATION.reservation_id=PASSENGER.reservation_id
WHERE passenger_id=1

-- To read the driver, salary and shift details of the train driver.

SELECT a.driver_name,a.no_of_days_worked,b.salary,b.[last credited],c.start_time,c.end_time  FROM DRIVER as a
INNER JOIN SALARY as b
ON a.salary_id=b.salary_id
INNER JOIN SHIFT as c
ON a.shift_id=c.shift_id

-- To read the name and salary of staffs who get maximum salary.

SELECT b.staff_name,
MAX(a.SALARY) OVER(PARTITION BY SALARY) AS [staff_salary] FROM SALARY as a
INNER JOIN STAFFS as b
on a.salary_id=b.salary_id

-- To read the number of seats available, waiting and booked of a particular train number and date, time with their class and quota.

SELECT a.train_no,a.class_id,a.quota_id,a.date_time,a.available_seats,b.booked_seats,c.waiting_seats FROM [AVAILABLE SEATS] as a
INNER JOIN [BOOKED SEATS] as b
ON a.train_no=b.train_no and a.class_id=b.class_id and a.quota_id=b.quota_id
INNER JOIN [WAITING SEATS] as c
ON b.train_no=c.train_no and b.class_id=c.class_id and b.quota_id=c.quota_id
WHERE a.train_no=22651 and a.date_time='2022-08-13 00:00:00'

-- To read the number of users with their country.

SELECT cn.country_name,count(u.user_id) as [number of users] FROM [USER] as u
RIGHT JOIN CITY as c
ON u.city_id=c.city_id
RIGHT JOIN STATE as s
ON c.state_id=s.state_id
RIGHT JOIN COUNTRY as cn
ON s.country_id=cn.country_id
GROUP BY cn.country_name

-- To read the list of passengers with their reservation of arrival station name by descending order of age.

SELECT p.name,p.age,s.station_name FROM PASSENGER as p
INNER JOIN RESERVATION as r
ON p.reservation_id=r.reservation_id
INNER JOIN STATION as s
ON r.arrival_station_id=s.station_id
ORDER BY p.age DESC

-- To read the passengers who have made health insurance.

SELECT p.name, insurance_name, insurance_amount FROM PASSENGER as p
INNER JOIN RESERVATION as r
ON p.reservation_id=r.reservation_id
INNER JOIN [TRAVEL INSURANCE] as i
ON r.insurance_id=i.insurance_id
WHERE i.insurance_name='Health'

-- To read the details of the reservation using PNR NO.

create procedure pnrno(@pnr bigint)
as
begin
select p.*,r.reservation_id,r.train_no,r.class_id,r.quota_id,r.arrival_station_id,r.arrival_date_time,r.departure_station_id,r.departure_date_time,ps.name,ps.age,ps.gender,ps.seat_no from PNR as p
inner join RESERVATION as r
ON p.PNR_no=r.PNR_no
inner join PASSENGER as ps
ON r.reservation_id=ps.reservation_id
where p.PNR_no=@pnr
end

exec pnrno @pnr=123456

--To make a cancellation, insert data to refund or wallet based on the cancellation type, update seats of that particular train on that reservation date and time.

create procedure cancel(@reservationid bigint, @type varchar(3),@tcid int)
as
begin
declare @userid int, @cancelid int, @walletid int, @e float, @seatcount int, @trainno int, @classid varchar(4), @quotaid varchar(6), @available int, @ondatetime smalldatetime

set @userid = (select [user_id] from RESERVATION where reservation_id=@reservationid)
set @walletid = (select [wallet_id] from [USER] where user_id=@userid)
set @e = (select [amount] from RESERVATION where reservation_id=@reservationid)
set @trainno = (select [train_no] from RESERVATION where reservation_id=@reservationid)
set @classid = (select [class_id] from RESERVATION where reservation_id=@reservationid)
set @quotaid = (select [quota_id] from RESERVATION where reservation_id=@reservationid)
set @ondatetime = (select [arrival_date_time] from RESERVATION where reservation_id=@reservationid)
set @available = (select [available_seats] from [AVAILABLE SEATS] where train_no=@trainno and class_id=@classid and quota_id=@quotaid and date_time=@ondatetime)

insert into CANCELLATION values(@userid,@reservationid,@type)

set @seatcount = (select count(passenger_id) from PASSENGER where reservation_id=@reservationid)

delete from PASSENGER where reservation_id=@reservationid

if @available!=0
    update [BOOKED SEATS] set booked_seats=booked_seats-@seatcount where train_no=@trainno and class_id=@classid and quota_id=@quotaid and date_time=@ondatetime
	update [AVAILABLE SEATS] set available_seats=available_seats+@seatcount where train_no=@trainno and class_id=@classid and quota_id=@quotaid and date_time=@ondatetime
if @available=0
    update [WAITING SEATS] set waiting_seats=waiting_seats-@seatcount where train_no=@trainno and class_id=@classid and quota_id=@quotaid and date_time=@ondatetime

set @cancelid = (select cancellation_id from CANCELLATION where reservation_id=@reservationid)

if @type='RF'
   insert into REFUND values(@cancelid,@tcid,GETDATE())
if @type='BK' 
   update WALLET set amount=amount+@e where wallet_id=@walletid

end

exec cancel @reservationid=101010,@type='BK',@tcid=1001

SELECT * FROM CANCELLATION
SELECT * FROM WALLET
SELECT * FROM REFUND
SELECT * FROM PASSENGER
SELECT a.train_no,a.class_id,a.quota_id,a.date_time,a.available_seats,b.booked_seats,c.waiting_seats FROM [AVAILABLE SEATS] as a
INNER JOIN [BOOKED SEATS] as b
ON a.train_no=b.train_no and a.class_id=b.class_id and a.quota_id=b.quota_id
INNER JOIN [WAITING SEATS] as c
ON b.train_no=c.train_no and b.class_id=c.class_id and b.quota_id=c.quota_id
WHERE a.train_no=22651 and a.date_time='2022-08-13 00:00:00'