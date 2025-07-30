-- 1.Soru : Yasam isimli eczaneden en çok alýnan ilaç yasam eczanesi dýþýnda hangi eczanelerde vardýr? 
-- (En çok alýnan ilacýn adýný ve eczane adlarýný yasam eczanesi dahil olacak sekilde listeleyin.)
SELECT DISTINCT r.ilac_ad, e.ad FROM recete r INNER JOIN eczane e ON r.eczane_id = e.eczane_id
WHERE r.ilac_ad = (
    SELECT TOP 1 ilac_ad FROM recete
    WHERE eczane_id = (SELECT eczane_id FROM eczane WHERE ad = 'Hayat Eczanesi')
    GROUP BY ilac_ad
    ORDER BY COUNT(ilac_ad) DESC
)


-- 2.Soru : En az doktoru olan bolum ve bu bolumdeki doktorlarýn yazdýklarý ilaçlarýn adlarýný listeleyin.
SELECT DISTINCT d.bolum, r.ilac_ad FROM recete r INNER JOIN hasta_detay hd ON r.recete_id = hd.recete_no 
INNER JOIN doktor d ON d.sicil_no = hd.dr_no
WHERE d.bolum = (
        SELECT TOP 1 bolum 
        FROM doktor 
        GROUP BY bolum
        ORDER BY COUNT(*) ASC
    )
	
-- 3.Soru : Parasal olarak en az tahlil masrafý olan kiþi ya da kiþilerin adlarýnýn ilk 2 harfini ve son 3 harfini listeleyiniz.
SELECT LEFT(h.ad,2) as ilkIkiHarf, RIGHT(h.ad,3) as sonUcHarf FROM hasta h 
WHERE h.tc_no IN(
	SELECT t.tc_no FROM tahlil t
	WHERE t.t_fiyat = (SELECT MIN(t_fiyat) FROM tahlil)
)


-- 4.Soru : 11 haziran 2023 tarihinde 5 adetten fazla ilaç satan eczanelerin adlarýný ve kaç adet ilaç sattýðýný listeleyiniz.
SELECT e.ad, COUNT(*) as adet FROM recete r INNER JOIN eczane e ON e.eczane_id = r.eczane_id
WHERE r.tarih = '2023-06-11'
GROUP BY e.ad
HAVING COUNT(*) > 5


-- 5.Soru : 50 den fazla hastanýn bulunduðu þehirlerdeki hastalarýn en çok muayane olduðu doktorun bolumu nedir. Select ile çözünüz.
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


-- 6.Soru : 2023 yýlýnda 100 den fazla ilaç satan eczanelerden adlarý a ile baþlayanlarýn adlarýný listeleyiniz.
SELECT e.ad FROM eczane e INNER JOIN  recete r ON e.eczane_id = r.eczane_id
WHERE e.ad LIKE 'a%' AND YEAR(r.tarih) = 2023 
GROUP BY e.ad
HAVING COUNT(*) > 100


-- 7.Soru : Reçete tutarý ortalama reçete tutarýndan yüksek olan reçeteleri alan hastalarýn ad ve soyad bilgisiyle bu reçeteleri yazan doktorun ad ve bölüm bilgisini listeleyiniz.
SELECT h.ad as hastaAdi, h.soyad as hastaSoyadi, d.ad as doktorAdi, d.soyad as doktorSoyadi, d.bolum as doktorBolum 
FROM hasta h INNER JOIN hasta_detay hd ON h.tc_no = hd.h_tcno INNER JOIN recete r ON r.recete_id = hd.recete_no 
INNER JOIN doktor d ON d.sicil_no = hd.dr_no 
WHERE r.tutar > (SELECT AVG(tutar) FROM recete)


-- 8.Soru : Doktorun çalýþtýðý bölüm bazýnda kaçar adet aspirin isimli ilaç yazýlmýþtýr?
SELECT d.bolum, COUNT(*) as aspirinAdet FROM doktor d INNER JOIN hasta_detay hd ON hd.dr_no = d.sicil_no INNER JOIN recete r ON r.recete_id = hd.recete_no 
WHERE r.ilac_ad = 'aspirin'
GROUP BY d.bolum


-- 9.Soru : Her hasta reçete tutarýnýn sadece %20 sini ödediðini varsayarsak temmuz 2020 ayýnda her bir hastanýn ödediði reçete tutarý nedir?(Sadece tc_no listelensin)
SELECT h.tc_no, SUM(r.tutar*0.2) as odeme FROM hasta h INNER JOIN hasta_detay hd ON hd.h_tcno = h.tc_no INNER JOIN recete r ON hd.recete_no = r.recete_id
WHERE YEAR(r.tarih) = '2020' AND MONTH(r.tarih) = '7'
GROUP BY h.tc_no


-- 10.Soru : 2014 yýlýnýn Þubat ayýnda 10 adetten fazla ilaç yazan doktorlarýn ad ve soyadlarýný listeleyiniz.
SELECT d.ad, d.soyad FROM doktor d INNER JOIN hasta_detay hd ON d.sicil_no = hd.dr_no INNER JOIN recete r ON r.recete_id = hd.recete_no
WHERE YEAR(r.tarih) = 2014 AND MONTH(r.tarih) = 2
GROUP BY d.sicil_no, d.ad, d.soyad
HAVING COUNT(*)>10