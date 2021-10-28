use QLSV
select * from Sinhvien
sp_help Sinhvien
--Function
create function Thu(@ngay Datetime)
returns nvarchar(10)
as
	begin
		declare @st nvarchar(10)
		select @st=case Datepart(dw, @ngay)
			when 1 then N'Chu Nhat'
			when 2 then N'Thu Hai'
			when 3 then N'Thu Ba'
			when 4 then N'Thu Tu'
			when 5 then N'Thu Nam'
			when 6 then N'Thu Sau'
			when 7 then N'Thu Bay'
		end
		return(@st)
	end
select MaSV, tenSV, GT, dbo.thu(ngaysinh) as 'Ngay trong tuan', Lop from Sinhvien
--b1
/*1 Viết một thủ tục đưa ra các sinh viên có năm sinh bằng với năm sinh được nhập vào (lấy 
năm sinh bằng hàm datepart(yyyy,ngaysinh))*/
create procedure birth_year(@year int) as
select * from Sinhvien where @year = DATEPART(yyyy, Ngaysinh)

birth_year 1996
-- thu tuc xoa du lieu sinh vien theo maSV
create procedure delRow(@msv int) as
delete from Ketqua where MaSV = @msv
delete from Sinhvien where MaSV = @msv

-- thu tuc sua ten lop cua sinh vien theo masv
create procedure ModifyClass(@msv int, @newClass nvarchar(10)) as
update Sinhvien set Lop = @newClass where MaSV = @msv

-- thu tuc ktra xem 2 sv co cung nam sinh hay ko?
create procedure ageComparison(@msv1 int, @msv2 int) as
declare @namsinh1 int, @namsinh2 int
select @namsinh1 = datediff(yy, ngaysinh) from Sinhvien where MaSV = @msv1
select @namsinh2 = datediff(yy, ngaysinh) from Sinhvien where MaSV = @msv2
if(@namsinh1 = @namsinh2)
	print N'cung nam sinh'
else
	print N'khac nam sinh'


/*. So sánh 2 sinh viên có mã được nhập vào xem sinh viên nào được sinh trước.*/
create procedure birthDayCompare(@msv1 int, @msv2 int) as
declare @ngaysinh1 int, @ngaysinh2 int
select @ngaysinh1 = datepart(dd, ngaysinh) from Sinhvien where MaSV = @msv1
select @ngaysinh2 = datepart(dd, ngaysinh) from Sinhvien where MaSV = @msv2
if(@ngaysinh1 = @ngaysinh2)
	print N'2 ban co cung ngay sinh'
if(@ngaysinh1 < @ngaysinh2)
	print N'Ban co msv la ' + str(@msv2) + ' sinh truoc ban co msv la '+ str(@msv1)
else
	print N'Ban co msv la ' + str(@msv1) + ' sinh truoc ban co msv la '+ str(@msv2)

birthDayCompare 1, 3
-- 18 Doi vs moi lop, lap bang diem gom msv, tensv va diem tb chung hoc tap
select* from Ketqua

create procedure BangDiem(@Lop nvarchar(10)) as
select sv.MaSV, tenSV, round(SUM(Diem * DVHT)/SUM(cast(DVHT as float)), 1) as 'DTB'
from (Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV) join Monhoc as mh on mh.MaMH = kq.MaMH
where Lop = @Lop
group by sv.MaSV, TenSV

drop proc BangDiem 
BangDiem 'L03'

--19 Doi vs moi lop, cho biet msv va tensv phai thi lai tu 2 mon tro len
create procedure ThiLai(@Lop nvarchar(10)) as
select A.MaSV, tenSV
from (select sv.MaSV, tenSV, count(MaMH) as 'SoMon'
	from Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV
	where Diem < 4
	group by sv.MaSV, tenSV) as A
where SoMon >= 2

/*3. Viết một hàm đưa ra tháng sinh. Áp dụng để đưa ra tháng sinh các bạn sinh viên đã thi 
môn có mã là 1.*/
create function getMonth()
returns Table as
return (select distinct month(ngaysinh) as month
		from Sinhvien as sv join Ketqua as kq on kq.MaSV = sv.MaSV
		where MaMH = 1)

select * from getMonth()

-- b2
use qlnv
select * from nhanvien
select * from hang
select * from khachhang
select * from hoadonxuat
select * from cthoadon
sp_help cthoadon

--1 Tính tổng tiền đã mua hàng của một khách hàng nào đó theo mã KH
create function totalCostKH(@mkh varchar(5))
returns money as
begin
	declare @cost money
	set @cost = (select sum(sl*dongia)
	from cthoadon as cthd join hoadonxuat as hdx on cthd.mahd = hdx.mahd
	group by makh
	having makh = @mkh)
	return(@cost)
end

select dbo.totalCostKH('KH005')

--2 Cho biết tổng số tiền hàng đã mua của một hóa đơn nào đó
create function totalCostHD(@mhd varchar(6))
returns money as
begin
	declare @cost money
	set @cost = (select sl*dongia from cthoadon where mahd = @mhd)
	return(@cost)
end

select dbo.totalCostHD('HD005')

--3 Cho biết tổng số tiền hàng đã bán của một tháng nào đó.
create function totalCostMonth(@month int)
returns money as
begin
	declare @cost money
	set @cost = (select sum(sl*dongia)
				from cthoadon as cthd join hoadonxuat as hdx on cthd.mahd = hdx.mahd
				group by month(ngaylaphoadon)
				having MONTH(ngaylaphoadon) = @month)
	return(@cost)
end
print dbo.totalCostMonth(10)

--4 Cho biết họ tên của nhân viên có tuổi cao nhất
create function getHighestAge()
returns int as
begin
	declare @age int
	set @age = (select max(datediff(year, ngaysinh, getdate())) from nhanvien)
	return(@age)
end

select hoten from nhanvien where dbo.getHighestAge() = datediff(year, ngaysinh, getdate())
--cau1 viet ham dua ra ngay hien tai
create function currentDate()
returns date as
begin
	declare @date date
	set @date = getdate()
return(@date)
end

select dbo.currentDate()
--cau2 viet ham dua ra quy sinh, ap dung dua ra ds cac ban sv sinh quy 2
select * from Sinhvien

create function getQuaterBirthDay(@msv int)
returns int as
begin
	declare @date date
	set @date = (select ngaysinh from Sinhvien where @msv = MaSV)
	return datepart(q, @date)
end

select * from Sinhvien where dbo.getQuaterBirthDay(MaSV) = 2
select dbo.getQuaterBirthDay(20)
--cau3 Viet ham chi ra nam nhuan hay ko cua 1 nam nhap vao
create function isNamNhuan(@year int)
returns nvarchar(20) as
begin
	declare @result nvarchar(20)
	if((@year % 4 = 0 AND @year % 100 <> 0) OR (@year % 400 = 0))
		set @result = N'la nam nhuan'
	else
		set @result = N'ko la nam nhuan'
	return(@result)
end

select count(Masv) from Sinhvien where dbo.isNamNhuan(YEAR(ngaysinh)) = N'la nam nhuan' 

--cau4 Viet ham dua ra cac sv co nam sinh = nam sinh nhap vaoV
create function SvCoNamSinh(@year int)
returns table as
return select * from Sinhvien where YEAR(ngaysinh) = @year

select * from dbo.SvCoNamSinh(1997)

--cau5 Viet ham ktra xem 2 sv co cung nam sinh hay ko
create function birthYearCmp(@msv1 int, @msv2 int)
returns nvarchar(20) as
begin
	declare @namsinh1 int, @namsinh2 int, @result nvarchar(20)
	select @namsinh1 = datepart(yy, ngaysinh) from Sinhvien where MaSV = @msv1
	select @namsinh2 = datepart(yy, ngaysinh) from Sinhvien where MaSV = @msv2
	if(@namsinh1 = @namsinh2)
		set @result	= N'cung nam sinh'
	else
		set @result = N'khac nam sinh'
	return(@result)
end

--cau6 Viet ham so sanh 2 sv co ma dc nhap vao xem sv nao sinh ra trc
create function birthDayCmp(@msv1 int, @msv2 int)
returns nvarchar(20) as
begin
	declare @ngaysinh1 int, @ngaysinh2 int, @result nvarchar(20)
	select @ngaysinh1 = datediff(day, ngaysinh, getdate()) from Sinhvien where MaSV = @msv1
	select @ngaysinh2 = datediff(day, ngaysinh, getdate()) from Sinhvien where MaSV = @msv2
	if(@ngaysinh1 = @ngaysinh2)
		set @result = N'cung ngay sinh'
	if(@ngaysinh1 < @ngaysinh2)
		set @result = N'sinh vien 2 sinh trc'
	else
		set @result = N'sinh vien 1 sinh trc'
	return(@result)
end
