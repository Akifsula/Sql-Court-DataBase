--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enkalabalikmahkeme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.enkalabalikmahkeme() RETURNS TABLE(mahkeme_adi character varying, toplam_kisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT "public"."Mahkeme"."MahkemeAdi", MAX("public"."MahkemeKisi"."ToplamKisi") AS "ToplamKisiSayisi"
  FROM "public"."Mahkeme"
  JOIN "public"."MahkemeKisi" ON "public"."Mahkeme"."MahkemeNo" = "public"."MahkemeKisi"."MahkemeNo"
  GROUP BY "public"."Mahkeme"."MahkemeNo"
  ORDER BY "ToplamKisiSayisi" DESC
  LIMIT 1;
END;
$$;


ALTER FUNCTION public.enkalabalikmahkeme() OWNER TO postgres;

--
-- Name: sivil_sayisi_hesapla(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sivil_sayisi_hesapla() RETURNS TABLE("MahkemeAdi" character varying, "SivilSayisi" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT ON ("public"."Mahkeme"."MahkemeNo")
        "public"."Mahkeme"."MahkemeAdi",
        "public"."MahkemeKisi"."ToplamKisi" - "public"."MahkemeKisi"."PersonalSayisi" AS "SivilSayisi"
    FROM
        "public"."Mahkeme"
        JOIN "public"."MahkemeKisi" ON "public"."Mahkeme"."MahkemeNo" = "public"."MahkemeKisi"."MahkemeNo"
    ORDER BY "public"."Mahkeme"."MahkemeNo", "public"."MahkemeKisi"."ToplamKisi" DESC;
END;
$$;


ALTER FUNCTION public.sivil_sayisi_hesapla() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Adres" (
    "Koordinat" double precision NOT NULL,
    "Il" character varying(255) NOT NULL,
    "Ilce" character varying(255) NOT NULL
);


ALTER TABLE public."Adres" OWNER TO postgres;

--
-- Name: Avukat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Avukat" (
    "TcKimlikNo" bigint NOT NULL,
    "UzmanlikAlani" character varying NOT NULL,
    "DavaliTcNo" bigint NOT NULL,
    "DavaciTcNo" bigint NOT NULL
);


ALTER TABLE public."Avukat" OWNER TO postgres;

--
-- Name: Ceza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ceza" (
    "CezaNo" bigint NOT NULL,
    "Tur" character varying(255) NOT NULL,
    "Miktar" bigint NOT NULL,
    "CaydiricilikSeviyesi" character varying(255) NOT NULL,
    "HakimTcNo" bigint NOT NULL
);


ALTER TABLE public."Ceza" OWNER TO postgres;

--
-- Name: Dava; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Dava" (
    "DavaNo" integer NOT NULL,
    "DavaTarihi" date NOT NULL,
    "HakimTcNo" bigint NOT NULL,
    "DavaciTcNo" bigint NOT NULL
);


ALTER TABLE public."Dava" OWNER TO postgres;

--
-- Name: DavaDosyasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DavaDosyasi" (
    "DosyaNo" integer NOT NULL,
    "SavciTcNo" bigint NOT NULL,
    "TutanakNo" integer NOT NULL,
    "KararNo" integer NOT NULL,
    "Dosyaİliski" integer,
    "AvukatTcNo" bigint NOT NULL
);


ALTER TABLE public."DavaDosyasi" OWNER TO postgres;

--
-- Name: Davaci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Davaci" (
    "TcKimlikNo" bigint NOT NULL,
    "Meslek" character varying NOT NULL,
    "Cinsiyet" character varying NOT NULL,
    "AvukatTcNo" bigint
);


ALTER TABLE public."Davaci" OWNER TO postgres;

--
-- Name: Davali; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Davali" (
    "TcKimlikNo" bigint NOT NULL,
    "Sabika" character varying NOT NULL,
    "Yas" integer NOT NULL,
    "AvukatTcNo" bigint,
    "SavciTcNo" bigint
);


ALTER TABLE public."Davali" OWNER TO postgres;

--
-- Name: DavaliSuc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DavaliSuc" (
    "SucNo" character varying NOT NULL,
    "Tarih" date NOT NULL,
    "Saat" character varying,
    "Sehir" character varying NOT NULL,
    "DavaliTcNo" bigint NOT NULL
);


ALTER TABLE public."DavaliSuc" OWNER TO postgres;

--
-- Name: Hakim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Hakim" (
    "TcKimlikNo" bigint NOT NULL,
    "Kidemlilik" character varying NOT NULL
);


ALTER TABLE public."Hakim" OWNER TO postgres;

--
-- Name: Kanit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kanit" (
    "KanitNo" integer NOT NULL,
    "Derece" character varying NOT NULL,
    "Tutarlılık" character varying NOT NULL,
    "SavciTcNo" bigint NOT NULL
);


ALTER TABLE public."Kanit" OWNER TO postgres;

--
-- Name: Kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kisi" (
    "TcKimlikNo" bigint NOT NULL,
    "Ad" character varying(255) NOT NULL,
    "Soyad" character varying(255) NOT NULL,
    "TelefonNo" bigint NOT NULL,
    "Cinsiyet" character varying(10) NOT NULL,
    "Yetkili" boolean NOT NULL,
    "Vatandas" boolean NOT NULL,
    "AdresKoordinat" double precision NOT NULL
);


ALTER TABLE public."Kisi" OWNER TO postgres;

--
-- Name: Mahkeme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Mahkeme" (
    "MahkemeNo" integer NOT NULL,
    "MahkemeAdi" character varying(255) NOT NULL,
    "AdresNo" double precision
);


ALTER TABLE public."Mahkeme" OWNER TO postgres;

--
-- Name: MahkemeKisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MahkemeKisi" (
    "ToplamKisi" integer NOT NULL,
    "PersonalSayisi" integer NOT NULL,
    "MahkemeNo" integer NOT NULL,
    "TcKimlikNo" bigint NOT NULL
);


ALTER TABLE public."MahkemeKisi" OWNER TO postgres;

--
-- Name: Sahit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sahit" (
    "TcKimlikNo" bigint NOT NULL,
    "TaniklikTürü" character varying NOT NULL
);


ALTER TABLE public."Sahit" OWNER TO postgres;

--
-- Name: Salon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Salon" (
    "SalonNo" integer NOT NULL,
    "MahkemeNo" integer NOT NULL,
    "Kapasite" integer NOT NULL,
    "Blok" character(1) NOT NULL
);


ALTER TABLE public."Salon" OWNER TO postgres;

--
-- Name: Savci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Savci" (
    "TcKimlikNo" bigint NOT NULL,
    "Yetki" character varying NOT NULL,
    "CalismaGunu" character varying NOT NULL,
    "CalismaSaati" integer NOT NULL
);


ALTER TABLE public."Savci" OWNER TO postgres;

--
-- Name: Suc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Suc" (
    "SucNo" character varying NOT NULL,
    "Tur" character varying NOT NULL,
    "SavciTcNo" bigint NOT NULL
);


ALTER TABLE public."Suc" OWNER TO postgres;

--
-- Name: SucSahitlik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SucSahitlik" (
    "SahitTcNo" bigint NOT NULL,
    "SucNo" character varying NOT NULL,
    "TaniklikTarihi" date NOT NULL,
    "TaniklikSaati" character varying NOT NULL
);


ALTER TABLE public."SucSahitlik" OWNER TO postgres;

--
-- Name: Vatandas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Vatandas" (
    "TcKimlikNo" bigint NOT NULL,
    "MedeniHal" character varying NOT NULL,
    "Email" character varying NOT NULL,
    "VatandasRol" character varying NOT NULL
);


ALTER TABLE public."Vatandas" OWNER TO postgres;

--
-- Name: Yetkili; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Yetkili" (
    "TcKimlikNo" bigint NOT NULL,
    "SicilNo" integer NOT NULL,
    "Meslek" character varying NOT NULL
);


ALTER TABLE public."Yetkili" OWNER TO postgres;

--
-- Data for Name: Adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Adres" VALUES
	(41.0053, 'Trabzon', 'Ortahisar'),
	(35.8715, 'Konya', 'Selçuklu'),
	(28.4192, 'Izmir', 'Konak'),
	(23.5373, 'Adana', 'Seyhan'),
	(19.7764, 'Eskişehir', 'Tepebaşı'),
	(38.4152, 'Izmir', 'Konak'),
	(36.8821, 'Antalya', 'Konyaaltı'),
	(37.0503, 'Adana', 'Seyhan'),
	(37.9687, 'Diyarbakır', 'Bağlar'),
	(37.8315, 'Konya', 'Selçuklu'),
	(39.4573, 'Eskişehir', 'Tepebaşı'),
	(39.4324, 'Ankara', 'Çankaya'),
	(39.4379, 'Ankara', 'Çankaya'),
	(41.4923, 'Istanbul', 'Beşiktaş'),
	(41.0472, 'Istanbul', 'Beşiktaş'),
	(47.9112, 'Diyarbakır', 'Bağlar'),
	(50.1538, 'Bursa', 'Osmangazi'),
	(50.3794, 'Bursa', 'Osmangazi'),
	(56.5921, 'Antalya', 'Konyaaltı'),
	(10.9331, 'Ankara', 'Çankaya'),
	(11.0518, 'Istanbul', 'Pendik'),
	(12.4152, 'Izmir', 'Karşıyaka'),
	(13.1813, 'Bursa', 'Osmangazi'),
	(14.8821, 'Antalya', 'Muratpaşa'),
	(15.0503, 'Adana', 'Seyhan'),
	(16.8053, 'Trabzon', 'Ortahisar'),
	(17.775, 'Eskişehir', 'Odunpazarı'),
	(18.9687, 'Diyarbakır', 'Yenişehir'),
	(19.8315, 'Konya', 'Meram'),
	(20.4531, 'Ankara', 'Eryaman'),
	(22.4152, 'Izmir', 'Bornova'),
	(23.1813, 'Bursa', 'Osmangazi'),
	(24.8821, 'Antalya', 'Aksu'),
	(25.0503, 'Adana', 'Çukurova'),
	(26.8053, 'Trabzon', 'Ortahisar'),
	(27.775, 'Eskişehir', 'Mahmudiye'),
	(28.9687, 'Diyarbakır', 'Sur'),
	(29.8315, 'Konya', 'Karatay'),
	(30.9331, 'Ankara', 'Polatlı'),
	(31.0518, 'Istanbul', 'Mecidiyeköy'),
	(32.4152, 'Izmir', 'Buca'),
	(33.1813, 'Bursa', 'Osmangazi'),
	(34.8821, 'Antalya', 'Kepez'),
	(35.0503, 'Adana', 'Sarıçam'),
	(36.8053, 'Trabzon', 'Ortahisar'),
	(38.9687, 'Diyarbakır', 'Karapınar'),
	(39.8315, 'Konya', 'Eregli'),
	(40.9331, 'Istanbul', 'Üsküdar'),
	(41.0518, 'Istanbul', 'Beşiktaş'),
	(42.4152, 'Istanbul', 'Başakşehir'),
	(43.1813, 'Istanbul', 'Bagcılar'),
	(44.8821, 'Istanbul', 'Bakırköy'),
	(45.0503, 'Istanbul', 'Sefaköy'),
	(46.8053, 'Istanbul', 'Beylikdüzü'),
	(48.9687, 'Istanbul', 'Zeytinburnu'),
	(49.8315, 'Istanbul', 'Kadıköy'),
	(41.0538, 'Trabzon', 'Ortahisar'),
	(47.7759, 'Istanbul', 'Avcılar'),
	(37.775, 'Eskişehir', 'Seyitgazi'),
	(21.0518, 'Istanbul', 'Şişli');


--
-- Data for Name: Avukat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Avukat" VALUES
	(10993720210, 'Aile Hukuku', 12345678901, 10301039472),
	(14568476655, 'Ticaret Hukuku', 19741571663, 14538573920),
	(18387321373, 'Gayrimenkul Hukuku', 41417837855, 15546788321),
	(21662778000, 'Şirketler Hukuku', 42395710471, 24556829421),
	(42992348989, 'Ceza Hukuku', 55814771933, 35582975013),
	(53679467502, 'İcra İflas Hukuku', 57510165993, 42597392849),
	(75031884406, 'Bilişim Hukuku', 57917401277, 57729571041),
	(86060919899, 'Mirastan Red Hukuku', 67890123456, 57882917742),
	(97242727593, 'İdare Hukuku', 88572613805, 77288467295),
	(35693289983, 'İş Hukuku', 52571784803, 27295764022);


--
-- Data for Name: Ceza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Ceza" VALUES
	(1, 'Hapis(gün)', 5000, 'Yüksek', 12345782478),
	(2, 'Para Cezası', 7500, 'Orta', 13245297319),
	(3, 'Hapis(gün)', 10000, 'Yüksek', 28745455368),
	(4, 'Para Cezası', 3000, 'Düşük', 31894277120),
	(5, 'Hapis(gün)', 1000, 'Düşük', 41710102846),
	(6, 'Para Cezası', 6000, 'Orta', 42741975113),
	(7, 'Hapis(gün)', 4000, 'Yüksek', 49094093286),
	(8, 'Para Cezası', 2000, 'Düşük', 66617536841),
	(9, 'Hapis(gün)', 12000, 'Yüksek', 77356297211),
	(10, 'Para Cezası', 1500, 'Düşük', 87297491732);


--
-- Data for Name: Dava; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Dava" VALUES
	(1, '2023-01-10', 12345782478, 10301039472),
	(2, '2023-02-15', 13245297319, 14538573920),
	(3, '2023-03-20', 28745455368, 15546788321),
	(4, '2023-04-25', 31894277120, 24556829421),
	(5, '2023-05-30', 41710102846, 27295764022),
	(6, '2023-06-05', 42741975113, 35582975013),
	(7, '2023-07-10', 49094093286, 42597392849),
	(8, '2023-08-15', 66617536841, 57729571041),
	(9, '2023-09-20', 77356297211, 57882917742),
	(10, '2023-10-25', 87297491732, 77288467295);


--
-- Data for Name: DavaDosyasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."DavaDosyasi" VALUES
	(1, 14258940277, 100, 200, NULL, 10993720210),
	(2, 22237492749, 101, 201, 1, 14568476655),
	(3, 28733649274, 102, 202, NULL, 18387321373),
	(4, 31378471913, 103, 203, NULL, 21662778000),
	(5, 34778916428, 104, 204, 3, 35693289983),
	(6, 38400047281, 105, 205, NULL, 42992348989),
	(7, 44118304027, 106, 206, 6, 53679467502),
	(8, 45792268310, 107, 207, NULL, 75031884406),
	(9, 45838023103, 108, 208, NULL, 86060919899),
	(10, 56176648291, 109, 209, 4, 97242727593);


--
-- Data for Name: Davaci; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Davaci" VALUES
	(24556829421, 'Polis', 'Erkek', 21662778000),
	(27295764022, 'Doktor', 'Kadın', 35693289983),
	(42597392849, 'Öğrenci', 'Kadın', 53679467502),
	(57729571041, 'Mühendis', 'Erkek', 75031884406),
	(57882917742, 'Ev Hanımı', 'Kadın', 86060919899),
	(77288467295, 'Hemşire', 'Erkek', 97242727593),
	(10301039472, 'İşsiz', 'Erkek', 10993720210),
	(14538573920, 'Öğretmen', 'Kadın', 14568476655),
	(15546788321, 'İşsiz', 'Kadın', 18387321373),
	(35582975013, 'Mimar', 'Erkek', 42992348989);


--
-- Data for Name: Davali; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Davali" VALUES
	(12345678901, 'temiz', 30, 10993720210, 14258940277),
	(19741571663, 'temiz', 40, 14568476655, 22237492749),
	(41417837855, 'temiz', 22, 18387321373, 28733649274),
	(42395710471, 'kirli', 25, 21662778000, 31378471913),
	(52571784803, 'kirli', 61, 35693289983, 34778916428),
	(55814771933, 'temiz', 38, 42992348989, 38400047281),
	(57917401277, 'kirli', 28, 75031884406, 45792268310),
	(67890123456, 'kirli', 32, 86060919899, 45838023103),
	(88572613805, 'temiz', 55, 97242727593, 56176648291),
	(57510165993, 'kirli', 35, 53679467502, 44118304027);


--
-- Data for Name: DavaliSuc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."DavaliSuc" VALUES
	('A123', '2022-10-15', '14.00', 'Ankara', 12345678901),
	('B456', '2015-09-03', '0.00', 'Konya', 88572613805),
	('C789', '2023-01-20', '15.30', 'İstanbul', 19741571663),
	('D101', '2012-03-05', '16.45', 'İzmir', 41417837855),
	('E202', '2022-12-12', NULL, 'Bursa', 42395710471),
	('F303', '2018-04-01', '18.00', 'Antalya', 52571784803),
	('G404', '2009-02-22', '19.24', 'Adana', 55814771933),
	('H505', '2023-11-08', '9.45', 'Trabzon', 57510165993),
	('I606', '2023-05-10', '21.10', 'Eskişehir', 57917401277),
	('J707', '2011-07-15', NULL, 'Gaziantep', 67890123456);


--
-- Data for Name: Hakim; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Hakim" VALUES
	(87297491732, 'Yeni'),
	(77356297211, 'Orta'),
	(49094093286, 'Deneyimli'),
	(42741975113, 'Kıdemli'),
	(28745455368, 'Yeni'),
	(66617536841, 'Orta'),
	(31894277120, 'Deneyimli'),
	(13245297319, 'Kıdemli'),
	(12345782478, 'Yeni'),
	(41710102846, 'Orta');


--
-- Data for Name: Kanit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Kanit" VALUES
	(1, 'Yüksek', 'Tutarlı', 14258940277),
	(2, 'Orta', 'tutarsız', 22237492749),
	(3, 'Düşük', 'Tutarlı', 28733649274),
	(4, 'Yüksek', 'Tutarlı', 31378471913),
	(5, 'Orta', 'tutarsız', 34778916428),
	(6, 'Düşük', 'Tutarlı', 38400047281),
	(7, 'Yüksek', 'tutarsız', 44118304027),
	(8, 'Orta', 'Tutarlı', 45792268310),
	(9, 'Düşük', 'Tutarlı', 45838023103),
	(10, 'Yüksek', 'tutarsız', 56176648291);


--
-- Data for Name: Kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Kisi" VALUES
	(28733649274, 'Veli', 'Demir', 5536590074, 'Erkek', true, true, 34.8821),
	(31378471913, 'Banu', 'Koçer', 5558901564, 'Kadın', true, false, 35.0503),
	(19578250183, 'Ali', 'Korkusuz', 5414489902, 'Erkek', false, true, 50.1538),
	(34778916428, 'Cemil', 'Öz', 5418865493, 'Erkek', true, false, 35.8715),
	(38400047281, 'Deniz', 'Bitken', 5535790068, 'Kadın', true, false, 36.8053),
	(59825628889, 'Polat', 'Alemdar', 5307863376, 'Erkek', false, true, 10.9331),
	(57269040773, 'Huriye', 'Topal', 5054990876, 'Kadın', false, true, 11.0518),
	(77582619327, 'Sevim', 'Palamut', 5558864091, 'Kadın', false, true, 12.4152),
	(82763100138, 'Hüseyin', 'Koç', 5056689633, 'Erkek', false, true, 13.1813),
	(87547391128, 'Selin', 'Gündogdu', 5557499776, 'Kadın', false, true, 14.8821),
	(10993720210, 'Ahmet', 'Yılmaz', 5551234567, 'Erkek', true, false, 15.0503),
	(14568476655, 'Ayşe', 'Kaya', 5537583621, 'Kadın', true, true, 16.8053),
	(18387321373, 'Mehmet', 'Öztürk', 5416804621, 'Erkek', true, false, 17.775),
	(21662778000, 'Fatma', 'Yıldız', 5057749263, 'Kadın', true, false, 18.9687),
	(35693289983, 'Mustafa', 'Çelik', 5327337838, 'Erkek', true, false, 19.7764),
	(42992348989, 'Zeynep', 'Aydın', 5056849271, 'Kadın', true, false, 19.8315),
	(53679467502, 'Ali', 'Demir', 5061846244, 'Erkek', true, true, 20.4531),
	(75031884406, 'Gizem', 'Aydos', 5303403568, 'Kadın', true, false, 21.0518),
	(86060919899, 'Cem', 'Yılmaz', 5557384673, 'Erkek', true, true, 22.4152),
	(97242727593, 'Deniz', 'Özkan', 5551011121, 'Kadın', true, false, 23.1813),
	(12345782478, 'Ercan', 'Ateş', 5303827488, 'Erkek', true, false, 23.5373),
	(28745455368, 'Hüseyin', 'Yılmaz', 5551314151, 'Erkek', true, false, 24.8821),
	(13245297319, 'Sevim', 'Kara', 5326748234, 'Kadın', true, false, 25.0503),
	(31894277120, 'Selin', 'Çelik', 5327558392, 'Kadın', true, true, 26.8053),
	(42741975113, 'Ece', 'Aksoy', 5539573372, 'Kadın', true, true, 27.775),
	(41710102846, 'Bora', 'Güneş', 5053748922, 'Erkek', true, false, 28.4192),
	(49094093286, 'Murat', 'Yılmaz', 5418374482, 'Erkek', true, false, 28.9687),
	(66617536841, 'Ayşe', 'Mutlu', 5300617832, 'Kadın', true, false, 29.8315),
	(87297491732, 'Fadime', 'Peksoy', 5554782694, 'Kadın', true, false, 30.9331),
	(77356297211, 'Kerim', 'Öztürk', 5410138741, 'Erkek', true, false, 31.0518),
	(14258940277, 'Akif', 'Sula', 5555674201, 'Erkek', true, false, 32.4152),
	(22237492749, 'Zeynep', 'Parlak', 5556789012, 'Kadın', true, false, 33.1813),
	(44118304027, 'Emin', 'Barut', 5551112131, 'Erkek', true, false, 36.8821),
	(45792268310, 'Eylül', 'Ak', 5307853666, 'Kadın', true, false, 37.0503),
	(45838023103, 'Abdül', 'Baki', 5328957478, 'Erkek', true, true, 37.775),
	(56176648291, 'Hümeyra', 'Bodur', 5555859606, 'Kadın', true, true, 37.8315),
	(14538573920, 'Ece', 'Bakırlı', 5558422947, 'Kadın', false, true, 37.9687),
	(10301039472, 'Boray', 'Tunç', 5537590127, 'Erkek', false, true, 38.4152),
	(15546788321, 'Nuran', 'Kaya', 5053448921, 'Kadın', false, true, 38.9687),
	(24556829421, 'Mehmet', 'Tekin', 5537759207, 'Erkek', false, true, 39.4324),
	(27295764022, 'Esma', 'Sert', 5305789221, 'Kadın', false, true, 39.4379),
	(35582975013, 'Onur', 'Dertli', 5555752902, 'Erkek', false, true, 39.4573),
	(42597392849, 'Begüm', 'Saygın', 5327589920, 'Kadın', false, true, 39.8315),
	(57729571041, 'Gökay', 'Yanıklar', 5455780164, 'Erkek', false, true, 40.9331),
	(57882917742, 'Şule', 'Çelenk', 5555723901, 'Kadın', false, true, 41.0053),
	(77288467295, 'Cemal', 'Yıkılgan', 5417592789, 'Erkek', false, true, 41.0472),
	(12345678901, 'Nursena', 'Özkan', 5061019478, 'Kadın', false, true, 41.0518),
	(19741571663, 'Mertcan', 'Pala', 5557558392, 'Erkek', false, true, 41.0538),
	(41417837855, 'Fadime', 'Temelli', 5327789321, 'Kadın', false, true, 41.4923),
	(42395710471, 'Çelebi', 'Efendioglu', 5534616794, 'Erkek', false, true, 42.4152),
	(52571784803, 'Selma', 'Güreli', 5556180048, 'Kadın', false, true, 43.1813),
	(55814771933, 'Eray', 'Navruz', 5558894728, 'Erkek', false, true, 44.8821),
	(57510165993, 'Ecenaz', 'Üçer', 5058849027, 'Kadın', false, true, 45.0503),
	(57917401277, 'Sevcan', 'Dinçer', 5057300732, 'Kadın', false, true, 46.8053),
	(67890123456, 'Kazım', 'Öztürk', 5308894758, 'Erkek', false, true, 47.7759),
	(88572613805, 'Fatma', 'Turgut', 5412239904, 'Kadın', false, true, 47.9112),
	(14980058287, 'Nedim', 'Kaygısız', 55314778892, 'Erkek', false, true, 48.9687),
	(43275008503, 'Gizem', 'Yeter', 5058893847, 'Kadın', false, true, 49.8315),
	(18745687450, 'Aybüke', 'Adıgüzel', 5539008422, 'Kadın', false, true, 50.3794),
	(54905745522, 'Çetin', 'Karslı', 5322256783, 'Erkek', false, true, 56.5921),
	(45454, 'aaaa', 'aaaa', 11111, 'erkek', true, false, 10.9331),
	(11111111, 'BBBBB', 'AAAAA', 121212, 'ERKEK', false, true, 10.9331),
	(313131, 'ERKEK', 'OĞLUERKEK', 31313131, 'ERRKEK', true, true, 11.0518),
	(133342324, 'adsasdsa', 'asadsdsadsa', 2332324, 'erkek', false, true, 11.0518),
	(142769142, 'Akif Emre', 'Sula', 5535868, 'erkek', true, false, 11.0518),
	(84823638492, 'sfsfsad', 'dsfdsafa', 4433233443, 'erkek', true, true, 11.0518),
	(41343124132, 'dsfdsa', 'dagds', 241324134124, 'dsfdsf', false, false, 50.3794),
	(4134312413, 'dsfds8a', 'dagds', 241324134124, 'dsfdsf', false, false, 34.8821),
	(1212, 'gdfgd', 'dfsgfdg', 6745745, 'erkek', true, false, 10.9331);


--
-- Data for Name: Mahkeme; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Mahkeme" VALUES
	(1, 'Ankara Adalet Mahkemesi', 10.9331),
	(2, 'İstanbul Ağır Ceza Mahkemesi', 21.0518),
	(3, 'İzmir Ceza Mahkemesi', 32.4152),
	(4, 'Adana İş Mahkemesi', 15.0503),
	(5, 'Antalya Aile Mahkemesi', 36.8821),
	(6, 'Bursa Ticaret Mahkemesi', 23.1813),
	(7, 'Eskişehir Sulh Hukuk Mahkemesi', 17.775),
	(8, 'Trabzon Çocuk Mahkemesi', 26.8053),
	(10, 'Diyarbakır Ceza İstinaf Mahkemesi', 38.9687),
	(9, 'İstanbul İdare Mahkemesi', 31.0518);


--
-- Data for Name: MahkemeKisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."MahkemeKisi" VALUES
	(25, 4, 1, 10301039472),
	(25, 4, 1, 10993720210),
	(25, 4, 1, 12345678901),
	(25, 4, 1, 12345782478),
	(25, 4, 1, 14258940277),
	(25, 4, 1, 14980058287),
	(25, 4, 1, 35582975013),
	(25, 4, 1, 38400047281),
	(25, 4, 1, 59825628889),
	(18, 3, 2, 13245297319),
	(18, 3, 2, 14538573920),
	(18, 3, 2, 14568476655),
	(18, 3, 2, 18745687450),
	(18, 3, 2, 19741571663),
	(18, 3, 2, 22237492749),
	(40, 4, 5, 41710102846),
	(40, 4, 5, 52571784803),
	(26, 4, 3, 15546788321),
	(26, 4, 3, 18387321373),
	(26, 4, 3, 19578250183),
	(26, 4, 3, 28733649274),
	(26, 4, 3, 28745455368),
	(26, 4, 3, 35582975013),
	(26, 4, 3, 35693289983),
	(26, 4, 3, 41417837855),
	(26, 4, 3, 57882917742),
	(35, 5, 4, 18745687450),
	(35, 5, 4, 21662778000),
	(35, 5, 4, 24556829421),
	(35, 5, 4, 28733649274),
	(35, 5, 4, 31378471913),
	(35, 5, 4, 31894277120),
	(35, 5, 4, 38400047281),
	(35, 5, 4, 42395710471),
	(35, 5, 4, 43275008503),
	(35, 5, 4, 82763100138),
	(40, 4, 5, 54905745522),
	(40, 4, 5, 56176648291),
	(40, 4, 5, 10301039472),
	(40, 4, 5, 27295764022),
	(40, 4, 5, 34778916428),
	(40, 4, 5, 35693289983),
	(40, 4, 5, 41417837855),
	(40, 4, 5, 57882917742),
	(40, 4, 5, 97242727593),
	(54, 5, 8, 88572613805),
	(17, 4, 9, 14568476655),
	(17, 4, 9, 35582975013),
	(55, 5, 6, 14258940277),
	(55, 5, 6, 19578250183),
	(55, 5, 6, 24556829421),
	(55, 5, 6, 35582975013),
	(55, 5, 6, 38400047281),
	(55, 5, 6, 42741975113),
	(55, 5, 6, 42992348989),
	(55, 5, 6, 53679467502),
	(55, 5, 6, 55814771933),
	(55, 5, 6, 57269040773),
	(55, 5, 6, 67890123456),
	(32, 4, 7, 18745687450),
	(32, 4, 7, 28733649274),
	(32, 4, 7, 42597392849),
	(32, 4, 7, 44118304027),
	(32, 4, 7, 49094093286),
	(32, 4, 7, 53679467502),
	(32, 4, 7, 57510165993),
	(32, 4, 7, 59825628889),
	(32, 4, 7, 82763100138),
	(54, 5, 8, 14538573920),
	(54, 5, 8, 19741571663),
	(54, 5, 8, 21662778000),
	(54, 5, 8, 35582975013),
	(54, 5, 8, 35693289983),
	(54, 5, 8, 45792268310),
	(54, 5, 8, 57729571041),
	(54, 5, 8, 57917401277),
	(54, 5, 8, 66617536841),
	(54, 5, 8, 75031884406),
	(54, 5, 8, 77582619327),
	(17, 4, 9, 45838023103),
	(17, 4, 9, 52571784803),
	(17, 4, 9, 57882917742),
	(17, 4, 9, 67890123456),
	(17, 4, 9, 77356297211),
	(17, 4, 9, 82763100138),
	(17, 4, 9, 86060919899),
	(75, 5, 10, 10993720210),
	(75, 5, 10, 24556829421),
	(75, 5, 10, 53679467502),
	(75, 5, 10, 54905745522),
	(75, 5, 10, 56176648291),
	(75, 5, 10, 57269040773),
	(75, 5, 10, 57510165993),
	(75, 5, 10, 59825628889),
	(75, 5, 10, 77288467295),
	(75, 5, 10, 87297491732),
	(75, 5, 10, 87547391128),
	(75, 5, 10, 88572613805),
	(75, 5, 10, 97242727593);


--
-- Data for Name: Sahit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Sahit" VALUES
	(19578250183, 'Görgü Tanığı'),
	(57269040773, 'Olay Yerine İlk Gelen'),
	(82763100138, 'Uzman Tanık'),
	(18745687450, 'Mağdur'),
	(59825628889, 'Görgü Tanığı'),
	(54905745522, 'Olay Yerine İlk Gelen'),
	(14980058287, 'Uzman Tanık'),
	(43275008503, 'Mağdur'),
	(87547391128, 'Görgü Tanığı'),
	(77582619327, 'Olay Yerine İlk Gelen');


--
-- Data for Name: Salon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Salon" VALUES
	(1001, 1, 50, 'A'),
	(1002, 2, 75, 'B'),
	(1003, 3, 100, 'C'),
	(1004, 4, 60, 'D'),
	(1005, 5, 80, 'E'),
	(1006, 6, 120, 'F'),
	(1007, 7, 90, 'G'),
	(1008, 8, 110, 'H'),
	(1009, 9, 70, 'I'),
	(1010, 10, 95, 'J');


--
-- Data for Name: Savci; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Savci" VALUES
	(28733649274, 'Ağır Ceza', 'Pazartesi', 8),
	(22237492749, 'Asliye Ceza', 'Çarşamba', 7),
	(14258940277, 'İdare Mahkemesi', 'Salı', 9),
	(45838023103, 'İş Mahkemesi', 'Perşembe', 6),
	(56176648291, 'Çocuk Mahkemesi', 'Cuma', 8),
	(34778916428, 'Ticaret Mahkemesi', 'Pazartesi', 7),
	(38400047281, 'İcra Mahkemesi', 'Salı', 8),
	(31378471913, 'Aile Mahkemesi', 'Cuma', 9),
	(45792268310, 'İdare Mahkemesi', 'Salı', 6),
	(44118304027, 'Asliye Ceza', 'Çarşamba', 8);


--
-- Data for Name: Suc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Suc" VALUES
	('A123', 'Hırsızlık', 14258940277),
	('B456', 'Dolandırıcılık', 22237492749),
	('C789', 'Uyuşturucu Madde Bulundurmak', 28733649274),
	('D101', 'Şiddet', 31378471913),
	('E202', 'Kamu Görevlisine Direniş', 34778916428),
	('F303', 'Gasp', 38400047281),
	('G404', 'Kamu Malına Zarar Verme', 44118304027),
	('H505', 'Silahla Tehdit', 45792268310),
	('I606', 'Vandalizm', 45838023103),
	('J707', 'Dilencilik', 56176648291);


--
-- Data for Name: SucSahitlik; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."SucSahitlik" VALUES
	(14980058287, 'A123', '2022-10-15', '14.00'),
	(18745687450, 'B456', '2023-01-20', '10:45'),
	(19578250183, 'C789', '2012-03-05', '12:15'),
	(43275008503, 'D101', '2022-12-12', '14:30'),
	(54905745522, 'E202', '2018-04-01', '16:00'),
	(57269040773, 'F303', '2009-02-22', '17:45'),
	(59825628889, 'G404', '2023-11-08', '19:00'),
	(77582619327, 'H505', '2023-05-10', '20:30'),
	(82763100138, 'I606', '2011-07-15', '22:00'),
	(87547391128, 'J707', '2015-09-03', '23:15');


--
-- Data for Name: Vatandas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Vatandas" VALUES
	(10301039472, 'Evli', 'boray@gmail.com', 'Davaci'),
	(14538573920, 'Bekar', 'ece@gmail.com', 'Davaci'),
	(15546788321, 'Evli', 'nuran@gmail.com', 'Davaci'),
	(24556829421, 'Bekar', 'mehmet@gmail.com', 'Davaci'),
	(27295764022, 'Evli', 'esma@gmail.com', 'Davaci'),
	(35582975013, 'Bekar', 'onur@gmail.com', 'Davaci'),
	(42597392849, 'Evli', 'begüm@gmail.com', 'Davaci'),
	(57729571041, 'Bekar', 'gökay@gmail.com', 'Davaci'),
	(57882917742, 'Evli', 'şule@gmail.com', 'Davaci'),
	(77288467295, 'Bekar', 'cemal@gmail.com', 'Davaci'),
	(12345678901, 'Evli', 'nursena@gmail.com', 'Davali'),
	(19741571663, 'Bekar', 'mertcan@gmail.com', 'Davali'),
	(41417837855, 'Evli', 'fadime@gmail.com', 'Davali'),
	(42395710471, 'Bekar', 'çelebi@gmail.com', 'Davali'),
	(52571784803, 'Evli', 'selma@gmail.com', 'Davali'),
	(55814771933, 'Bekar', 'eray@gmail.com', 'Davali'),
	(57510165993, 'Evli', 'ecenaz@gmail.com', 'Davali'),
	(57917401277, 'Bekar', 'sevcan@gmail.com', 'Davali'),
	(67890123456, 'Evli', 'kazım@gmail.com', 'Davali'),
	(88572613805, 'Bekar', 'fatma@gmail.com', 'Davali'),
	(14980058287, 'Evli', 'nedim@gmail.com', 'Sahit'),
	(18745687450, 'Bekar', 'aybüke@gmail.com', 'Sahit'),
	(19578250183, 'Evli', 'ali@gmail.com', 'Sahit'),
	(43275008503, 'Bekar', 'gizem@gmail.com', 'Sahit'),
	(54905745522, 'Evli', 'çetin@gmail.com', 'Sahit'),
	(57269040773, 'Bekar', 'huriye@gmail.com', 'Sahit'),
	(59825628889, 'Evli', 'polat@gmail.com', 'Sahit'),
	(77582619327, 'Bekar', 'sevim@gmail.com', 'Sahit'),
	(82763100138, 'Evli', 'hüseyin@gmail.com', 'Sahit'),
	(87547391128, 'Bekar', 'selin@gmail.com', 'Sahit');


--
-- Data for Name: Yetkili; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Yetkili" VALUES
	(14568476655, 1000002, 'Avukat'),
	(18387321373, 1000003, 'Avukat'),
	(21662778000, 1000004, 'Avukat'),
	(35693289983, 1000005, 'Avukat'),
	(42992348989, 1000006, 'Avukat'),
	(53679467502, 1000007, 'Avukat'),
	(75031884406, 1000008, 'Avukat'),
	(86060919899, 1000009, 'Avukat'),
	(97242727593, 1000010, 'Avukat'),
	(22237492749, 1000022, 'Savcı'),
	(28733649274, 1000023, 'Savcı'),
	(31378471913, 1000024, 'Savcı'),
	(34778916428, 1000025, 'Savcı'),
	(38400047281, 1000026, 'Savcı'),
	(44118304027, 1000027, 'Savcı'),
	(45792268310, 1000028, 'Savcı'),
	(45838023103, 1000029, 'Savcı'),
	(56176648291, 1000030, 'Savcı'),
	(87297491732, 1000020, 'Hakim'),
	(77356297211, 1000019, 'Hakim'),
	(66617536841, 1000018, 'Hakim'),
	(49094093286, 1000017, 'Hakim'),
	(42741975113, 1000016, 'Hakim'),
	(41710102846, 1000015, 'Hakim'),
	(31894277120, 1000014, 'Hakim'),
	(28745455368, 1000013, 'Hakim'),
	(10993720210, 1000001, 'Avukat'),
	(12345782478, 1000011, 'Hakim'),
	(13245297319, 1000012, 'Hakim'),
	(14258940277, 1000021, 'Savcı');


--
-- Name: Adres Adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Adres"
    ADD CONSTRAINT "Adres_pkey" PRIMARY KEY ("Koordinat");


--
-- Name: Ceza Ceza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ceza"
    ADD CONSTRAINT "Ceza_pkey" PRIMARY KEY ("CezaNo");


--
-- Name: DavaDosyasi DavaDosyasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaDosyasi"
    ADD CONSTRAINT "DavaDosyasi_pkey" PRIMARY KEY ("DosyaNo", "SavciTcNo");


--
-- Name: Dava Dava_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dava"
    ADD CONSTRAINT "Dava_pkey" PRIMARY KEY ("DavaNo", "DavaciTcNo");


--
-- Name: DavaliSuc DavaliSuc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaliSuc"
    ADD CONSTRAINT "DavaliSuc_pkey" PRIMARY KEY ("DavaliTcNo", "SucNo");


--
-- Name: Hakim Hakim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Hakim"
    ADD CONSTRAINT "Hakim_pkey" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Kisi Kisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kisi"
    ADD CONSTRAINT "Kisi_pkey" PRIMARY KEY ("TcKimlikNo");


--
-- Name: MahkemeKisi MahkemeKisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MahkemeKisi"
    ADD CONSTRAINT "MahkemeKisi_pkey" PRIMARY KEY ("MahkemeNo", "TcKimlikNo");


--
-- Name: Mahkeme Mahkeme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mahkeme"
    ADD CONSTRAINT "Mahkeme_pkey" PRIMARY KEY ("MahkemeNo");


--
-- Name: Sahit Sahit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sahit"
    ADD CONSTRAINT "Sahit_pkey" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Salon Salon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Salon"
    ADD CONSTRAINT "Salon_pkey" PRIMARY KEY ("SalonNo", "MahkemeNo");


--
-- Name: SucSahitlik SucSahitlik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SucSahitlik"
    ADD CONSTRAINT "SucSahitlik_pkey" PRIMARY KEY ("SahitTcNo", "SucNo");


--
-- Name: Vatandas Vatandas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vatandas"
    ADD CONSTRAINT "Vatandas_pkey" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Yetkili Yetkili_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yetkili"
    ADD CONSTRAINT "Yetkili_pkey" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Avukat unique_Avukat_TcKimlikNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Avukat"
    ADD CONSTRAINT "unique_Avukat_TcKimlikNo" PRIMARY KEY ("TcKimlikNo");


--
-- Name: DavaDosyasi unique_DavaDosyasi_DosyaNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaDosyasi"
    ADD CONSTRAINT "unique_DavaDosyasi_DosyaNo" UNIQUE ("DosyaNo");


--
-- Name: DavaDosyasi unique_DavaDosyasi_SavcıTcNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaDosyasi"
    ADD CONSTRAINT "unique_DavaDosyasi_SavcıTcNo" UNIQUE ("SavciTcNo");


--
-- Name: Dava unique_Dava_DavaNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dava"
    ADD CONSTRAINT "unique_Dava_DavaNo" UNIQUE ("DavaNo");


--
-- Name: Dava unique_Dava_DavacıTcNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dava"
    ADD CONSTRAINT "unique_Dava_DavacıTcNo" UNIQUE ("DavaciTcNo");


--
-- Name: Davaci unique_Davaci_TcKimlikNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davaci"
    ADD CONSTRAINT "unique_Davaci_TcKimlikNo" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Davali unique_Davali_TcKimlikNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davali"
    ADD CONSTRAINT "unique_Davali_TcKimlikNo" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Kanit unique_Kanit_KanitNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kanit"
    ADD CONSTRAINT "unique_Kanit_KanitNo" PRIMARY KEY ("KanitNo");


--
-- Name: MahkemeKisi unique_MahkemeKisi_MahkemeNo_TcKimlikNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MahkemeKisi"
    ADD CONSTRAINT "unique_MahkemeKisi_MahkemeNo_TcKimlikNo" UNIQUE ("MahkemeNo", "TcKimlikNo");


--
-- Name: Salon unique_Salon_SalonNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Salon"
    ADD CONSTRAINT "unique_Salon_SalonNo" UNIQUE ("SalonNo");


--
-- Name: Savci unique_Savci_TcKimlikNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Savci"
    ADD CONSTRAINT "unique_Savci_TcKimlikNo" PRIMARY KEY ("TcKimlikNo");


--
-- Name: Suc unique_Suc_SucNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Suc"
    ADD CONSTRAINT "unique_Suc_SucNo" PRIMARY KEY ("SucNo");


--
-- Name: Vatandas unique_Vatandas_Email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vatandas"
    ADD CONSTRAINT "unique_Vatandas_Email" UNIQUE ("Email");


--
-- Name: index_DosyaNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_DosyaNo" ON public."DavaDosyasi" USING btree ("DosyaNo");


--
-- Name: index_SalonNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_SalonNo" ON public."Salon" USING btree ("SalonNo");


--
-- Name: Kanit Ink_Savci_Kanit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kanit"
    ADD CONSTRAINT "Ink_Savci_Kanit" FOREIGN KEY ("SavciTcNo") REFERENCES public."Savci"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Avukat fk_Avukat_Yetkili; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Avukat"
    ADD CONSTRAINT "fk_Avukat_Yetkili" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Yetkili"("TcKimlikNo");


--
-- Name: Davaci fk_Davaci_Vatandas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davaci"
    ADD CONSTRAINT "fk_Davaci_Vatandas" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Vatandas"("TcKimlikNo");


--
-- Name: Davali fk_Davali_Vatandas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davali"
    ADD CONSTRAINT "fk_Davali_Vatandas" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Vatandas"("TcKimlikNo");


--
-- Name: Hakim fk_Hakim_Yetkili; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Hakim"
    ADD CONSTRAINT "fk_Hakim_Yetkili" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Yetkili"("TcKimlikNo");


--
-- Name: Sahit fk_Sahit_Vatandas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sahit"
    ADD CONSTRAINT "fk_Sahit_Vatandas" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Vatandas"("TcKimlikNo");


--
-- Name: Savci fk_Savci_Yetkili; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Savci"
    ADD CONSTRAINT "fk_Savci_Yetkili" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Yetkili"("TcKimlikNo");


--
-- Name: Vatandas fk_Vatandas_Kisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vatandas"
    ADD CONSTRAINT "fk_Vatandas_Kisi" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Kisi"("TcKimlikNo");


--
-- Name: Yetkili fk_Yetkili_Kisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yetkili"
    ADD CONSTRAINT "fk_Yetkili_Kisi" FOREIGN KEY ("TcKimlikNo") REFERENCES public."Kisi"("TcKimlikNo");


--
-- Name: Kisi lnk_Adres_Kisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kisi"
    ADD CONSTRAINT "lnk_Adres_Kisi" FOREIGN KEY ("AdresKoordinat") REFERENCES public."Adres"("Koordinat") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Mahkeme lnk_Adres_Mahkeme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mahkeme"
    ADD CONSTRAINT "lnk_Adres_Mahkeme" FOREIGN KEY ("AdresNo") REFERENCES public."Adres"("Koordinat") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DavaDosyasi lnk_Avukat_DavaDosyasi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaDosyasi"
    ADD CONSTRAINT "lnk_Avukat_DavaDosyasi" FOREIGN KEY ("AvukatTcNo") REFERENCES public."Avukat"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Davaci lnk_Avukat_Davaci; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davaci"
    ADD CONSTRAINT "lnk_Avukat_Davaci" FOREIGN KEY ("AvukatTcNo") REFERENCES public."Avukat"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Davali lnk_Avukat_Davali; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davali"
    ADD CONSTRAINT "lnk_Avukat_Davali" FOREIGN KEY ("AvukatTcNo") REFERENCES public."Avukat"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DavaDosyasi lnk_DavaDosyasi_DosyaIliski; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaDosyasi"
    ADD CONSTRAINT "lnk_DavaDosyasi_DosyaIliski" FOREIGN KEY ("Dosyaİliski") REFERENCES public."DavaDosyasi"("DosyaNo");


--
-- Name: Avukat lnk_Davaci_Avukat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Avukat"
    ADD CONSTRAINT "lnk_Davaci_Avukat" FOREIGN KEY ("DavaciTcNo") REFERENCES public."Davaci"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Avukat lnk_Davali_Avukat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Avukat"
    ADD CONSTRAINT "lnk_Davali_Avukat" FOREIGN KEY ("DavaliTcNo") REFERENCES public."Davali"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DavaliSuc lnk_Davali_DavaliSuc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaliSuc"
    ADD CONSTRAINT "lnk_Davali_DavaliSuc" FOREIGN KEY ("DavaliTcNo") REFERENCES public."Davali"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Ceza lnk_Hakim_Ceza; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ceza"
    ADD CONSTRAINT "lnk_Hakim_Ceza" FOREIGN KEY ("HakimTcNo") REFERENCES public."Hakim"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Dava lnk_Hakim_Dava; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dava"
    ADD CONSTRAINT "lnk_Hakim_Dava" FOREIGN KEY ("HakimTcNo") REFERENCES public."Hakim"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MahkemeKisi lnk_Mahkeme_MahkemeKisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MahkemeKisi"
    ADD CONSTRAINT "lnk_Mahkeme_MahkemeKisi" FOREIGN KEY ("MahkemeNo") REFERENCES public."Mahkeme"("MahkemeNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Salon lnk_Mahkeme_Salon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Salon"
    ADD CONSTRAINT "lnk_Mahkeme_Salon" FOREIGN KEY ("MahkemeNo") REFERENCES public."Mahkeme"("MahkemeNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SucSahitlik lnk_Sahit_SucSahitlik; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SucSahitlik"
    ADD CONSTRAINT "lnk_Sahit_SucSahitlik" FOREIGN KEY ("SahitTcNo") REFERENCES public."Sahit"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Davali lnk_Savci_Davali; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Davali"
    ADD CONSTRAINT "lnk_Savci_Davali" FOREIGN KEY ("SavciTcNo") REFERENCES public."Savci"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Suc lnk_Savci_Suc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Suc"
    ADD CONSTRAINT "lnk_Savci_Suc" FOREIGN KEY ("SavciTcNo") REFERENCES public."Savci"("TcKimlikNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DavaliSuc lnk_Suc_DavaliSuc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DavaliSuc"
    ADD CONSTRAINT "lnk_Suc_DavaliSuc" FOREIGN KEY ("SucNo") REFERENCES public."Suc"("SucNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SucSahitlik lnk_Suc_SucSahitlik; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SucSahitlik"
    ADD CONSTRAINT "lnk_Suc_SucSahitlik" FOREIGN KEY ("SucNo") REFERENCES public."Suc"("SucNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

