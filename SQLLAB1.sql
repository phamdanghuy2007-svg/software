DECLARE @BANGTAM3 TABLE(
    TENPHG NVARCHAR(15),
    MAPHG INT,
    TRPHG NVARCHAR(9),
    NG_NHANCHUC DATE
);
INSERT INTO @BANGTAM3 (TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
SELECT TENPHG, MAPHG, TRPHG, NG_NHANCHUC
FROM PHONGBAN
WHERE MAPHG=(
    SELECT TOP 1 PHG
    FROM NHANVIEN
    WHERE PHG IS NOT NULL
    GROUP BY PHG
    ORDER BY COUNT(MANV) DESC
);
SELECT*FROM @BANGTAM3;
Declare @Bangtam3 table (
    TENPHG nvarchar(15),
    MAPHG int,
    TRPHG nvarchar(9),
    NG_NHANCHUC DATE,
    quantity int
)

INSERT INTO @Bangtam3
SELECT TOP 1 
    pb.TENPHG, 
    pb.MAPHG, 
    pb.TRPHG, 
    pb.NG_NHANCHUC,
    count (nv.MANV)
FROM 
    PHONGBAN pb
JOIN 
    NHANVIEN nv ON pb.MAPHG = nv.PHG
GROUP BY 
    pb.TENPHG, pb.MAPHG, pb.TRPHG, pb.NG_NHANCHUC
ORDER BY 
    COUNT(nv.MANV) DESC;
SELECT * FROM @Bangtam3
1.3 Bảng tạm
-- Temporary Table hay còn gọi là bảng tạm,
--đây là một dạng table đặc biệt được lưu trữ tạm thời trên SQL Server,
--nó rất hữu ích để lưu kết quả của một câu truy vấn SELECT nào đó để sử dụng nhiều lần.
-- -Bảng tạm cũng là một table nên nó có đầy đủ các tính chất của table,
--nghĩa là bạn có thể thực hiện các thao tác như 
--SELECT, INSERT, UPDATE, DELETE trên đó một cách bình thường.
--Khi ngắt kết nối thì các bảng tạm sẽ mất
vd: tạo bảng tạm: temptable1
luu thông tin của các nhân viên la nu
c1: create table #temptable1 (thuoc tinh ...)
c2: SELECT
    select_list
INTO
    #temporary_table
FROM
    table_name
....
select * 
    into #temptable2
from nhanvien
where phai like N'Nữ'
-- xem thong tin bang tam
select * from #temptable2
vd2:
select*from nhanvien
select*from THANNHAN
--tao bang tam lay tt cua cac nhan vien ko co than nhan
SELECT *
INTO #BANGTAM5
FROM NHANVIEN
WHERE MANV NOT IN (
    SELECT MA_NVIEN
    FROM THANNHAN
)
SELECT * FROM #BANGTAM5
--not in lay nhieu,not = lay 1
--cach 2
select n.*
	into #bangtam2
from nhanvien n
left join thannhan t on n.manv = t.ma_nvien
where t.ma_nvien is null;

select * from #bangtam2;
--ket hop 2 bang r loai cai nao null
--ma nv ben trai ket hop ma tn ben trai den khi nao phat hien null
vd3:tao bang tam 3 luu tt tat ca cac phong ban
+ so luong nv,so du an cua phong ban do
SELECT 
    pb.TENPHG AS [Tên Phòng],
    COUNT(DISTINCT nv.MANV) AS [Số NV],
    COUNT(DISTINCT da.MADA) AS [Số Dự Án]
INTO #temptable7
FROM PHONGBAN pb
LEFT JOIN NHANVIEN nv ON pb.MAPHG = nv.PHG  
LEFT JOIN DEAN da ON pb.MAPHG = da.PHONG     
--phong ban o giua nhan vien va group nen se ket noi 2 bang kia lai
GROUP BY pb.TENPHG
SELECT * FROM #temptable7
--cach 2
select p.* ,count(n.manv) as'so nhan vien',count(d.mada) as'so du an'

into #tam1

from phongban p
join nhanvien n on n.phg = p.maphg
join dean d  on d.phong=p.maphg
group by p.tenphg,p.trphg,p.ng_nhanchuc,p.maphg

select * from #tam1
Ham chuyen doi du lieu
print N'Nguyen Pham Dang Huy'+19
print getdate()--May 19 2026  8:52AM
-- CAST Syntax:  
CAST (expression AS data_type [ ( length ) ] )  
-- Hàm Convert
-- CONVERT Syntax:  
CONVERT (data_type [ ( length ) ] , expression [ , style ] )
 vd1:print N'Nguyen Pham Dang Huy'+cast(19 as varchar(50))
 print N'Nguyen Pham Dang Huy'+convert( varchar(50),20)
 --khi can dinh dang dl thi nen  dung convert data_type [ ( length ) ] , expression [ , style ] )
 vd: lay thong tin manv,ngaysinh theo dinh dang yyyy-MM-đ
 select manv,convert(date,ngsinh ,104) 
 from nhanvien
 vd1:tinh luong tb toan cong ty
select cast(avg(luong) as decimal(10,2)) as N'luong tb'
from nhanvien
vd2: tb luong cua tung phong ban
select phg,convert(nvarchar(50),avg(luong)) as N'tb'
from nhanvien
group by phg