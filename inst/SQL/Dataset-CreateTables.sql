-- Creates tables holding dataset information (see database.R)

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
    CONSTRAINT "datasetpkey" PRIMARY KEY ("datano", "var"),
	CONSTRAINT "datasetfkey" FOREIGN KEY ("datano")
	REFERENCES public."dsdataset" ("datano") MATCH SIMPLE
	ON UPDATE CASCADE
	ON DELETE CASCADE

)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."dsvariable"
    OWNER to "TabBooks";

CREATE TABLE IF NOT EXISTS public."dsorigin"
(
    "datano" integer NOT NULL,
	"origin" integer NOT NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."dsorigin"
    OWNER to "TabBooks";