-- 1.Soru : Yasam isimli eczaneden en �ok al�nan ila� yasam eczanesi d���nda hangi eczanelerde vard�r? 
-- (En �ok al�nan ilac�n ad�n� ve eczane adlar�n� yasam eczanesi dahil olacak sekilde listeleyin.)
SELECT DISTINCT r.ilac_ad, e.ad FROM recete r INNER JOIN eczane e ON r.eczane_id = e.eczane_id
WHERE r.ilac_ad = (
    SELECT TOP 1 ilac_ad FROM recete
    WHERE eczane_id = (SELECT eczane_id FROM eczane WHERE ad = 'Hayat Eczanesi')
    GROUP BY ilac_ad
    ORDER BY COUNT(ilac_ad) DESC
)


-- 2.Soru : En az doktoru olan bolum ve bu bolumdeki doktorlar�n yazd�klar� ila�lar�n adlar�n� listeleyin.
SELECT DISTINCT d.bolum, r.ilac_ad FROM recete r INNER JOIN hasta_detay hd ON r.recete_id = hd.recete_no 
INNER JOIN doktor d ON d.sicil_no = hd.dr_no
WHERE d.bolum = (
        SELECT TOP 1 bolum 
        FROM doktor 
        GROUP BY bolum
        ORDER BY COUNT(*) ASC
    )
	
-- 3.Soru : Parasal olarak en az tahlil masraf� olan ki�i ya da ki�ilerin adlar�n�n ilk 2 harfini ve son 3 harfini listeleyiniz.
SELECT LEFT(h.ad,2) as ilkIkiHarf, RIGHT(h.ad,3) as sonUcHarf FROM hasta h 
WHERE h.tc_no IN(
	SELECT t.tc_no FROM tahlil t
	WHERE t.t_fiyat = (SELECT MIN(t_fiyat) FROM tahlil)
)


-- 4.Soru : 11 haziran 2023 tarihinde 5 adetten fazla ila� satan eczanelerin adlar�n� ve ka� adet ila� satt���n� listeleyiniz.
SELECT e.ad, COUNT(*) as adet FROM recete r INNER JOIN eczane e ON e.eczane_id = r.eczane_id
WHERE r.tarih = '2023-06-11'
GROUP BY e.ad
HAVING COUNT(*) > 5


-- 5.Soru : 50 den fazla hastan�n bulundu�u �ehirlerdeki hastalar�n en �ok muayane oldu�u doktorun bolumu nedir. Select ile ��z�n�z.
SELECT d.bolum, d.ad, d.soyad FROM doktor d
WHERE d.sicil_no = (
	SELECT TOP 1 hd.dr_no FROM hasta_detay hd INNER JOIN hasta h ON h.tc_no = hd.h_tcno
	WHERE h.sehir IN(
		SELECT sehir FROM hasta 
		GROUP BY sehir
		HAVING COUNT(*) > 50
	)
	GROUP BY hd.dr_no 
	ORDER BY COUNT(*) DESC 
)


-- 6.Soru : 2023 y�l�nda 100 den fazla ila� satan eczanelerden adlar� a ile ba�layanlar�n adlar�n� listeleyiniz.
SELECT e.ad FROM eczane e INNER JOIN  recete r ON e.eczane_id = r.eczane_id
WHERE e.ad LIKE 'a%' AND YEAR(r.tarih) = 2023 
GROUP BY e.ad
HAVING COUNT(*) > 100


-- 7.Soru : Re�ete tutar� ortalama re�ete tutar�ndan y�ksek olan re�eteleri alan hastalar�n ad ve soyad bilgisiyle bu re�eteleri yazan doktorun ad ve b�l�m bilgisini listeleyiniz.
SELECT h.ad as hastaAdi, h.soyad as hastaSoyadi, d.ad as doktorAdi, d.soyad as doktorSoyadi, d.bolum as doktorBolum 
FROM hasta h INNER JOIN hasta_detay hd ON h.tc_no = hd.h_tcno INNER JOIN recete r ON r.recete_id = hd.recete_no 
INNER JOIN doktor d ON d.sicil_no = hd.dr_no 
WHERE r.tutar > (SELECT AVG(tutar) FROM recete)


-- 8.Soru : Doktorun �al��t��� b�l�m baz�nda ka�ar adet aspirin isimli ila� yaz�lm��t�r?
SELECT d.bolum, COUNT(*) as aspirinAdet FROM doktor d INNER JOIN hasta_detay hd ON hd.dr_no = d.sicil_no INNER JOIN recete r ON r.recete_id = hd.recete_no 
WHERE r.ilac_ad = 'aspirin'
GROUP BY d.bolum


-- 9.Soru : Her hasta re�ete tutar�n�n sadece %20 sini �dedi�ini varsayarsak temmuz 2020 ay�nda her bir hastan�n �dedi�i re�ete tutar� nedir?(Sadece tc_no listelensin)
SELECT h.tc_no, SUM(r.tutar*0.2) as odeme FROM hasta h INNER JOIN hasta_detay hd ON hd.h_tcno = h.tc_no INNER JOIN recete r ON hd.recete_no = r.recete_id
WHERE YEAR(r.tarih) = '2020' AND MONTH(r.tarih) = '7'
GROUP BY h.tc_no


-- 10.Soru : 2014 y�l�n�n �ubat ay�nda 10 adetten fazla ila� yazan doktorlar�n ad ve soyadlar�n� listeleyiniz.
SELECT d.ad, d.soyad FROM doktor d INNER JOIN hasta_detay hd ON d.sicil_no = hd.dr_no INNER JOIN recete r ON r.recete_id = hd.recete_no
WHERE YEAR(r.tarih) = 2014 AND MONTH(r.tarih) = 2
GROUP BY d.sicil_no, d.ad, d.soyad
HAVING COUNT(*)>10