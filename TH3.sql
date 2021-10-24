use QLSV
go
----------------------------
--join - inner joint
select sv.MaSV, TenSV, TenMH, Diem
from ((Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV) join Monhoc as mh on kq.MaMH = mh.MaMH)
--left join
select sv.MaSV, TenSV, TenMH, Diem
from ((Sinhvien as sv left join Ketqua as kq on sv.MaSV = kq.MaSV) left join Monhoc as mh on kq.MaMH = mh.MaMH)
--right join
select sv.MaSV, TenSV, TenMH, Diem
from ((Sinhvien as sv right join Ketqua as kq on sv.MaSV = kq.MaSV) right join Monhoc as mh on kq.MaMH = mh.MaMH)
--full join
select sv.MaSV, TenSV, TenMH, Diem
from ((Sinhvien as sv full join Ketqua as kq on sv.MaSV = kq.MaSV) full join Monhoc as mh on kq.MaMH = mh.MaMH)
----------------------------
select * from Sinhvien
select * from Monhoc
select * from Ketqua

--B1
--1
select b.MaMH, tenMH, Diem
from Sinhvien a, Monhoc b, Ketqua c
where c.MaSV = a.MaSV and b.MaMH = c.MaMH and tenSV like N'% Thức'

--2
select b.MaMH, tenMH, Diem
from Sinhvien a, Monhoc b, Ketqua c
where c.MaSV = a.MaSV and b.MaMH = c.MaMH and Diem < 5 and tenSV like N'% Dung'

--3 Cho biết mã sinh viên, tên những sinh viên đã thi ít nhất là 1 trong 3 môn Lý thuyết Cơ sở dữ
-- liệu, Tin học đại cương, mạng máy tính
select c.maSV, tenSV
from MONHOC a , KETQUA b, SINHVIEN c
where (a.maMH=b.maMH) and (c.maSV=b.maSV) and
(tenMH=N'Toán cao cấp' or tenMH=N'Lý thuyết cơ sở dữ liệu' or tenMH=N'Mạng máy tính')
--3.1 union

--4
select MaMH, tenMH
from Monhoc
EXCEPT
select mh.MaMH, tenMH
from Monhoc as mh join Ketqua as kq on mh.MaMH = kq.MaMH
where kq.MaSV = 1
--4.1 left join, where NULL
select Mh.MaMH, TenMH, Diem
from ((Sinhvien as sv right join Ketqua as kq on sv.MaSV = kq.MaSV) left join Monhoc as mh on
kq.MaMH = mh.MaMH)
where sv.MaSV = 1 and Diem is null

select Diem
from Sinhvien as sv right join Ketqua as kq on sv.MaSV = kq.MaSV
--4.2
select MaMH, TenMH from Monhoc
where MaMH not in (select MaMH from Ketqua where MaSV = 1)

--5
select max(Diem)
from Sinhvien a, ketqua b
where a.MaSV = b.MaSV and MaMH = 1

--6 Cho biết mã sinh viên, tên những sinh viên có điểm thi môn 2 không thấp nhất khoa
select sv.MaSV, tenSV
from Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV
where MaMH = 2
EXCEPT
select top 1 sv.MaSV, tenSV
from Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV
where MaMH = 2 and diem <> (select min(diem) from Ketqua where MaMH = 2)
--6.1
select a.masv, Tensv
from sinhvien a join ketqua b on a.Masv=b.Masv
where mamh=2 and diem <>(select min(diem) from ketqua where mamh=2)

--7 Cho biết mã sinh viên và tên những sinh viên có điểm thi môn 1 lớn hơn điểm thi môn 1 của 
--  sinh viên có mã số 3
select a.MaSV, tenSV
from Sinhvien a join Ketqua b on a.MaSV = b.MaSV
where MaMh = 1 and Diem >(select (diem) from Ketqua where MaSV = 3 and MaMH = 1)

--8 Cho biết số sinh viên phải thi lại môn Toán Cao cấp
select count(MaSV) as 'So SV thi lai toan cao cap'
from Monhoc b, Ketqua c
where b.MaMH = c.MaMH and Diem < 4 and TenMH = N'Toán cao cấp'

--9 Đối với mỗi môn, cho biết tên môn và số sinh viên phải thi lại môn đó mà số sinh viên thi lại >=2
SELECT TenMH AS N'Tên MH' , COUNT(Distinct a.MaSV) AS N'số lượng'
FROM  SINHVIEN a, MONHOC b, KETQUA c
WHERE diem < 5 and a.masv = c.masv and b.MaMH = c.MaMH
GROUP BY tenmh HAVING COUNT(Distinct a.MaSV) >=2

--10 Cho biết mã sinh viên, tên và lớp của sinh viên đạt điểm cao nhất môn Tin đại cương
select sv.MaSV, TenSV, Lop
from Sinhvien as sv, Ketqua as kq, Monhoc as mh
where TenMH = N'Tin đại cương' and Diem = (select max(Diem) from Ketqua where TenMH = N'Tin đại cương' and sv.MaSV = kq.MaSV)
--10.1
select Sinhvien.MaSV, TenSV, Lop
from Sinhvien, Ketqua, Monhoc
where TenMH = N'Tin đại cương' and Diem >= all(select diem from Ketqua where TenMH = N'Tin đại cương') and Sinhvien.MaSV = Ketqua.MaSV

--11 Cho biết mã số và tên của những sinh viên tham gia thi tất cả các môn. (Giả sử cần thi tất cả các 
--   môn có trong bảng Môn học)
select sv.Masv,Tensv 
from Sinhvien sv, Monhoc mh, Ketqua kq
where sv.MaSV = kq.MaSV and kq.MaMH = mh.MaMH
group by sv.MaSV, TenSV	
having count(mh.MaMH) = (select count(MaMH) from Monhoc)

--12 Cho biết mã sinh viên và tên của sinh viên có điểm trung bình chung học tập >=6
select sv.MaSV, tenSV, round(SUM(Diem * DVHT)/SUM(cast(DVHT as float)), 1) as 'DTB'
from Sinhvien sv, Monhoc mh, Ketqua kq
where sv.MaSV = kq.MaSV and mh.MaMH = kq.MaMH
group by sv.MaSV, TenSV
having SUM(Diem * DVHT)/SUM(cast(DVHT as float)) >= 6

--13 Cho danh sách tên và mã sinh viên có điểm trung bình chung lớn hơn điểm trung bình của toàn khóa
select sv.MaSV, tenSV, sum(Diem * DVHT)/sum(DVHT) as 'DTB'
from (Sinhvien as sv join Ketqua as kq on sv.MaSV = kq.MaSV) join Monhoc as mh on mh.MaMH = kq.MaMH
group by sv.MaSV, TenSV
having sum(Diem * DVHT)/sum(DVHT) >= (select sum(diem*DVHT)/sum(DVHT) as 'DTBTK' from Ketqua kq join Monhoc mh on kq.MaMH = mh.MaMH)

--*14 Cho biết mã sinh viên và tên những sinh viên phải thi lại ở ít nhất là những môn mà sinh viên có mã số 3 phải thi lại
select sv.MaSV, TenSV
from (Sinhvien sv join Ketqua kq on sv.MaSV = kq.MaSV) join Monhoc mh on kq.MaMH = mh.MaMH
where diem < 4 and mh.MaMH in (select mh.MaMH from Monhoc, Ketqua where Ketqua.MaMH = Monhoc.MaMH and MaSV = 3 and Diem < 5)
--14.1
select Sinhvien.MaSV, Sinhvien.TenSV, maMH, Diem
from Ketqua, Sinhvien
where Sinhvien.MaSV = Ketqua.MaSV and Ketqua.Diem < 4 and Ketqua.MaMH 
in (select MaMH from Ketqua.,
--*15 Cho mã sinh viên và tên của những sinh viên có hơn nửa số điểm >=5.
select distinct sv.MaSV, tenSV, count(maMH) as N'so luong diem >= 5'
from Sinhvien sv, Ketqua kq
where sv.MaSV = kq.MaSV and diem >= 5
group by sv.MaSV, TenSV
having count(MaMH) >= (select count(distinct MaMH)/2 from Ketqua)
--*16 Cho danh sách mã sinh viên, tên sinh viên có điểm môn Tin đại cương cao nhất của mỗi lớp.
select tenSV, a.MaSV, a.lop, c.diem
from Sinhvien a, Monhoc b, Ketqua c,
	(select lop, max(diem) as Diem
	from Sinhvien a, Monhoc b, Ketqua c
	where a.MaSV=c.MaSV and b.MaMH=c.MaMH and TenMH = N'Tin đại cương'
	group by lop) as MaxDiem
where a.maSV = c.maSV and b.maMH=c.maMH and MaxDiem.lop=a.lop and c.diem=MaxDiem.Diem and TenMH = N'Tin đại cương'
-- 16.1
select masv, tensv, B1.lop, diem
from	(select lop, max(diem) as MaxDiem
		from (Sinhvien a join Ketqua b on a.MaSV = b.MaSV) join Monhoc c on b.MaMH= c.MaMH
		where tenMH like N'Tin đại cương'
		group by lop) as B1
		join
		(select a.masv, tensv, lop, diem
		from (Sinhvien a join Ketqua b on a.MaSV= b.MaSV) join Monhoc c on b.MaMH = c.MaMH
		where TenMH like N'Tin đại cương') as B2
		on B1.Lop = B2.Lop
where (diem=MaxDiem)
--*17 Cho danh sách tên và mã sinh viên có điểm trung bình chung lớn hơn điểm trung bình của lớp 
--	  sinh viên đó theo học.
