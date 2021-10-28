use Thu_vien
go
select * from SACH
select * from PHIEUMUON
select * from BANDOC
-----------------------------------------------------------------------------------------
/*1. Xem bạn có mã bạn đọc là BD009 đã mượn những quyển sách nào ( in mã sách và tên 
sách)*/
select b.maS, TenS
from SACH as b join PHIEUMUON as c on b.maS = c.MaS
where MaBD = 'BD009'

--2. Có bao nhiêu cuốn thiểu thuyết đã được mượn vào tháng 9/2021
select COUNT(b.MaS)
from SACH as b join PHIEUMUON as c on b.maS = c.MaS
where TheLoai = N'Tiểu thuyết' and Ngaymuon like '2021-09-%'

--3. Hiện thị về việc mượn sách của những độc giả quê ở Hà nội
select * from BANDOC bd join PHIEUMUON pm on bd.maBD = pm.MaBD
where quequan = N'Hà Nội'

--4. Hiển thị mã bạn đọc và tên của các bạn cùng mượn sách có mã là MS005
select bd.maBD, hotenBD
from BANDOC bd join PHIEUMUON pm on bd.maBD = pm.MaBD
where MaS = 'MS005'

--5. Hiển thị danh sách bạn đọc quê ở Nghệ An và chưa trả sách 
select bd.maBD, hotenBD
from BANDOC bd join PHIEUMUON pm on bd.maBD = pm.MaBD
where quequan = N'Nghệ An' and pm.TraSach = 0

--6.WRONG Hiển thị bạn đọc quê ở Hưng Yên mượn nhiều sách nhất
select top 1 pm.MaBD, hotenBD, lop, count(MaS) as SoLuong
from BANDOC as bd join PHIEUMUON as pm on bd.maBD = pm.MaBD
where quequan = N'Hưng Yên'
group by pm.MaBD, hotenBD, lop
order by SoLuong desc

--7. Tính số lượng sách của mỗi thể loại có trong thư viện
select TheLoai, count(maS) as SoLuong
from SACH as s
group by TheLoai

--8. Hiển thị các cuốn sách được in ở nhà xuất bản Kim Dong trước năm 2017
select TenS
from SACH as s
where NhaXB = N'NXB Kim Đồng' and NamXB < 2017

--9. Hiển thị các bạn có mã bạn đọc nhưng chưa mượn sách bao giờ
select bd.maBD, hotenBD, ngaysinh, lop
from BANDOC as bd left join PHIEUMUON as pm on bd.maBD = pm.MaBD
where MaS is NULL

--10.Hiển thị các bạn mượn nhiều hơn hoặc bằng 2 quyển sách
select bd.maBD, hotenBD, count(maS) as SoLuong
from BANDOC as bd join PHIEUMUON as pm on bd.maBD = pm.MaBD
group by bd.maBD, hotenBD
having count(maS) >= 2


/*11. Hiển thị các bạn mượn nhiều hơn hoặc bằng 3 quyển sách thuộc thể loại Tiểu thuyết vào tháng 05/2021*/
select * from
(select hotenBD, count(Theloai) as Soluong
from (BANDOC bd join PHIEUMUON pm on bd.maBD = pm.MaBD) join SACH s on s.maS = pm.MaS
where TheLoai = N'Tiểu thuyết' and Ngaymuon like '2021-05-%'
group by hotenBD) as A
where Soluong >= 3

--12. Hiển thị tổng số sách đã được mượn ở Thư viện
select count(distinct MaS) as SoSachDaBiMuon
from PHIEUMUON
where TraSach = 0

--13. Hiện thị mã và tên bạn đọc mượn sách nhiều hơn bạn có mã số là BD009
	-- lay ra so luong sach muon cua 'BD009'
	select count(maS) as SoLuong_bd009
	from PHIEUMUON
	where MaBD = 'BD009'
	group by MaBD

select * from
	(select bd.maBD, hotenBD, count(maS) as SoLuong
	from BANDOC as bd join PHIEUMUON as pm on bd.maBD = pm.MaBD
	group by bd.maBD, hotenBD) as A
where SoLuong >		(select count(maS) as SoLuong_bd009
					from PHIEUMUON
					where MaBD = 'BD009'
					group by MaBD)

--14. Hiển thị mã và tên cuốn sách được mượn nhiều nhất,ít nhất ở Thư viện năm 2021
	--
	select MaS, count(MaBD) as SoLuot
	from PHIEUMUON
	where Ngaymuon like '2021-%'
	group by MaS
	order by SoLuot asc

select distinct pm.MaS, tenS
from Sach as s join Phieumuon as pm on s.maS = pm.MaS
where s.MaS = (select MaS from (select MaS, count(MaBD) as SoLuot
								from PHIEUMUON
								where Ngaymuon like '2021-%'
								group by MaS
								order by SoLuot desc) as A
				where SoLuot >= all(SoLuot)
UNION
select pm.MaS, tenS
from Sach as s join Phieumuon as pm on s.maS = pm.MaS
where s.MaS = (select MaS from (select top 1 MaS, count(MaBD) as SoLuot
								from PHIEUMUON
								where Ngaymuon like '2021-%'
								group by MaS
								order by SoLuot asc) as A)

--15.Cho danh sách các bạn đọc mượn sách quá hạn tính đến ngày hiện tại
select hotenBD, bd.maBD
from BANDOC as bd join PHIEUMUON as pm on bd.maBD = pm.MaBD
where TraSach = 0 and datediff(day, Ngaymuon, getdate()) > 5
-----------------------------------------------------------------------------------------
use QLMB
--1 Cho biết thông tin về các nhân viên có lương nhỏ hơn 10000
select * from NHANVIEN where Luong < 10000

--2 Cho biết thông tin về các chuyến bay có độ dài đường bay nhỏ hơn 10000km và lớn hơn 8000km
select * from CHUYENBAY where DoDai < 10000 and DoDai > 8000

--3 Cho biết thông tin về các chuyến bay xuất phát từ Sài Gòn (SGN) đi Ban Mê Thuột (BMV)
select * from CHUYENBAY where GaDi = 'SGN' and GaDen = 'BMV'

--4 Có bao nhiêu chuyến bay xuất phát từ Sài Gòn (SGN)
select count(MaCB) from CHUYENBAY where GaDi = 'SGN'

--5 Có bao nhiêu loại máy bay Boeing
select count(MaMB) from MAYBAY where Hieu like 'Boeing %'

--6 Cho biết tổng số lương phải trả cho các nhân viên
select sum(Luong) from NHANVIEN

--7 Cho biết mã số và tên của các phi công lái máy bay Boeing
select distinct nv.MaNV, Ten
from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where MaMB in (select MaMB from MAYBAY where Hieu like 'Boeing %')

--8 Cho biết mã số và tên của các phi công có thể lái được máy bay có mã số là 747
select nv.MaNV, Ten
from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where MaMB = '747'

--9 Cho biết mã số của các loại máy bay mà nhân viên có họ Nguyễn có thể lái
select MaMB from CHUNGNHAN where MaNV in (select MaNV from NHANVIEN where ten like 'Nguyen %')

--10 Cho biết mã số của các phi công vừa lái được Boeing vừa lại được Airbus A320
select distinct nv.MaNV, Ten
from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where MaMB in (select MaMB from MAYBAY where Hieu like 'Airbus A320')
INTERSECT
select distinct nv.MaNV, Ten
from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where MaMB in (select MaMB from MAYBAY where Hieu like 'Boeing %')
--10.1
select distinct a.manv
from (NHANVIEN a join CHUNGNHAN b on a.MaNV=b.MaNV) join MAYBAY c on c.MaMB=b.MaMB
where Hieu like 'Boeing %' and a.MaNV in (select a.manv
from (NHANVIEN a join CHUNGNHAN b on a.MaNV=b.MaNV) join MAYBAY c on c.MaMB=b.MaMB
where Hieu='Airbus A320')

--11 Cho biết các loại máy bay có thể thực hiện được chuyến bat VN280
select * from MAYBAY where TamBay >= (select Dodai from CHUYENBAY where MaCB = 'VN280')
--11.1
select MaMB, Hieu
from CHUYENBAY cb, MAYBAY mb
where mb.TamBay >= cb.DoDai and cb.MaCB = 'VN280'

--12 Cho biết các chuyến bay có thể thực hiện bởi máy bay Airbus A320
select MaCB from CHUYENBAY where DoDai <= (select TamBay from MAYBAY where Hieu = 'Airbus A320')

--13 Với mỗi loại máy bay có phi công lái, cho biết mã số, loại máy bay và tổng số phi công có thể lái loại máy bay đó
select mb.MaMB, Hieu, count(MaNV) as SoPhiCong
from MAYBAY as mb join CHUNGNHAN as cn on mb.MaMB = cn.MaMB
group by mb.MaMB, Hieu

--14 Giả sử một hành khách muốn đi thẳng từ ga A đến ga B rồi quay trở về ga A. Cho biết các đường bay nào có thể đáp ứng yêu cầu này.
select cb1.MaCB, cb1.Gadi, cb1.GaDen 
from CHUYENBAY as cb1, CHUYENBAY as cb2
where cb1.GaDen = cb2.GaDi and cb1.GaDi = cb2.GaDen and cb1.GioDen < cb2.GioDi

/*15 Với mỗi ga có chuyến bay xuất phát từ đó, cho biết có bao nhiêu chuyến bay khởi 
hành từ ga đó và cho biết tổng chi phí phải trả chi phi công lái các chuyến bay khởi 
hành từ ga đó*/
select gadi, sum(chiphi) as chiphi, count(macb) 'ma chuyen bay'
from CHUYENBAY
group by GaDi
--16 Với mỗi ga xuất phát, cho biết có bao nhiêu chuyến bay có thể khởi hành trước 12:00
select count(MaCB) from CHUYENBAY where GioDi < '12:0'

--17 Với mỗi phi công có thể lái nhiều hơn 3 loại máy bay, cho biết mã số phi công và tầm bay lớn nhất của các loại máy bay mà phi công đó có thể lái
select A.MaNV, max(TamBay) as TamBayMAX 
from	((select MaNV, count(MaMB) as SoMB
		from CHUNGNHAN
		group by MaNV) as A join CHUNGNHAN as cn on A.MaNV = cn.MaNV) join MAYBAY as mb on mb.MaMB = cn.MaMB
where SoMB > 3
group by A.MaNV

--18 Cho biết mã số của các phi công có thể lái được nhiều loại máy bay nhất
select *
from (select MaNV, count(MaMB) as SoMB from CHUNGNHAN group by MaNV) as A
where SoMB >= all(select count(MaMB) as SoMB from CHUNGNHAN group by MaNV)

--19 Cho biết mã số của các phi công có thể lái được ít loại máy bay nhất.
select *
from (select MaNV, count(MaMB) as SoMB from CHUNGNHAN group by MaNV) as A
where SoMB <= all(select count(MaMB) as SoMB from CHUNGNHAN group by MaNV)

--20 Tìm các chuyến bay có thể được thực hiện bởi tất cả các loại máy bay Boeing
select MaCB from CHUYENBAY
where Dodai <= (select min(TamBay) from MAYBAY where Hieu like 'Boeing %')

--21 Tìm các chuyến bay có thể được lái bởi các phi công có lương lớn hơn 100.000
-- tim min TamBay cua cac phi cong 
select MaCB from CHUYENBAY
where Dodai <=	(select min(Tambay)
				from (NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV) join MAYBAY as mb on mb.MaMB = cn.MaMB
				where Luong > 100000)

/*22 Cho biết tên các phi công có lương nhỏ hơn chi phí thấp nhất của đường bay từ Sài 
Gòn (SGN) đến Buôn mê Thuột (BMV)*/
select Ten
from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where Luong < (select min(ChiPhi) from CHUYENBAY where GaDi = 'SGN' and GaDen = 'BMV')

--23 Cho biết mã số của các phi công có lương cao nhất
select distinct nv.MaNV
from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where Luong >= all(select max(Luong) from NHANVIEN, CHUNGNHAN where NHANVIEN.MaNV = CHUNGNHAN.MaNV)

--24 Cho biết mã số của các nhân viên có lương cao thứ nhì
select MaNV from NHANVIEN
where Luong = (select min(Luong) from	(select distinct top 2  Luong
										from NHANVIEN
										order by Luong desc) as A)
--25 Cho biết tên và lương của các nhân viên không phải là phi công và có lương lớn hơn lương trung bình của tất cả các phi công.
select ten, MaNV, Luong from NHANVIEN 
where MaNV not in (select distinct MaNV from CHUNGNHAN)
and Luong > (select sum(Luong)/count(MaNV) from NHANVIEN where MaNV in (select distinct MaNV from CHUNGNHAN))

/*26 .Cho biết tên các phi công có thể lái các máy bay có tầm bay lớn hơn 4.800km nhưng 
không có chứng nhận lái máy bay Boeing*/
select distinct ten from NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV
where cn.MaMB in (select MaMB from MAYBAY where TamBay > 4800 and Hieu not like 'Boeing %')

--27 Cho biết tên các phi công lái ít nhất 3 loại máy bay có tầm xa hơn 3200km
select ten from (select MaNV, count(mb.MaMB) as SoLuong, min(TamBay) as TamBayMin
				from MAYBAY as mb join CHUNGNHAN as cn on mb.MaMB = cn.MaMB
				group by MaNV) as A join NHANVIEN as nv on A.MaNV = nv.MaNV
where SoLuong > 3 and TamBayMin > 3200

/*28 Với mỗi nhân viên, cho biết mã số, tên nhân viên và tổng số loại máy bay Boeing mà 
nhân viên đó có thể lái*/
select nv.MaNV, ten, count(cn.MaMB) as SoLoaiBoeing
from (NHANVIEN as nv join CHUNGNHAN as cn on nv.MaNV = cn.MaNV) join MAYBAY as mb on mb.MaMB = cn.MaMB
where Hieu like 'Boeing %'
group by nv.MaNV, ten

/*29 Với mỗi loại máy bay, cho biết loại máy bay và tổng số phi công có thể lái loại máy 
bay đó.*/
select Hieu, count(MaNV)
from MAYBAY as mb join CHUNGNHAN as cn on mb.MaMB = cn.MaMB
group by Hieu

/*30 Với mỗi chuyến bay, cho biết mã số chuyến bay và tổng số phi công không thể lái 
chuyến đó.*/
select MaCB, count(MaNV)
from	(select MaNV, min(TamBay) as TamBayMin
		from MAYBAY as mb join CHUNGNHAN as cn on mb.MaMB = cn.MaMB
		group by MaNV) as A, CHUYENBAY as cb
where cb.DoDai > TamBayMin
group by MaCB

/*31 Với mỗi loại máy bay, cho biết loại máy bay và tổng số chuyến bay không thể thực 
hiện bởi loại máy bay đó*/
select Hieu, count(MaCB) as SoChuyenBay
from MAYBAY as mb,CHUYENBAY as cb
where mb.TamBay < cb.DoDai
group by Hieu

/*32 Với mỗi chuyến bay, hãy cho biết mã số chuyến bay và tổng số loại máy bay có thể 
thực hiện chuyến bay đó*/
select MaCB, count(MaMB) as SoLoaiMB
from CHUYENBAY as cb, MAYBAY as mb
where cb.DoDai < mb.TamBay
group by MaCB

/*33 Với mỗi loại máy bay, hãy cho biết loại máy bay và tổng số phi công có lương lớn hơn 
100.000 có thể lái loại máy bay đó.*/
select Hieu, count(cn.MaNV)
from (MAYBAY as mb join CHUNGNHAN as cn on mb.MaMB = cn.MaMB) join NHANVIEN as nv on nv.MaNV = cn.MaNV
where Luong > 100000
group by Hieu

/*34 Với mỗi loại máy bay có tầm bay trên 3200km, cho biết tên của loại máy bay và lương 
trung bình của các phi công có thể lái loại máy bay đó.*/
select Hieu, sum(Luong)/ count(nv.MaNV)
from (MAYBAY as mb join CHUNGNHAN as cn on mb.MaMB = cn.MaMB) join NHANVIEN as nv on nv.MaNV = cn.MaNV
where TamBay > 3200
group by Hieu

/*35 Với mỗi phi công, cho biết mã số, tên phi công và tổng số chuyến bay xuất phát từ Sài 
Gòn mà phi công đó có thể lái*/

select MaNV, ten, count(MaCB)
from CHUYENBAY as cb

/*36 Một hành khách muốn đi từ Hà Nội (HAN) đến nha trang (CXR) mà không phải đổi 
chuyến bay quá một lần. Cho biết mã chuyếnbay, thời gian khời hành từ Hà nội nếu 
hành khách muốn đến Nha Trang trước 16:00*/

/*37 Cho biết thông tin của các đường bay mà tất cả các phi công có thể bay trên đường 
bay đó đều có lương lớn hơn 100000*/

/*38 Cho biết tên các phi công chỉ lái các loại máy bay có tầm xa hơn 3200km và một trong 
số đó là Boeing*/

--39 Tìm các phi công có thể lái tất cả các loại máy bay Boeing
select * from NHANVIEN
where MaNV in
(SELECT DISTINCT MaNV FROM CHUNGNHAN cn
WHERE NOT EXISTS	(select MaMB from MAYBAY where Hieu like 'Boeing %'
					EXCEPT
					SELECT MaMB FROM CHUNGNHAN cn1
					WHERE cn.MaNV = cn1.MaNV))