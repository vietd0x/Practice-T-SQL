--b1
use QLSV
--4 Cho biết số sinh viên thi lại của từng môn
create view T1_4
as
select TenMH, count(MaSV) as SoLuong
from Ketqua a, Monhoc b
where a.MaMH = b.MaMH and Diem < 4
group by TenMH

--5 Cho biết mã số và tên môn của những môn học mà tất cả các sinh viên đều đạt điểm >=5
create view TongSV
as
select count(MaSV) from Sinhvien

create view TongSvDiemHon5
as
select count(MaSV) as Soluong from Ketqua where Diem >= 5 group by MaMH

--6  Cho biết mã số và tên những sinh viên có điểm trung bình chung học tập cao hơn điểm trung bình chung của mỗi lớp.


--7 Cho mã sinh viên và tên của những sinh viên có hơn nửa số điểm >=5.
create view nuaSoDiem
as
select count(distinct MaMH)/2 from Ketqua

select distinct sv.MaSV, tenSV, count(maMH) as N'so luong diem >= 5'
from Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV
where diem >= 5
group by sv.MaSV, TenSV
having count(MaMH) >= nua

--b2
create database qlnv
use qlnv
go
create table nhanvien(
  manv varchar(5) primary key,
  hoten nvarchar(30) not null,
  diachi nvarchar(50) not null,
  sdt char(11) unique,
  ngaysinh date check (ngaysinh<getdate()),
  gt varchar(5) default 'nam',
  hsl int
)

create table hang(
 mahang varchar(10) primary key,
 tenhang varchar(20),
 nhasx varchar(50),
 timebaohanh varchar(10)
)

 create table khachhang(
 makh varchar(5) primary key,
 tenkh nvarchar(25) not null,
 cmt char(12) not null,
 diachi nvarchar(50) not null,
 sdt char(11) unique,
 email varchar(50)
 )

create table hoadonxuat(
	mahd varchar(6) primary key,
	makh varchar(5),
	manv varchar(5),
	ngaylaphoadon date,
	pttt varchar(10) check (pttt = 'the' or pttt='tien mat' )
)

create table cthoadon(
	mahd varchar(6),
	mahang varchar(10),
	sl int,
	dongia money
)
drop table cthoadon
alter table hoadonxuat add constraint r_qlnv_1 foreign key (makh) references khachhang(makh)
alter table hoadonxuat add constraint r_qlnv_2 foreign key (manv) references nhanvien(manv)
alter table cthoadon add constraint r_qlnv_3 foreign key (mahd) references hoadonxuat(mahd)
alter table cthoadon add constraint r_qlnv_4 foreign key (mahang) references hang(mahang)

insert nhanvien values
   ('NV001',N'Lê Trung Văn',N'Hà Nội','02445737468','1994-3-21','nam',148000),
   ('NV002',N'Trần Văn Lâm',N'Hưng Yên','09274856241','1993-2-20','nam',152000),
   ('NV003',N'Nguyễn Thị Thuỳ Dung',N'Hà Nam','03728293427','1996-12-25','nu',260000),
   ('NV004',N'Hoàng Anh Tú',N'Hải Phòng','04829471536','1999-5-31','nam',180000),
   ('NV005',N'Phan Bảo Ngọc',N'Quảng Ninh','08211704627','2001-4-21','nu',246000)
insert hang values
   ('MH001','MacBook Pro','APPLE','1 year'),
   ('MH002','FigureRimuru','BANDAI NAMCO','2 year'),
   ('MH003','Iphone 19 plus','APPLE','1,5 year'),
   ('MH004','Yugi-OhCardbox','KONAMI','10 month'),
   ('MH005','Maid cosplay suit','YURU C.P.N','1 year')
insert khachhang values
   ('KH001',N'Nguyễn Thanh Tùng','023617361872','Hưng Yên','01931827361','ntt@gmail.com'),
   ('KH002',N'Trần Văn Trung','071265635181','Hà Nội','09171625342','tvt@gmail.com'),
   ('KH003',N'Nguyễn Vĩnh Toàn','071625381943','Hải Phòng','07182736451','nvt@gmail.com'),
   ('KH004',N'Lê Song Hải','019273617261','Hải Dương','09162736481','lsh@gmail.com'),
   ('KH005',N'Cao Đức Hưng','021818723272','Bắc Ninh','03546728902','cdh@gmail.com')
insert hoadonxuat values
   ('HD001','KH003','NV005','2021-10-2','the'),
   ('HD003','KH004','NV004','2021-10-3','tien mat'),
   ('HD005','KH005','NV003','2021-10-4','tien mat'),
   ('HD002','KH001','NV002','2021-10-1','the'),
   ('HD004','KH002','NV001','2021-10-2','the')
insert cthoadon values
   ('HD001','MH001','50','200000000'),
   ('HD002','MH004','15','1200000'),
   ('HD003','MH005','2','4800000'),
   ('HD004','MH003','4','140000000'),
   ('HD005','MH002','1','65000000')
--Tạo View chứa danh sách nhân viên nữ
create view dsachNvienNu
as
select * from nhanvien where gt = 'nu'

select * from dsachNvienNu
--Tạo View chứa danh sách nhân viên với các thông tin: mã nhân viên, họ tên, giới tính và tuổi
create view staffInfo
as
select manv, hoten, gt, datediff(year, ngaysinh, getdate()) as tuoi
				-- can use: year(getdate()) - year(ngaysinh) as tuoi
from nhanvien

select * from staffInfo

--Tạo View cho biết họ tên của khách hàng đã mua tổng số tiền hàng > 10 triệu
create view tenKHmuaHon10tr
as
select hoten
from 