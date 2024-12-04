-- Creates tables holding dataset information (see database.R)

DROP TABLE IF EXISTS public.dscmdlog;
DROP TABLE IF EXISTS public."dslabel";
DROP TABLE IF EXISTS public."dsvariable";
DROP TABLE IF EXISTS public."dsorigin";
DROP TABLE IF EXISTS public."dsdataset";

CREATE TABLE IF NOT EXISTS public."dsdataset"
(
    "datano" serial PRIMARY KEY,
    "version" text COLLATE pg_catalog."default" NOT NULL,
    "projectname" text COLLATE pg_catalog."default" NOT NULL,
    "filepath" text COLLATE pg_catalog."default" NOT NULL,
    "filedate" timestamp without time zone,
    "hash" text COLLATE pg_catalog."default" NOT NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."dsdataset"
    OWNER to "TabBooks";


CREATE TABLE IF NOT EXISTS public."dsvariable"
(
    "datano" integer NOT NULL,
    "var" text COLLATE pg_catalog."default" NOT NULL,
    "type" text COLLATE pg_catalog."default" NOT NULL,
    "varlab" text COLLATE pg_catalog."default" NOT NULL,
    "hash" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "dsvariablepkey" PRIMARY KEY ("datano", "var"),
  	CONSTRAINT "dsvariablefkey" FOREIGN KEY ("datano")
	  REFERENCES public."dsdataset" ("datano") MATCH SIMPLE
  	ON UPDATE CASCADE
	  ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."dsvariable"
    OWNER to "TabBooks";



CREATE TABLE IF NOT EXISTS public.dslabel
(
    "datano" integer NOT NULL,
    "var" text COLLATE pg_catalog."default",
    "nv" double precision,
    "vallab" text COLLATE pg_catalog."default",
    CONSTRAINT "dslabelpkey" PRIMARY KEY ("datano", "var", "nv"),
  	CONSTRAINT "dslabelfkey" FOREIGN KEY ("datano", "var")
	  REFERENCES public."dsvariable" ("datano", "var") MATCH SIMPLE
  	ON UPDATE CASCADE
	  ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.dslabel
    OWNER to "TabBooks";


CREATE TABLE IF NOT EXISTS public.dscmdlog
(
    datano integer NOT NULL,
    sheet text COLLATE pg_catalog."default",
    action text COLLATE pg_catalog."default",
    "row" text COLLATE pg_catalog."default",
    new_var text COLLATE pg_catalog."default",
    "raw" text COLLATE pg_catalog."default",
    error text COLLATE pg_catalog."default",
  	CONSTRAINT "dscmdlogfkey" FOREIGN KEY ("datano")
	  REFERENCES public."dsdataset" ("datano") MATCH SIMPLE
  	ON UPDATE CASCADE
	  ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.dscmdlog
    OWNER to "TabBooks";

CREATE TABLE IF NOT EXISTS public."dsorigin"
(
    "datano" integer NOT NULL,
	  "origin" integer NOT NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."dsorigin"
    OWNER to "TabBooks";
