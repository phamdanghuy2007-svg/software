LÝ THUYẾT 4. CẤU TRÚC ĐIỀU KIỆN & LẶP

1. Khối Begin… end
Cú pháp:
BEGIN
    { sql_statement | statement_block}
END
Begin có thể lồng nhau
2. Cấu trúc if… else
Cú pháp:
IF Boolean_expression
BEGIN
    -- Statement block executes when the Boolean expression is TRUE
END
ELSE
BEGIN
    -- Statement block executes when the Boolean expression is FALSE
END
vd1:khai bao bien tuoi cua ng yeu;
neu tuoi<16:thong bao"can than"
neu<18:thong bao"can than it hon"
neu<28:"ban qua gioi r"
neu>28:"thi ban la phi cong"

declare @tuoi int
set @tuoi = 20 
if @tuoi<16
begin
print'can than'
end
else if @tuoi<18
begin
print'can than it hon'
end
else if @tuoi<28
begin
print'ban qua gioi r'
end
else if @tuoi>28
begin
print'ban la phi cong'
end
vd2: neu muc luong TB cua nv>3000 thi tb thu nhap cao


declare @luong float
select @luong = avg(LUONG) from NHANVIEN
if @luong > 3000
begin
print'thu nhap cao' 
end
else
begin 
print'thu nhap thap'
end
3. Hàm IIF
Cú pháp
IIF ( boolean_expression, true_value, false_value )
vd1: kiem tra gioi tinh;
neu la nu thi dua ra tb print'be thi an hai lon thi bay di'
neu la nam print'bao'
select phai, iif(phai='Nam','bao','be thi an hai lon thi bay di') as 'thong bao'
from NHANVIEN
vd2: lay ra manv,tuoi neu tuoi >55 dua ra tb cho ve huu

select MANV,NGSINH,iif( YEAR(GETDATE()) - YEAR(NGSINH) > 55,N'cho về hưu',N'vẫn bào dc')
from NHANVIEN
select*from nhanvien
4.simple case
SELECT MANV,TENNV,LUONG,
    CASE PHG
        WHEN 5 THEN N'cho đi nc ngoài'
		WHEN 1 THEN N'cho đi phú quốc'
        ELSE N'ở nhà cho khỏe'
    END AS CongTac
FROM NHANVIEN;
--hien thi ma nv,ten nv,luong nv,tang luong.biet neu luong > luong tb thi dc tang
SELECT MANV, TENNV, LUONG,
       CASE 
           WHEN LUONG < (SELECT AVG(LUONG) FROM NHANVIEN) 
                THEN N'Được tăng lương'
           ELSE N'Không tăng lương'
       END AS TangLuong
FROM NHANVIEN;
vd:lay ra manv,tennv,luong ,luong moi
neu luong <= 25000 thi tang 20%
neu luong <=35000 thi tang 15%
neu luong <=50000 thi tang 10%
con lai giu nguyen
SELECT MANV, TENNV, LUONG,
       CASE 
           WHEN LUONG <= 25000 
                THEN LUONG * 1.2
           WHEN LUONG <= 35000 
                THEN LUONG * 1.15   
           WHEN LUONG <= 50000 
                THEN LUONG * 1.1  
           ELSE LUONG           
       END AS LuongMoi
FROM NHANVIEN;
--5. Cấu trúc lặp
Cú pháp:
WHILE condition
BEGIN
    // statement
END
Ví dụ
DECLARE @counter INT = 1;
  
WHILE @counter <= 5
BEGIN
    PRINT @counter;
    -SET @counter = @counter + 1;
END

