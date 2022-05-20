--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Ubuntu 14.2-1.pgdg20.04+1+b1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-19 21:11:40 EDT

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
-- TOC entry 2 (class 3079 OID 198334)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4356 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 198290)
-- Name: messages; Type: TABLE; Schema: public; Owner: tpemykhqhjpokb
--

CREATE TABLE public.messages (
    messageid integer NOT NULL,
    userid integer,
    text text,
    createddate date DEFAULT CURRENT_DATE NOT NULL,
    topic text,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.messages OWNER TO tpemykhqhjpokb;

--
-- TOC entry 211 (class 1259 OID 198298)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: tpemykhqhjpokb
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO tpemykhqhjpokb;

--
-- TOC entry 4357 (class 0 OID 0)
-- Dependencies: 211
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tpemykhqhjpokb
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.messageid;


--
-- TOC entry 212 (class 1259 OID 198300)
-- Name: users; Type: TABLE; Schema: public; Owner: tpemykhqhjpokb
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text,
    createddate date DEFAULT CURRENT_DATE NOT NULL,
    password text NOT NULL,
    signedin text DEFAULT 'No'::text
);


ALTER TABLE public.users OWNER TO tpemykhqhjpokb;

--
-- TOC entry 213 (class 1259 OID 198306)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: tpemykhqhjpokb
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO tpemykhqhjpokb;

--
-- TOC entry 4358 (class 0 OID 0)
-- Dependencies: 213
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tpemykhqhjpokb
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4194 (class 2604 OID 198307)
-- Name: messages messageid; Type: DEFAULT; Schema: public; Owner: tpemykhqhjpokb
--

ALTER TABLE ONLY public.messages ALTER COLUMN messageid SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 4197 (class 2604 OID 198309)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: tpemykhqhjpokb
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4345 (class 0 OID 198290)
-- Dependencies: 210
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: tpemykhqhjpokb
--

COPY public.messages (messageid, userid, text, createddate, topic, time_created) FROM stdin;
19	8	Who binged Season 2 of Bridgerton on Netflix??? Vitamin String Quartet's rendition of "Dancing on My Own" yes or YES?!?!	2022-04-07	Music	2022-04-07 07:41:49.892573+00
20	9	Did ya'll hear Ash Barty retired from tennis?!?!? What the jdfklgjdklgjfld!!!!	2022-04-02	Sports	2022-04-02 01:43:46.969378+00
16	3	Hi!	2022-03-30	General	2022-03-30 15:43:46.969378+00
18	3	So....What are ya'll's thoughts on NFT's???  😳\t	2022-04-01	Art	2022-04-01 16:40:23.992173+00
17	7	Has anyone seen "Dune"??? If so, what did you think of the cinematography??	2022-03-30	Film & TV	2022-03-30 11:37:47.674843+00
21	8	Yo!\n	2022-04-01	General	2022-04-01 19:45:40.349723+00
648	36	I've only seen the first version. It was pretty rad.\n	2022-05-13	Film & TV	2022-05-13 02:14:03.962651+00
649	36	But I'm looking forward to seeing the new version when I get a chance.	2022-05-13	Film & TV	2022-05-13 02:15:17.905821+00
650	37	Hi!\n	2022-05-14	General	2022-05-14 09:32:38.802283+00
651	37	Wow\n	2022-05-14	General	2022-05-14 13:01:28.17195+00
652	38	Hi\n	2022-05-14	General	2022-05-14 13:01:28.795102+00
653	37	lkjsndf\n	2022-05-14	General	2022-05-14 13:01:34.906743+00
654	38	Jeder der das liest hat ehre :)	2022-05-14	General	2022-05-14 13:02:06.949402+00
657	1	A Masterpiece!!!!\n	2022-05-16	Music	2022-05-16 04:49:20.845569+00
150	29	hi\n	2022-04-18	General	2022-04-18 23:13:23.901049+00
1	1	Hey! Welcome to ChatSpace, thanks for stopping by! 👋🏾	2022-03-23	General	2022-03-23 01:28:56.070438+00
\.


--
-- TOC entry 4347 (class 0 OID 198300)
-- Dependencies: 212
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: tpemykhqhjpokb
--

COPY public.users (id, username, createddate, password, signedin) FROM stdin;
2	CrysTest	2022-04-07	$2b$12$ehTtkfy937eywd0nf8UaJunMYgfMaHEeq1fTPpTb.HrbwjGsnoxte	No
4	test123	2022-04-07	$2b$12$v1.3M8N2mT4C3PdGAxaLnui618sbLBsPsnkMeYa0.VPow84AUECrS	No
8	Nolan Ross	2022-04-07	$2b$12$JzbRiiMmHJrDas8V7Xl9J.u4DBQGA2bO4QKYk9sD7mn2iXHowPiJy	No
37	StCanute	2022-05-14	$2b$12$kq.TqvgBisv/sg9YDB8pleucOmwVvvN/kWaj3hxBbIT13oo4ts59K	Yes
29	JohnFuhrm	2022-04-18	$2b$12$sVWf5XLNsApySgzgdYKD0OYKp.aZje77Fwm4RsDPAmnX0Iy7ueE6O	No
7	Jack Porter	2022-04-07	$2b$12$WKdiCKigVAdA1nmg18iRCOJK3ZTJp9t5Ru7M57by3OEkGswPUbXK2	No
38	DaniNATOR	2022-05-14	$2b$12$GeoyYS0f6YpWENfbrwQSl.GM3i4DS7NhQdToosFUMrqjijwApD0/m	Yes
3	Emily Thorne	2022-04-07	$2b$12$VYfx7GRNDShFhS7OHskXqedboOfFWZWnuLIDstcNpP.2WbSTyrG5e	No
33	Francesca Bridgerton	2022-05-13	$2b$12$oLvDYI8FJKdD6e6bdDoPzutTo7vqA1/IDidCewsxRxtTYqapxksN6	No
5	testing	2022-04-07	$2b$12$Q3WPfEUaiAuhNWwXBn6tYOWY07Cab1en.o9ga5mcQ42r3BM3CfFxC	No
6	tests	2022-04-07	$2b$12$5nksJGKcKRHCCWN0EnVItuN76tAJP1UUXlQDjyy99Ak9f7pud.GpC	No
1	Crystal W	2022-04-07	$2b$12$kw4LfV/t64qOxEkTvZoqcOOIWXkz/RGnYY9Uk9iC0iTYkFGjqGf0S	No
34	Billie Sutton	2022-05-13	$2b$12$BXdib6wTNZWByxKUc0QwNOZWbbaHva4seXHJyhC1YjcVPzpUXuQVe	No
28	cguruadmin	2022-04-14	$2b$12$CuTT7VFu/cbezmkZ504M7u2pZ5eS/YNjNqj2I0hlWAsz90iPNXvXe	No
30	Kate Bridgerton	2022-05-11	$2b$12$cynndo8xjYHwYKwSZOzUneotNy2ZwrzGTR000yyaiH53RXE6/VSSK	No
11	Aiden Mathis	2022-04-07	$2b$12$TyqUEs/YeXGXsBWfcTp7RukqwzYC8fyNfKCek7HpxML6PX0BGUosq	No
9	Charlotte Grayson Clarke	2022-04-07	$2b$12$1kMhx6jYjewXyLSyEeb8fO/4IEqo/B.Ukhpltv4F6Kox1nlProA9q	No
35	Testing	2022-05-13	$2b$12$NW7jrIFqtj/Yq6EhZ3JpHuUSyCKMEgwtLdjIdHSJqfpeO6H3/MKbe	No
31	Anthony Bridgerton	2022-05-11	$2b$12$FMMAjeo1jsxkhddBl1G3/OUMoXkzS/cSZc/O/etsx1pea6SBUpnQe	No
32	Newton Bridgerton	2022-05-12	$2b$12$bd.5sx6BhgmpXyhD30zzleLoWi69rnKgEdwIjiNSbvIO/elu5qr3q	No
36	Trevor	2022-05-13	$2b$12$KIckYX4ZpUDnFhfXl4lGDumjCcmbJ/lATOJz8AJ93nXMq54WOQvte	No
\.


--
-- TOC entry 4359 (class 0 OID 0)
-- Dependencies: 211
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tpemykhqhjpokb
--

SELECT pg_catalog.setval('public.messages_id_seq', 657, true);


--
-- TOC entry 4360 (class 0 OID 0)
-- Dependencies: 213
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tpemykhqhjpokb
--

SELECT pg_catalog.setval('public.users_id_seq', 38, true);


--
-- TOC entry 4200 (class 2606 OID 198314)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: tpemykhqhjpokb
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (messageid);


--
-- TOC entry 4202 (class 2606 OID 198316)
-- Name: users username; Type: CONSTRAINT; Schema: public; Owner: tpemykhqhjpokb
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT username UNIQUE (username);


--
-- TOC entry 4204 (class 2606 OID 198319)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: tpemykhqhjpokb
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4205 (class 2606 OID 198320)
-- Name: messages messages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tpemykhqhjpokb
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- TOC entry 4354 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: tpemykhqhjpokb
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO tpemykhqhjpokb;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 4355 (class 0 OID 0)
-- Dependencies: 868
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO tpemykhqhjpokb;


-- Completed on 2022-05-19 21:11:41 EDT

--
-- PostgreSQL database dump complete
--

