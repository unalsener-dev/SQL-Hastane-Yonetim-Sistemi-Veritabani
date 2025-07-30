# SQL Hastane Yönetim Sistemi Veritabanı Projesi
Bu proje, temel bir hastane yönetim sisteminin ihtiyaçlarını karşılamak üzere tasarlanmış ilişkisel bir SQL veritabanı şeması ve örnek veriler içerir. Proje, SQL Server (T-SQL) kullanılarak geliştirilmiştir ve veritabanı tasarımı, veri ekleme ve sorgulama konularında pratik bir örnek sunmayı amaçlamaktadır.

Projenin Amacı
Bu projenin temel amacı, hasta kayıtları, doktor bilgileri, eczane işlemleri, reçeteler ve tahlil sonuçları gibi temel sağlık verilerini yönetmek için yapılandırılmış bir veritabanı oluşturmaktır. Veritabanı, bu varlıklar arasındaki ilişkileri (foreign keys) kullanarak veri bütünlüğünü sağlar.

Veritabanı Şeması
Veritabanı, aşağıdaki 6 ana tablodan oluşmaktadır:
hasta: Hastaların demografik bilgilerini tutar.
doktor: Doktorların sicil numarası, uzmanlık alanı ve maaş gibi bilgilerini içerir.
eczane: Eczanelerin iletişim ve adres bilgilerini barındırır.
recete: Yazılan reçetelerdeki ilaç adı, fiyatı ve toplam tutar gibi detayları saklar.
hasta_detay: Hasta, doktor, eczane ve reçete tabloları arasında köprü kurarak muayene kayıtlarını oluşturur.
tahlil: Hastalara yapılan tahlillerin sonuçlarını ve maliyetlerini içerir.

Dosyalar
Bu repoda iki ana SQL dosyası bulunmaktadır:

Veritabani_Olusturma.sql:
Yukarıda belirtilen 6 tabloyu CREATE TABLE komutlarıyla oluşturur.
Tablolar arasındaki ilişkileri FOREIGN KEY kısıtlamalarıyla tanımlar.
INSERT INTO komutlarıyla veritabanını test etmek ve sorguları çalıştırmak için gerekli olan örnek verileri ekler.

Sorgular.sql:
Veritabanı üzerinde çeşitli analizler yapmak ve spesifik bilgilere ulaşmak için yazılmış 10 adet örnek SELECT sorgusu içerir.
Bu sorgular, JOIN, GROUP BY, HAVING, alt sorgular (subqueries) ve çeşitli SQL fonksiyonlarının kullanımını gösterir.

Nasıl Kullanılır?
Veritabanını Oluşturma:
Microsoft SQL Server Management Studio (SSMS) veya uyumlu bir SQL istemcisi açın.
Yeni bir veritabanı oluşturun (örneğin, HastaneDB).
Veritabani_Olusturma.sql dosyasının içeriğini kopyalayıp sorgu ekranına yapıştırın ve çalıştırın. Bu işlem, tabloları oluşturacak ve örnek verileri ekleyecektir.

Sorguları Çalıştırma:
Tablolar ve veriler hazır olduğunda, Sorgular.sql dosyasının içeriğini yeni bir sorgu ekranında açın.
İstediğiniz sorguyu veya tüm sorguları seçerek çalıştırın ve sonuçları analiz edin.

Bu proje, SQL öğrenenler veya küçük ölçekli bir sağlık bilgi sistemi veritabanı tasarlamak isteyenler için bir başlangıç noktası olarak kullanılabilir.
