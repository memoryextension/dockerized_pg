--
-- PostgreSQL database dump
--

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

CREATE DATABASE carthage WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
ALTER DATABASE carthage OWNER TO postgres;

\connect carthage


-- per https://x-team.com/blog/automatic-timestamps-with-postgresql/ 

CREATE OR REPLACE FUNCTION public.trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;




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

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.client (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE public.library (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150) NOT NULL,
    attachment_folder VARCHAR(255) NOT NULL,
    client_id INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY(id),
    CONSTRAINT fk_client
      FOREIGN KEY(client_id) 
	     REFERENCES public.client(id)
);

CREATE TABLE public.record (
    id INT GENERATED ALWAYS AS IDENTITY,
    data jsonb NOT NULL,
    library_id INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY(id),
    CONSTRAINT fk_library
      FOREIGN KEY(library_id) 
	     REFERENCES public.library(id)
);

CREATE TABLE public.attachment (
    id INT GENERATED ALWAYS AS IDENTITY,
    attachment_path VARCHAR(255) NOT NULL,
    library_id INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY(id),
    CONSTRAINT fk_library
      FOREIGN KEY(library_id) 
	     REFERENCES public.library(id) 
);


ALTER TABLE public.client OWNER TO postgres;
ALTER TABLE public.library OWNER TO postgres;
ALTER TABLE public.record OWNER TO postgres;
ALTER TABLE public.attachment OWNER TO postgres;

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public.client
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public.library
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public.record
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public.attachment
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

-- prepopulate
COPY public.client (name) FROM stdin;
NY Office
Madrid Office
VLC Office
\.

COPY public.library (name,attachment_folder,client_id) FROM stdin (Delimiter ',');;
NY Library,attach_client1,1
VLC Library,vlc_files,3
\.


-- ALL DONE