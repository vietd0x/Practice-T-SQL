create database QLSV
go
use QLSV
go
create table Sinhvien(
	MaSV		int				identity primary key,
	TenSV		nvarchar(30)	not null,
	GT			nvarchar(5)		default N'Nam',
	Ngaysinh	date			check (Ngaysinh < getdate()),
	Que			nvarchar(50)	not null,
	Lop			nvarchar(10),
)

create table Monhoc(
	MaMH	int				identity primary key,
	TenMH	nvarchar(20)	unique,
	DVHT	int				check (DVHT between 2 and 9),
)

create table Ketqua(
	MaSV	int,
	MaMH	int,
	Diem	float	check (Diem between 0 and 10),
	constraint RB_khoa primary key (MaSV, MaMH),
)
-- add constraints
alter table ketqua
add constraint FK_MaSV foreign key (MaSV) references Sinhvien

alter table ketqua
add constraint FK_MaMH foreign key (MaMH) references Monhoc

--check
sp_help monhoc
select * from 

-- insert data
use QLSV
insert Sinhvien
values	(N'Trần Bảo Trọng', N'Nam', '1995-12-14', N'Hà Giang', N'L02'),
		(N'Lê Thùy Dương', N'Nữ', '1997-5-12', N'Hà Nội', N'L03'),
		(N'Trần Phương Thảo', N'Nam', '1996-3-30', N'Quảng Ninh', N'L01'),
		(N'Lê Tường An', N'Nam', '1995-11-20', N'Ninh Bình', N'L04'),
		(N'Phạm Thị Hương Giang', N'Nữ', '1999-2-21', N'Hòa Bình', N'L02'),
		(N'Trần Anh Bảo', N'Nam', '1995-12-24', N'Hà Giang', N'L02'),
		(N'Lê Thùy Dung', N'Nữ', '1997-5-12', N'Hà Nội', N'L03'),
		(N'Phạm Trung Tính', N'Nam', '1996-3-30', N'Quảng Ninh', N'L01'),
		(N'Lê An Hải', N'Nam', '1995-11-20', N'Ninh Bình', N'L04'),
		(N'Phạm Thị Giang Hương', N'Nữ', '1999-2-21', N'Hòa Bình', N'L02'),
		(N'Đoàn Duy Thức', N'Nam', '1994-4-12', N'Hà Nội', N'L01'),
		(N'Dương Tuấn Thông', N'Nam', '1991-4-12', N'Nam Định', N'L03'),
		(N'Lê Thành Đạt', N'Nam', '1993-4-15', N'Phú Thọ', N'L04'),
		(N'Nguyễn Hằng Nga', N'Nữ', '1993-5-25', N'Hà Nội', N'L01'),
		(N'Trần Thanh Nga', N'Nữ', '1994-6-12', N'Phú Thọ', N'L03'),
		(N'Trần Trọng Hoàng', N'Nam', '1995-12-14', N'Hà Giang', N'L02'),
		(N'Nguyễn Mai Hoa', N'Nữ', '1997-05-12', N'Hà Nội', N'L03'),
		(N'Lê Thúy An', N'Nam', '1998-3-23', N'Hà Nội', N'L01')
select * from Sinhvien

insert Monhoc
values	(N'Toán cao cấp', 3),
		(N'Mạng máy tính', 3),
		(N'Tin đại cương', 4)
		(N'Hệ Quản trị CSDL', 
select* from Monhoc

insert Ketqua
values	(1, 1, 8), (1, 2, 5), (1, 3, 7), (2, 1, 9), (2, 2, 5), (2, 3, 2), (3, 1, 4), (3, 2, 2), (4, 1, 1), (4, 2, 3), (5, 1, 4),
		(6, 1, 2), (6, 2, 7), (6, 3, 9), (7, 1, 4), (7, 2, 5), (7, 3, 8), (8, 1, 9), (8, 2, 8), (9, 1, 7), (9, 2, 7), (9, 3, 5),
		(10, 1, 3), (10, 3, 6), (11, 1, 6), (12, 1, 8), (12, 2, 7), (12, 3, 5), (13, 1, 6), (13, 2, 5), (13, 3, 5), (14, 1, 8),
		(14, 2, 9), (14, 3, 7), (15, 1, 3), (15, 2, 6), (15, 3, 4)
select* from Ketqua
---------------------------------------
--B1
create database Thu_vien
go

use Thu_vien
go
create table BANDOC(
	maBD		varchar(10)	 primary key not null,
	hotenBD		nvarchar(35) not null,
	ngaysinh	date		 check(ngaysinh < getdate()),
	lop			varchar(6)	 not null,
	quequan		nvarchar(50) not null,
	sdt			varchar(11)	 not null,
)

create table SACH(
	maS		varchar(10)		primary key,
	TenS	nvarchar(50)	not null,
	TheLoai	nvarchar(20)	not null,
	Tacgia	nvarchar(35)	not null,
	NamXB	int,
	NhaXB	nvarchar(30)	not null,
)

create table PHIEUMUON(
	MaBD		varchar(10)	not null,
	MaS			varchar(10)	not null,
	Ngaymuon	date,
	Ngayhentra	date,
	TraSach		bit			default 0,
	constraint CK_max5days check (datediff(day, ngaymuon, ngayhentra) <= 5),-- CAN USE DATEADD()
	constraint PK primary key (MaBD, MaS),
)
select * from BANDOC
select * from PHIEUMUON
select * from SACH
sp_help sach
--add constraints
alter table PHIEUMUON
add constraint FK_MaBD foreign key (MaBD) references BANDOC(MaBD)

alter table PHIEUMUON
add constraint FK_MaS foreign key (MaS) references SACH(MaS)

insert bandoc values
      ('BD001',N'Nguyễn Vũ Minh','2001-11-18',N'L01',N'Hưng Yên','0969447444'),
	  ('BD002',N'Nguyễn Tuấn Anh','2001-02-08',N'L04',N'Hà Nội','0343254355'),
	  ('BD003',N'Nguyễn Bảo Lâm','2000-10-30',N'L09',N'Thái Binh','0923885994'),
	  ('BD004',N'Đoàn Quỳnh Anh','2001-12-14',N'L01',N'Hưng Yên','0963774235'),
	  ('BD005',N'Trần Minh Lương','2003-06-24',N'L02',N'Quảng Ninh','0388219094'),
	  ('BD006',N'Dương Tử Thần','1999-05-11',N'L04',N'Hà Nội','0955091019'),
	  ('BD007',N'Đăng Nhật Long','2001-01-15',N'L05',N'Bắc Giang','0356900231'),
	  ('BD008',N'Nguyễn Cao Kỳ Lân','2001-03-31',N'L09',N'Nghệ An','0344456732'),
	  ('BD009',N'Lê Đức Hưng','2002-02-28',N'L03',N'Thanh Hoá','0987654321'),
	  ('BD010',N'Hoàng Ngọc Thượng','2001-07-28',N'L06',N'Hải Phòng','0922334455'),
	  ('BD011', N'Đỗ Xuân Việt', '2001-01-04', 'L07', N'Ba Vi', '0969447465')
insert sach values
      ('MS001',N'Vùng đất hứa',N'Tiểu thuyết',N'Cao Minh Tuấn','2016',N'NXB Thanh Niên'),
	  ('MS002',N'Doraemon truyện ngắn tập 1',N'Truyện tranh',N'Fujiko Fujio','2016',N'NXB Kim Đồng'),
	  ('MS003',N'Doraemon truyện ngắn tập 2',N'Truyện tranh',N'Fujiko Fujio','2016',N'NXB Kim Đồng'),
	  ('MS004',N'Doraemon truyện ngắn tập 3',N'Truyện tranh',N'Fujiko Fujio','2017',N'NXB Kim Đồng'),
	  ('MS005',N'Doraemon truyện ngắn tập 4',N'Truyện tranh',N'Fujiko Fujio','2017',N'NXB Kim Đồng'),
	  ('MS006',N'Trạng Quỳnh',N'Truyện ngắn',N'Lữ Huy Nguyên','2006',N'NXB Văn Học'),
	  ('MS007',N'Cửa Địa Ngục',N'Truyện Kinh Dị',N'Nam Thành','2008',N'NXB Thanh Hoá'),
	  ('MS008',N'Kiếp sau gặp lại',N'Ngôn Tình',N'Bùi Hồng Hạnh ','2010',N'NXB Thanh Niên'),
	  ('MS009',N'Tiếng gọi nơi hoang dã',N'Tiểu thuyết',N'Jack Lodon','2013',N'NXB Văn Hoá'),
	  ('MS010',N'Đại diệt nguyệt',N'Tiểu thuyết',N'Liu Xing Jan','2006',N'NXB Ánh Sao')
insert phieumuon values
	  ('BD009','MS007','2021-9-25','2021-9-30',0),
	  ('BD006','MS005','2021-9-24','2021-9-29',0),
	  ('BD004','MS009','2021-9-24','2021-9-29',0),
	  ('BD001','MS003','2021-9-23','2021-9-28',0),
	  ('BD002','MS005','2021-9-25','2021-9-30',0),
	  ('BD008','MS006','2021-9-26','2021-10-1',0),
	  ('BD003','MS007','2021-9-22','2021-9-27',0),
	  ('BD003','MS002','2021-9-22','2021-9-27',0),
	  ('BD004','MS004','2021-9-24','2021-9-29',1),
	  ('BD009','MS002','2021-9-22','2021-9-27',1),
	  ('BD011', 'MS001', '2021-05-04', '2021-05-09', 1),
	('BD011', 'MS009', '2021-05-09', '2021-05-14', 1),
	('BD011', 'MS010', '2021-05-20', '2021-05-25', 0)
insert PHIEUMUON values
	('BD011', 'MS002', '2021-06-4', '2021-06-9', 0)

drop table PHIEUMUON
select * from  bandoc
select * from  sach
select * from phieumuon
---------------------------------------
--B2
create database QLMB
go
select *from chungnhan
select *from chuyenbay
select *from maybay
select *from nhanvien

use QLMB
go
create table CHUYENBAY(
	MaCB	char(5)		primary key,
	GaDi	varchar(50),
	GaDen	varchar(50),
	DoDai	int,
	GioDi	time,
	GioDen	time,
	ChiPhi	int,
)

create table MAYBAY(
	MaMB	int primary key,
	Hieu	varchar(50),
	TamBay	int,
)

create table NHANVIEN(
	MaNV	char(9) primary key,
	Ten		varchar(50),
	Luong	int,
)

create table CHUNGNHAN(
	MaNV	char(9),
	MaMB	int,
)

-- add constraint

-- insert data
insert CHUYENBAY
values('VN431','SGN','CAH',3693,'05:55','06:55',236),
	  ('VN320','SGN','DAD',2798,'06:00','07:10',221),
	  ('VN464','SGN','DLI',2002,'07:20','08:05',225),
	  ('VN216','SGN','DIN',4170,'10:30','14:20',262),
	  ('VN280','SGN','HPH',11979,'06:00','08:00',1279),
	  ('VN254','SGN','HUI',8765,'18:40','20:00',781),
	  ('VN338','SGN','BMV',4081,'15:25','16:25',375),
	  ('VN440','SGN','BMV',4081,'18:30','19:30',426),
	  ('VN651','DAD','SGN',2798,'19:30','08:00',221),
	  ('VN276','DAD','CXR',1283,'09:00','12:00',203),
	  ('VN374','HAN','VII',510,'11:40','13:25',120),
	  ('VN375','VII','CXR',752,'14:15','16:00',181),
	  ('VN269','HAN','CXR',1262,'14:10','15:50',202),
	  ('VN315','HAN','DAD',134,'11:45','13:00',112),
	  ('VN317','HAN','UIH',827,'15:00','16:15',190),
	  ('VN741','HAN','PXU',395,'06:30','08:30',120),
	  ('VN474','PXU','PQC',1586,'08:40','11:20',102),
	  ('VN476','UIH','PQC',485,'09:15','11:50',117)
select * from CHUYENBAY

insert MAYBAY
values	(747, 'Boeing 747 - 400', 13488),
		(737, 'Boeing 737 - 800', 5413),
		(340, 'Airbus A340 - 300', 11392),
		(757, 'Boeing 757 - 300', 6416),
		(777, 'Boeing 777 - 300', 10306),
		(767, 'Boeing 767 - 400ER', 10360),
		(320, 'Airbus A320', 4168),
		(319, 'Airbus A319', 2888),
		(727, 'Boeing 727', 2406),
		(154, 'Tupolev 154', 6565)
select * from MAYBAY

insert NHANVIEN
values	('242518965', 'Tran Van Son', 120433),
		('141582651', 'Doan Thi Mai', 178345),
		('011564812', 'Ton Van Quy', 153972),
		('567354612', 'Quan Cam Ly', 256481),
		('552455318', 'La Que', 101745),
		('550156548', 'Nguyen Thi Cam', 205187),
		('390487451', 'Le Van Luat', 212156),
		('274878974', 'Mai Quoc Minh', 99890),
		('254099823', 'Nguyen Thi Quynh', 24450),
		('356187925', 'Nguyen Vinh Bao', 44740),
		('355548984', 'Tran Thi Hoai An', 212156),
		('310454876', 'Ta Van Do', 212156),
		('489456522', 'Nguyen Thi Quy Linh', 127984),
		('489221823', 'Bui Quoc Chinh', 23980),
		('548977562', 'Le Van Quy', 84476),
		('310454877', 'Tran Van Hao', 33546),
		('142519864', 'Nguyen Thi Xuan Dao', 227489),
		('269734834', 'Truong Tuan Anh', 289950),
		('287321212', 'Duong Van Minh', 48090),
		('552455348', 'Bui Thi Dung', 92013),
		('248965255', 'Tran Thi Ba', 43723),
		('159542516', 'Le Van Ky', 48250),
		('348121549', 'Nguyen Van Thanh', 32899),
		('574489457', 'Bui Van Lap', 20)
select * from NHANVIEN

insert CHUNGNHAN values
       ('567354612',747),
	   ('567354612',737),
	   ('567354612',757),
	   ('567354612',777),
	   ('567354612',767),
	   ('567354612',727),
	   ('567354612',340),
	   ('552455318',737),
	   ('552455318',319),
	   ('552455318',747),
	   ('552455318',767),
	   ('390487451',340),
	   ('390487451',320),
	   ('390487451',319),
	   ('274878974',757),
	   ('274878974',767),
	   ('355548984',154),
	   ('310454876',154),
	   ('142519864',747),
	   ('142519864',757),
	   ('142519864',777),
	   ('142519864',767),
	   ('142519864',737),
	   ('142519864',340),
	   ('142519864',320),
	   ('269734834',747),
	   ('269734834',737),
	   ('269734834',340),
	   ('269734834',757),
	   ('269734834',777),
	   ('269734834',767),
	   ('269734834',320),
	   ('269734834',319),
	   ('269734834',727),
	   ('269734834',154),
	   ('242518965',737),
	   ('242518965',757),
	   ('141582651',737),
	   ('141582651',757),
	   ('141582651',767),
	   ('011564812',737),
	   ('011564812',757),
	   ('574489457',154)
select * from CHUNGNHAN
